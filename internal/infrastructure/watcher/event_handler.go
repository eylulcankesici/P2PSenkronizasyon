package watcher

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
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
	debounceDelay time.Duration
	
	// Debouncing için
	pendingEvents map[string]*FileEvent // path -> event
	eventTimers   map[string]*time.Timer // path -> timer
}

// NewEventHandler yeni EventHandler oluşturur
func NewEventHandler(
	fileRepo repository.FileRepository,
	chunkingUC usecase.ChunkingUseCase,
	folderRepo repository.FolderRepository,
) *EventHandler {
	return &EventHandler{
		fileRepo:      fileRepo,
		chunkingUC:    chunkingUC,
		folderRepo:    folderRepo,
		debounceDelay: 500 * time.Millisecond, // Çok hızlı değişikliklerde spam önleme
		pendingEvents: make(map[string]*FileEvent),
		eventTimers:   make(map[string]*time.Timer),
	}
}

// HandleEvent dosya event'ini işler
func (h *EventHandler) HandleEvent(event *FileEvent) error {
	// Event tipine göre işle
	switch event.Type {
	case EventTypeCreate:
		return h.handleCreate(event)
		
	case EventTypeModify:
		return h.handleModify(event)
		
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
	
	// Log azaltılmış (MODIFY çok fazla)
	// log.Printf("📝 MODIFY: %s (folder: %s)", event.Path, event.FolderID[:8])
	
	// Veritabanında dosyayı bul
	file, err := h.fileRepo.GetByPath(ctx, event.FolderID, event.Path)
	if err != nil {
		// Dosya veritabanında yoksa, CREATE olarak işle
		return h.handleCreate(event)
	}
	
	// Dosya bilgilerini güncelle
	file.Size = fileInfo.Size()
	file.ModTime = fileInfo.ModTime()
	file.UpdatedAt = time.Now()
	
	if err := h.fileRepo.Update(ctx, file); err != nil {
		return fmt.Errorf("dosya güncellenemedi: %w", err)
	}
	
	// Yeni chunk'lar oluştur
	if fileInfo.Size() > 0 {
		if err := h.createChunks(ctx, file, event.AbsPath); err != nil {
			log.Printf("⚠️ Chunk oluşturulamadı (%s): %v", event.Path, err)
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

