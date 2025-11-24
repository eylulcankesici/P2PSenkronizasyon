package watcher

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/usecase"
)

// EventHandler dosya değişiklik event'lerini işler
type EventHandler struct {
	fileRepo      repository.FileRepository
	chunkingUC    usecase.ChunkingUseCase
	folderRepo    repository.FolderRepository
	chunkRepo     repository.ChunkRepository
	debounceDelay time.Duration
	
	// Debouncing için
	pendingEvents map[string]*FileEvent      // path -> event
	eventTimers   map[string]*time.Timer     // path -> timer
	eventMu       sync.Mutex                 // Debouncing map'leri için mutex
	
	// Sync callbacks
	onFileChanged      func(fileID, folderID string) error                    // Tüm dosya için sync
	onChunksChanged    func(fileID, folderID string, changedChunks []int) error // Sadece değişen chunk'lar için sync
}

// NewEventHandler yeni EventHandler oluşturur
func NewEventHandler(
	fileRepo repository.FileRepository,
	chunkingUC usecase.ChunkingUseCase,
	folderRepo repository.FolderRepository,
	chunkRepo repository.ChunkRepository,
) *EventHandler {
	return &EventHandler{
		fileRepo:      fileRepo,
		chunkingUC:    chunkingUC,
		folderRepo:    folderRepo,
		chunkRepo:     chunkRepo,
		debounceDelay: 500 * time.Millisecond, // Çok hızlı değişikliklerde spam önleme
		pendingEvents: make(map[string]*FileEvent),
		eventTimers:   make(map[string]*time.Timer),
	}
}

// HandleEvent dosya event'ini işler
func (h *EventHandler) HandleEvent(event *FileEvent) error {
	// MODIFY event'leri için debouncing uygula (Word çok hızlı yazıyor)
	// CREATE ve DELETE için debouncing yok (hemen işle)
	if event.Type == EventTypeModify {
		return h.handleEventWithDebounce(event)
	}
	
	// Event tipine göre işle
	switch event.Type {
	case EventTypeCreate:
		return h.handleCreate(event)
		
	case EventTypeDelete:
		return h.handleDelete(event)
		
	case EventTypeRename:
		// Rename = Delete + Create olarak işlenir
		log.Printf("📝 Rename event: %s (folder: %s)", event.Path, event.FolderID[:8])
		return nil
		
	default:
		return fmt.Errorf("bilinmeyen event tipi: %s", event.Type)
	}
}

// handleEventWithDebounce event'i debouncing ile işler
func (h *EventHandler) handleEventWithDebounce(event *FileEvent) error {
	h.eventMu.Lock()
	defer h.eventMu.Unlock()
	
	// Event key (folder + path)
	eventKey := fmt.Sprintf("%s:%s", event.FolderID, event.Path)
	
	// Önceki timer varsa iptal et
	if timer, exists := h.eventTimers[eventKey]; exists {
		timer.Stop()
	}
	
	// Event'i sakla
	h.pendingEvents[eventKey] = event
	
	// Yeni timer başlat
	h.eventTimers[eventKey] = time.AfterFunc(h.debounceDelay, func() {
		h.eventMu.Lock()
		pendingEvent := h.pendingEvents[eventKey]
		delete(h.pendingEvents, eventKey)
		delete(h.eventTimers, eventKey)
		h.eventMu.Unlock()
		
		if pendingEvent != nil {
			// Event'i işle (debounce delay'den sonra)
			if err := h.handleModify(pendingEvent); err != nil {
				log.Printf("⚠️ Debounced event işleme hatası: %v", err)
			}
		}
	})
	
	return nil
}

