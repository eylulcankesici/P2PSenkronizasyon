package watcher

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
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
	pendingEvents map[string]*FileEvent  // path -> event
	eventTimers   map[string]*time.Timer // path -> timer
	eventMu       sync.Mutex             // Debouncing map'leri için mutex

	// Sync callbacks
	onFileChanged   func(fileID, folderID string) error                      // Tüm dosya için sync (CREATE)
	onChunksChanged func(fileID, folderID string, changedChunks []int) error // Sadece değişen chunk'lar için sync (MODIFY)
	onFileDeleted   func(fileID, folderID string) error                      // Dosya silindi sync (DELETE)
	onFileRenamed   func(fileID, oldPath, newPath string) error              // Dosya yeniden adlandırıldı sync (RENAME)
	onFolderDeleted func(folderID string) error                              // Klasör silindi sync (DELETE)

	// Event broadcaster (UI için)
	eventBroadcaster *EventBroadcaster

	// Ignore listesi (kullanıcı tarafından silinen dosyalar - file watcher tarafından tekrar eklenmemeli)
	// map[string]time.Time - "folderID:relativePath" -> expiryTime
	ignoredFiles sync.Map

	// Rename tespiti için (OldPath -> Timestamp)
	// Rename işlemi genellikle: RENAME(old) -> CREATE(new) şeklinde gelir
	pendingRenames sync.Map // map[string]time.Time (key: "folderID:oldRelativePath")
}