// handleCreate yeni dosya oluşturma event'ini işler
func (h *EventHandler) handleCreate(event *FileEvent) error {
	ctx := context.Background()
	
	// Dosya bilgilerini al
	fileInfo, err := os.Stat(event.AbsPath)
	if err != nil {
		return fmt.Errorf("dosya bilgisi alınamadı: %w", err)
	}
	
	// Dizinse atla
	if fileInfo.IsDir() {
		return nil
	}
	
	log.Printf("📄 CREATE: %s (folder: %s)", event.Path, event.FolderID[:8])
	
	// File entity oluştur
	file := entity.NewFile(
		event.FolderID,
		event.Path,
		fileInfo.Size(),
		fileInfo.ModTime(),
	)
	
	// Veritabanına kaydet
	if err := h.fileRepo.Create(ctx, file); err != nil {
		return fmt.Errorf("dosya kaydedilemedi: %w", err)
	}
	
	// Chunk'lara ayır (eğer boyut > 0 ise)
	if fileInfo.Size() > 0 {
		if err := h.createChunks(ctx, file, event.AbsPath); err != nil {
			log.Printf("⚠️ Chunk oluşturulamadı (%s): %v", event.Path, err)
			return nil // Chunk hatası olsa bile devam et
		}
		
		// YENİ DOSYA için otomatik sync tetikle
		// (Tüm chunk'lar gitmeli - yeni dosya)
		if h.onFileChanged != nil {
			log.Printf("🔄 Yeni dosya - otomatik sync tetikleniyor: %s", event.Path)
			if err := h.onFileChanged(file.ID, event.FolderID); err != nil {
				log.Printf("⚠️ Otomatik sync hatası (%s): %v", event.Path, err)
			}
		}
	}
	
	return nil
}

// handleModify dosya değişikliği event'ini işler
func (h *EventHandler) handleModify(event *FileEvent) error {
	ctx := context.Background()
	
	// Dosya bilgilerini al
	fileInfo, err := os.Stat(event.AbsPath)
	if err != nil {
		// Dosya silinmiş olabilir (MODIFY event'inden sonra DELETE gelebilir)
		if os.IsNotExist(err) {
			return nil
		}
		return fmt.Errorf("dosya bilgisi alınamadı: %w", err)
	}
	
	// Dizinse atla
	if fileInfo.IsDir() {
		return nil
	}
	
	log.Printf("📝 MODIFY: %s (folder: %s)", event.Path, event.FolderID[:8])
	
	// Veritabanında dosyayı bul
	file, err := h.fileRepo.GetByPath(ctx, event.FolderID, event.Path)
	if err != nil {
		// Dosya veritabanında yoksa, CREATE olarak işle
		return h.handleCreate(event)
	}
	
	// ESKİ chunk hash'lerini al (delta sync için)
	oldChunks, err := h.chunkRepo.GetFileChunks(ctx, file.ID)
	if err != nil {
		log.Printf("⚠️ Eski chunk'lar alınamadı, tüm dosya sync edilecek: %v", err)
		oldChunks = nil // Eski chunk yok, tüm dosyayı sync et
	}
	
	// Eski chunk hash'lerini map'e al (hızlı karşılaştırma için)
	oldChunkHashes := make(map[int]string) // index -> hash
	for _, chunk := range oldChunks {
		oldChunkHashes[chunk.ChunkIndex] = chunk.ChunkHash
	}
	
	// Dosya bilgilerini güncelle
	file.Size = fileInfo.Size()
	file.ModTime = fileInfo.ModTime()
	file.UpdatedAt = time.Now()
	
	if err := h.fileRepo.Update(ctx, file); err != nil {
		return fmt.Errorf("dosya güncellenemedi: %w", err)
	}
	
	// YENİ chunk'lar oluştur
	if fileInfo.Size() > 0 {
		if err := h.createChunks(ctx, file, event.AbsPath); err != nil {
			log.Printf("⚠️ Chunk oluşturulamadı (%s): %v", event.Path, err)
			return nil
		}
		
		// Yeni chunk'ları al
		newChunks, err := h.chunkRepo.GetFileChunks(ctx, file.ID)
		if err != nil {
			log.Printf("⚠️ Yeni chunk'lar alınamadı: %v", err)
			return nil
		}
		
		// DEĞİŞEN chunk'ları tespit et
		changedChunkIndices := make([]int, 0)
		for _, newChunk := range newChunks {
			oldHash, exists := oldChunkHashes[newChunk.ChunkIndex]
			if !exists || oldHash != newChunk.ChunkHash {
				// Bu chunk değişti veya yeni
				changedChunkIndices = append(changedChunkIndices, newChunk.ChunkIndex)
			}
		}
		
		if len(changedChunkIndices) == 0 {
			log.Printf("✅ MODIFY işlendi, değişiklik yok: %s", event.Path)
			return nil
		}
		
		log.Printf("🔄 %d/%d chunk değişti: %s", len(changedChunkIndices), len(newChunks), event.Path)
		
		// DELTA SYNC: Sadece değişen chunk'ları gönder
		if h.onChunksChanged != nil {
			if err := h.onChunksChanged(file.ID, event.FolderID, changedChunkIndices); err != nil {
				log.Printf("⚠️ Delta sync hatası (%s): %v", event.Path, err)
			}
		}
	}
	
	log.Printf("✅ MODIFY işlendi: %s", event.Path)
	return nil
}