// NewEventHandler yeni EventHandler oluşturur
func NewEventHandler(
	fileRepo repository.FileRepository,
	chunkingUC usecase.ChunkingUseCase,
	folderRepo repository.FolderRepository,
	chunkRepo repository.ChunkRepository,
	eventBroadcaster *EventBroadcaster,
) *EventHandler {
	return &EventHandler{
		fileRepo:         fileRepo,
		chunkingUC:       chunkingUC,
		folderRepo:       folderRepo,
		chunkRepo:        chunkRepo,
		debounceDelay:    500 * time.Millisecond, // Çok hızlı değişikliklerde spam önleme
		pendingEvents:    make(map[string]*FileEvent),
		eventTimers:      make(map[string]*time.Timer),
		eventBroadcaster: eventBroadcaster,
		// pendingRenames: init yapılmaz, sync.Map
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
		// Rename event'i geldiğinde old path'i sakla ve Create event'ini bekle
		return h.handleRename(event)

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

	// Dizin kontrolü
	isDirectory := fileInfo.IsDir()
	if isDirectory {
		log.Printf("📁 FOLDER CREATE: %s (folder: %s)", event.Path, event.FolderID[:8])
	}

	// Dosya zaten veritabanında var mı? (Word RENAME+CREATE yapıyor)
	existingFile, err := h.fileRepo.GetByPath(ctx, event.FolderID, event.Path)
	if err == nil && existingFile != nil {
		// Dosya zaten var! Bu aslında MODIFY (Word'ün kaydetme davranışı)
		log.Printf("📝 CREATE → MODIFY (dosya zaten var): %s", event.Path)
		return h.handleModify(event)
	}

	// SADECE FILE WATCHER'IN OTOMATİK CREATE EVENT'İNDE: Ignore listesi kontrol et
	// (Kullanıcı tarafından silinen dosyalar file watcher tarafından tekrar eklenmemeli)
	// (Kullanıcı tarafından silinen dosyalar file watcher tarafından tekrar eklenmemeli)
	ignoreKey := fmt.Sprintf("%s:%s", event.FolderID, event.Path)
	
	// Log every event and ignore decision
	val, ok := h.ignoredFiles.Load(ignoreKey)
	if ok {
		expiry := val.(time.Time)
		if time.Now().Before(expiry) {
			log.Printf("🚫 CREATE ignored (kullanıcı tarafından silindi, expires in %v): %s", time.Until(expiry), event.Path)
			return nil // Ignore et, ekleme
		} else {
			// Süresi dolmuş, listeden sil
			log.Printf("✅ CREATE not ignored (expiry passed): %s", event.Path)
			h.ignoredFiles.Delete(ignoreKey)
		}
	} else {
		log.Printf("✅ CREATE not ignored (not in ignore list): %s", event.Path)
	}

	log.Printf("📄 CREATE: %s (folder: %s)", event.Path, event.FolderID[:8])

	// RENAME KONTROLÜ: Yakın zamanda rename edilmiş bir dosya var mı?
	// Folder içindeki tüm pending rename'leri kontrol et
	var renamedFromFileID string
	var renamedFromPath string

	h.pendingRenames.Range(func(key, value any) bool {
		k := key.(string)
		t := value.(time.Time)

		// 1 saniye içinde rename edilmiş olmalı
		if time.Since(t) > 1*time.Second {
			h.pendingRenames.Delete(k)
			return true // continue
		}

		// Key format: "folderID:path"
		parts := strings.SplitN(k, ":", 2)
		if len(parts) != 2 || parts[0] != event.FolderID {
			return true // continue
		}
		oldPath := parts[1]

		// Eğer dosya boyutları/modtime tutuyorsa veya sadece isim benzerliği varsa eşleştirilebilir
		// Şimdilik sadece zaman yakınlığına güveniyoruz (kullanıcı rename yaptı)

		// Veritabanında eski dosyayı bul
		oldFile, err := h.fileRepo.GetByPath(ctx, event.FolderID, oldPath)
		if err == nil && oldFile != nil {
			renamedFromFileID = oldFile.ID
			renamedFromPath = oldPath
			h.pendingRenames.Delete(k) // Eşleşti, sil
			return false               // break
		}

		return true
	})

	// EĞER RENAME TESPİT EDİLDİYSE: Dosyayı güncelle
	if renamedFromFileID != "" {
		log.Printf("♻️ RENAME tespit edildi: %s -> %s", renamedFromPath, event.Path)

		// Eski dosyayı güncelle
		oldFile, err := h.fileRepo.GetByID(ctx, renamedFromFileID)
		if err == nil {
			oldFile.RelativePath = event.Path
			oldFile.UpdatedAt = time.Now()
			// Eğer silinmişse geri getir
			if oldFile.IsDeleted {
				oldFile.IsDeleted = false
			}

			if err := h.fileRepo.Update(ctx, oldFile); err != nil {
				log.Printf("⚠️ Rename update hatası: %v", err)
			} else {
				// RECURSIVE RENAME: Eğer klasör ise, altındaki tüm dosyaların path'ini güncelle
				if oldFile.IsDirectory {
					files, err := h.fileRepo.GetByFolderID(ctx, event.FolderID)
					if err == nil {
						oldPrefix := renamedFromPath + string(filepath.Separator)
						newPrefix := event.Path + string(filepath.Separator)
						count := 0
						for _, f := range files {
							if strings.HasPrefix(f.RelativePath, oldPrefix) {
								f.RelativePath = strings.Replace(f.RelativePath, oldPrefix, newPrefix, 1)
								f.UpdatedAt = time.Now()
								if err := h.fileRepo.Update(ctx, f); err != nil {
									log.Printf("⚠️ Child file rename update hatası (%s): %v", f.ID[:8], err)
								} else {
									count++
								}
							}
						}
						if count > 0 {
							log.Printf("♻️ Klasör rename: %d alt dosyanın path'i güncellendi", count)
						}
					}
				}

				// Rename sync tetikle
				if h.onFileRenamed != nil {
					if err := h.onFileRenamed(oldFile.ID, renamedFromPath, event.Path); err != nil {
						log.Printf("⚠️ Rename sync hatası: %v", err)
					}
				}
				return nil // Create işlemi tamamlandı (rename olarak)
			}
		}
	}

	// File entity oluştur
	// İplik: Folder create support
	file := entity.NewFile(
		event.FolderID,
		event.Path,
		fileInfo.Size(),
		fileInfo.ModTime(),
		isDirectory,
	)

	// Veritabanına kaydet
	if err := h.fileRepo.Create(ctx, file); err != nil {
		return fmt.Errorf("dosya kaydedilemedi: %w", err)
	}

	// Eğer klasör ise, recursive olarak tara ve içindeki dosyalar için create event'i oluştur
	// (Pasted folder senaryosu için: watcher eklenmeden önce oluşturulan dosyaları yakala)
	if isDirectory {
		// Asenkron olarak tara (UI/watcher'ı bloklamamak için)
		go func() {
			time.Sleep(100 * time.Millisecond) // Watcher'ın eklenmesi için kısa bir bekleme
			
			err := filepath.Walk(event.AbsPath, func(path string, info os.FileInfo, err error) error {
				if err != nil {
					return err
				}
				if path == event.AbsPath {
					return nil // Root klasörü atla
				}

				// Dosya event'i oluştur
				
				subRel, err := filepath.Rel(event.AbsPath, path)
				if err != nil {
					return nil
				}
				fullRel := filepath.Join(event.Path, subRel)

				// Create event tetikle
				childEvent := &FileEvent{
					Type:      EventTypeCreate,
					Path:      fullRel,
					AbsPath:   path,
					FolderID:  event.FolderID,
					Timestamp: time.Now(),
				}

				log.Printf("🔍 Recursive scan bulundu: %s", fullRel)
				if err := h.handleCreate(childEvent); err != nil {
					log.Printf("⚠️ Recursive create hatası (%s): %v", fullRel, err)
				}
				return nil
			})
			if err != nil {
				log.Printf("⚠️ Recursive scan hatası: %v", err)
			}
		}()

		if h.onFileChanged != nil {
			return h.onFileChanged(file.ID, event.FolderID)
		}
		return nil

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

	// UI'a event gönder (CREATE)
	if h.eventBroadcaster != nil {
		h.eventBroadcaster.Broadcast(&FileEventData{
			EventType: EventTypeCreate,
			FolderID:  event.FolderID,
			FileID:    file.ID,
			FilePath:  event.Path,
			Timestamp: time.Now().UnixMilli(),
		})
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

	// Dizinse, içeriğini tara (Window quirk: dosya silinince bazen sadece klasör modify eventi geliyor)
	if fileInfo.IsDir() {
		log.Printf("📂 Folder MODIFIED (Scanning for changes): %s", event.Path)
		return h.scanDirectory(ctx, event.FolderID, event.Path, event.AbsPath)
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
	// Eğer dosya silinmiş görünüyorsa, 'resurrect' et (geri getir)
	wasDeleted := false
	if file.IsDeleted {
		file.IsDeleted = false
		wasDeleted = true
		log.Printf("♻️ Dosya 'resurrect' edildi (geri getirildi): %s", file.ID[:8])
	}

	if err := h.fileRepo.Update(ctx, file); err != nil {
		return fmt.Errorf("dosya güncellenemedi: %w", err)
	}

	// YENİ chunk'lar oluştur
	if fileInfo.Size() > 0 {
		// ESKİ chunk'ları sil (yenileriyle değiştirilecek)
		if err := h.chunkRepo.DeleteFileChunks(ctx, file.ID); err != nil {
			log.Printf("⚠️ Eski chunk'lar silinemedi (%s): %v", event.Path, err)
		}

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

		// Eğer dosya resurrect edildiyse, değişiklik olmasa bile Full Sync tetikle (peer'da silinmiş olabilir)
		if wasDeleted {
			log.Printf("♻️ Dosya resurrect edildi, içerik aynı olsa bile Full Sync tetikleniyor: %s", event.Path)
			if h.onFileChanged != nil {
				return h.onFileChanged(file.ID, event.FolderID)
			}
			return nil
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

		// UI'a event gönder (MODIFY)
		if h.eventBroadcaster != nil {
			h.eventBroadcaster.Broadcast(&FileEventData{
				EventType: EventTypeModify,
				FolderID:  event.FolderID,
				FileID:    file.ID,
				FilePath:  event.Path,
				Timestamp: time.Now().UnixMilli(),
			})
		}
	}

	log.Printf("✅ MODIFY işlendi: %s", event.Path)
	return nil
}

// handleDelete dosya silme event'ini işler
func (h *EventHandler) handleDelete(event *FileEvent) error {
	ctx := context.Background()

	log.Printf("🗑️ DELETE: %s (folder: %s)", event.Path, event.FolderID[:8])

	// Ignore listesi kontrol et (File Watcher echo önleme)
	ignoreKey := fmt.Sprintf("%s:%s", event.FolderID, event.Path)
	if val, ok := h.ignoredFiles.Load(ignoreKey); ok {
		expiry := val.(time.Time)
		if time.Now().Before(expiry) {
			log.Printf("🚫 DELETE ignored (kullanıcı/sistem tarafından zaten silindi, expires in %v): %s", time.Until(expiry), event.Path)
			return nil
		} else {
			log.Printf("✅ DELETE not ignored (expiry passed): %s", event.Path)
			h.ignoredFiles.Delete(ignoreKey)
		}
	} else {
		log.Printf("✅ DELETE not ignored (not in ignore list): %s", event.Path)
	}

	// Veritabanında dosyayı bul
	file, err := h.fileRepo.GetByPath(ctx, event.FolderID, event.Path)
	if err != nil {
		// Dosya veritabanında yoksa atla
		return nil
	}

	// Dosya ID'sini sakla (silmeden önce)
	fileID := file.ID
	isDir := file.IsDirectory

	// Dosyayı veritabanından sil (CASCADE: chunk'lar da silinir)
	if err := h.fileRepo.Delete(ctx, fileID); err != nil {
		return fmt.Errorf("dosya silinemedi: %w", err)
	}

	log.Printf("✅ DELETE işlendi (veritabanı): %s (IsDir: %v)", event.Path, isDir)

	if isDir {
		// Klasör silme bildirimi gönder
		if h.onFolderDeleted != nil {
			log.Printf("📂 Klasör silindi - karşı tarafa bildirim gönderiliyor: %s", event.Path)
			if err := h.onFolderDeleted(fileID); err != nil {
				log.Printf("⚠️ Klasör silme sync hatası (%s): %v", event.Path, err)
			}
		}
	} else {
		// Dosya silme bildirimi gönder
		if h.onFileDeleted != nil {
			log.Printf("🔄 Dosya silindi - karşı tarafa bildirim gönderiliyor: %s", event.Path)
			if err := h.onFileDeleted(fileID, event.FolderID); err != nil {
				log.Printf("⚠️ Silme sync hatası (%s): %v", event.Path, err)
			}
		}
	}

	// UI'a event gönder (DELETE)
	if h.eventBroadcaster != nil {
		h.eventBroadcaster.Broadcast(&FileEventData{
			EventType: EventTypeDelete,
			FolderID:  event.FolderID,
			FileID:    fileID,
			FilePath:  event.Path,
			Timestamp: time.Now().UnixMilli(),
		})
	}

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

// SetOnFileDeleted file deleted callback'i ayarlar
func (h *EventHandler) SetOnFileDeleted(callback func(fileID, folderID string) error) {
	h.onFileDeleted = callback
}

// SetOnFileRenamed file renamed callback'i ayarlar
func (h *EventHandler) SetOnFileRenamed(callback func(fileID, oldPath, newPath string) error) {
	h.onFileRenamed = callback
}

// SetOnFolderDeleted folder deleted callback'i ayarlar
func (h *EventHandler) SetOnFolderDeleted(callback func(folderID string) error) {
	h.onFolderDeleted = callback
}

// scanDirectory klasör içeriğini tarar ve DB ile karşılaştırarak eksik/yeni dosyaları tespit eder
func (h *EventHandler) scanDirectory(ctx context.Context, folderID, relativePath, absPath string) error {
	log.Printf("🔍 Directory Scan Started: %s (Abs: %s)", relativePath, absPath)

	// 1. Disk üzerindeki dosyaları listele
	entries, err := os.ReadDir(absPath)
	if err != nil {
		return fmt.Errorf("klasör okunamadı: %w", err)
	}

	diskFiles := make(map[string]bool)
	for _, entry := range entries {
		// Sadece dosyaları dikkate al (klasörler recursive izleniyor)
		if !entry.IsDir() {
			diskFiles[entry.Name()] = true
		}
	}

	// 2. DB'deki dosyaları çek
	allDbFiles, err := h.fileRepo.GetByFolderID(ctx, folderID)
	if err != nil {
		return fmt.Errorf("DB dosyaları alınamadı: %w", err)
	}

	// Bu klasör altındaki dosyaları filtrele
	// relativePath: "tesssst" -> Dosyalar: "tesssst/file.txt"
	targetPrefix := relativePath
	if targetPrefix == "." {
		targetPrefix = ""
	} else if targetPrefix != "" {
		targetPrefix = targetPrefix + string(os.PathSeparator)
	}

	foundInDb := 0
	deletedCount := 0

	// 3. Karşılaştırma döngüsü
	for _, dbFile := range allDbFiles {
		// Sadece bu klasörün DOĞRUDAN altındaki dosyalarla ilgileniyoruz
		if !strings.HasPrefix(dbFile.RelativePath, targetPrefix) {
			continue
		}
		remainder := strings.TrimPrefix(dbFile.RelativePath, targetPrefix)
		if strings.Contains(remainder, string(os.PathSeparator)) {
			continue // Alt klasör dosyası
		}
		if dbFile.IsDirectory {
			continue
		}

		foundInDb++

		// A) SİLİNMİŞ DOSYA: DB'de var ama Diskte yok
		if !diskFiles[remainder] {
			log.Printf("🗑️ Scan detected missing file: %s", dbFile.RelativePath)
			deleteEvent := &FileEvent{
				Type:     EventTypeDelete,
				FolderID: folderID,
				Path:     dbFile.RelativePath,
				AbsPath:  filepath.Join(absPath, remainder),
			}
			if err := h.handleDelete(deleteEvent); err != nil {
				log.Printf("⚠️ Scan delete handler error: %v", err)
			}
			deletedCount++
		} else {
			// B) DEĞİŞMİŞ DOSYA: DB'de var ve Diskte de var -> Değişiklik kontrolü
			// Disk bilgilerini al (yukarıda ReadDir yaptık ama Stat gerekebilir veya DirEntry info yeterli mi?)
			// DirEntry Info() cached olabilir, taze Stat daha güvenli.
			fullPath := filepath.Join(absPath, remainder)
			info, err := os.Stat(fullPath)
			if err != nil {
				log.Printf("⚠️ Stat failed for comparison: %s", fullPath)
				continue
			}

			// UnixMilli karşılaştırması veya Size
			// Not: ModTime hassasiyeti (Windows vs SQL) fark edebilir. 
			// 1-2 saniyelik tolerans veya sadece ciddi fark varsa?
			// Aether chunking tabanlı olduğu için, içerik değişmişse chunk hashler değişir.
			// Ama burada modification event tetiklemek istiyoruz.
			
			timeDiff := info.ModTime().Sub(dbFile.ModTime)
			if timeDiff < 0 { timeDiff = -timeDiff }

			if info.Size() != dbFile.Size || timeDiff > 2*time.Second {
				log.Printf("📝 Scan detected modified file: %s (Size: %d vs %d, TimeDiff: %v)", 
					dbFile.RelativePath, info.Size(), dbFile.Size, timeDiff)
				
				modifyEvent := &FileEvent{
					Type:     EventTypeModify,
					FolderID: folderID,
					Path:     dbFile.RelativePath,
					AbsPath:  fullPath,
					Timestamp: time.Now(),
				}
				if err := h.handleModify(modifyEvent); err != nil {
					log.Printf("⚠️ Scan modify handler error: %v", err)
				}
			}
			
			// Bu dosyayı "işlendi" olarak işaretle (Yeni dosya kontrolü için map'ten çıkarabiliriz ama loop içindeyiz)
			// diskFiles map'inden çıkaralım, geriye kalanlar YENİ olacak.
			delete(diskFiles, remainder)
		}
	}

	// 4. YENİ DOSYA: Diskte var ama DB'de yok (diskFiles map'inde kalanlar)
	// (Rename sonucu oluşan "yeni isim" de buraya düşer)
	for fileName := range diskFiles {
		fullPath := filepath.Join(absPath, fileName)
		relativePathForNew := fileName
		if targetPrefix != "" {
			relativePathForNew = targetPrefix + fileName 
			// targetPrefix already has separator if not empty? 
			// Wait, logic above: targetPrefix = relativePath + Separator.
			// But diskFiles keys are just entry.Name().
			// Example: targetPrefix="subdir/", fileName="new.txt" -> "subdir/new.txt". Correct.
		}

		log.Printf("📄 Scan detected NEW file: %s", relativePathForNew)
		
		createEvent := &FileEvent{
			Type:     EventTypeCreate,
			FolderID: folderID,
			Path:     relativePathForNew,
			AbsPath:  fullPath,
			Timestamp: time.Now(),
		}
		
		if err := h.handleCreate(createEvent); err != nil {
			log.Printf("⚠️ Scan create handler error: %v", err)
		}
	}

	log.Printf("✅ Scan Completed: %s (Deleted: %d, New/Checked: See logs)", relativePath, deletedCount)
	return nil
}
// 3 saniye boyunca ignore edilir (tekrar eklenirse döngü oluşmasın diye)
func (h *EventHandler) IgnoreFile(folderID, relativePath string) {
	ignoreKey := fmt.Sprintf("%s:%s", folderID, relativePath)
	h.ignoredFiles.Store(ignoreKey, time.Now().Add(3*time.Second))
	log.Printf("🚫 Dosya ignore listesine eklendi (3sn): %s (folder: %s)", relativePath, folderID[:8])
}

// UnignoreFile dosyayı ignore listesinden çıkarır (kullanıcı manuel olarak tekrar eklemek isterse)
func (h *EventHandler) UnignoreFile(folderID, relativePath string) {
	ignoreKey := fmt.Sprintf("%s:%s", folderID, relativePath)
	h.ignoredFiles.Delete(ignoreKey)
	log.Printf("✅ Dosya ignore listesinden çıkarıldı: %s (folder: %s)", relativePath, folderID[:8])
}

// handleRename rename event'ini işler (Pending listesine ekler)
func (h *EventHandler) handleRename(event *FileEvent) error {
	log.Printf("📝 RENAME (Old Path detected): %s (folder: %s)", event.Path, event.FolderID[:8])

	key := fmt.Sprintf("%s:%s", event.FolderID, event.Path)
	h.pendingRenames.Store(key, time.Now())

	// Fallback mechanism: 2 saniye sonra kontrol et, hala pending ise Delete olarak işle
	time.AfterFunc(2*time.Second, func() {
		if _, ok := h.pendingRenames.Load(key); ok {
			// Hala pending'de duruyor.
			// Office save gibi durumlarda dosya silinip hemen geri gelmiş olabilir.
			// Önce dosyanın şu an diskte var olup olmadığını kontrol et.
			if _, err := os.Stat(event.AbsPath); err == nil {
				log.Printf("⚠️ Rename timeout ama dosya mevcut (Office save?): %s", event.Path)
				h.pendingRenames.Delete(key)

				// Dosya var, MODIFY tetikle
				modifyEvent := &FileEvent{
					Type:     EventTypeModify,
					Path:     event.Path,
					AbsPath:  event.AbsPath,
					FolderID: event.FolderID,
				}
				if err := h.handleModify(modifyEvent); err != nil {
					log.Printf("⚠️ Rename->Modify fallback hatası: %v", err)
				}
				return
			}

			// Dosya gerçekten yok, DELETE olarak işle
			h.pendingRenames.Delete(key)
			log.Printf("⚠️ Rename timeout -> DELETE olarak işleniyor: %s", event.Path)

			// Manuel DELETE event oluştur
			deleteEvent := &FileEvent{
				Type:     EventTypeDelete,
				Path:     event.Path,
				AbsPath:  event.AbsPath,
				FolderID: event.FolderID,
			}
			if err := h.handleDelete(deleteEvent); err != nil {
				log.Printf("⚠️ Rename->Delete fallback hatası: %v", err)
			}
		}
	})

	return nil
}