// handleDelete dosya silme event'ini işler
func (h *EventHandler) handleDelete(event *FileEvent) error {
	ctx := context.Background()
	
	log.Printf("🗑️ DELETE: %s (folder: %s)", event.Path, event.FolderID[:8])
	
	// Veritabanında dosyayı bul
	file, err := h.fileRepo.GetByPath(ctx, event.FolderID, event.Path)
	if err != nil {
		// Dosya veritabanında yoksa atla
		return nil
	}
	
	// Dosyayı sil
	if err := h.fileRepo.Delete(ctx, file.ID); err != nil {
		return fmt.Errorf("dosya silinemedi: %w", err)
	}
	
	log.Printf("✅ DELETE işlendi: %s", event.Path)
	return nil
}

// createChunks dosyayı chunk'lara ayırır ve kaydeder
func (h *EventHandler) createChunks(ctx context.Context, file *entity.File, absPath string) error {
	// Folder bilgisini al
	folder, err := h.folderRepo.GetByID(ctx, file.FolderID)
	if err != nil {
		return fmt.Errorf("folder bulunamadı: %w", err)
	}
	
	// Absolute path oluştur
	fullPath := filepath.Join(folder.LocalPath, file.RelativePath)
	
	// Chunk'lara ayır
	chunks, _, err := h.chunkingUC.ChunkAndStoreFile(ctx, file.ID, fullPath)
	if err != nil {
		return fmt.Errorf("chunk hatası: %w", err)
	}
	
	// Log azaltılmış (spam önleme)
	// Her 50 chunk'ta bir veya ilk/son chunk'ta log
	for i, chunk := range chunks {
		if i%50 == 0 || i == 0 || i == len(chunks)-1 {
			log.Printf("  🧩 Chunk %d/%d: %s (%d bytes)", i+1, len(chunks), chunk.Hash[:8], chunk.Size)
		}
	}
	
	log.Printf("✅ %d chunk oluşturuldu: %s", len(chunks), file.RelativePath)
	return nil
}

// SetDebounceDelay debounce delay'i ayarlar
func (h *EventHandler) SetDebounceDelay(delay time.Duration) {
	h.debounceDelay = delay
}

// SetOnFileChanged file changed callback'i ayarlar (tüm dosya için)
func (h *EventHandler) SetOnFileChanged(callback func(fileID, folderID string) error) {
	h.onFileChanged = callback
}

// SetOnChunksChanged chunks changed callback'i ayarlar (sadece değişen chunk'lar için)
func (h *EventHandler) SetOnChunksChanged(callback func(fileID, folderID string, changedChunks []int) error) {
	h.onChunksChanged = callback
}

