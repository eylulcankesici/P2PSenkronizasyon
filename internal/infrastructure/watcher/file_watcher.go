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

	"github.com/fsnotify/fsnotify"

	"github.com/aether/sync/internal/domain/entity"
)

// EventType dosya değişiklik event tipi
type EventType string

const (
	EventTypeCreate EventType = "create"
	EventTypeModify EventType = "modify"
	EventTypeDelete EventType = "delete"
	EventTypeRename EventType = "rename"
)

// FileEvent dosya değişiklik event'i
type FileEvent struct {
	Type      EventType
	Path      string // Relative path (folder root'a göre)
	AbsPath   string // Absolute path
	FolderID  string
	Timestamp time.Time
}

// FileWatcher dosya sistemi değişikliklerini izler
type FileWatcher struct {
	watcher        *fsnotify.Watcher
	watchedFolders map[string]*WatchedFolder // folderID -> WatchedFolder
	mu             sync.RWMutex

	eventHandlers []func(*FileEvent) error
	errorHandlers []func(error)

	ctx    context.Context
	cancel context.CancelFunc
	wg     sync.WaitGroup
}

// WatchedFolder izlenen klasör bilgisi
type WatchedFolder struct {
	FolderID       string
	RootPath       string
	IgnorePatterns []string
}

// NewFileWatcher yeni FileWatcher oluşturur
func NewFileWatcher() (*FileWatcher, error) {
	fsWatcher, err := fsnotify.NewWatcher()
	if err != nil {
		return nil, fmt.Errorf("fsnotify watcher oluşturulamadı: %w", err)
	}

	ctx, cancel := context.WithCancel(context.Background())

	fw := &FileWatcher{
		watcher:        fsWatcher,
		watchedFolders: make(map[string]*WatchedFolder),
		eventHandlers:  make([]func(*FileEvent) error, 0),
		errorHandlers:  make([]func(error), 0),
		ctx:            ctx,
		cancel:         cancel,
	}

	return fw, nil
}

// Start watcher'ı başlatır
func (fw *FileWatcher) Start() error {
	log.Println("📂 File watcher başlatılıyor...")

	fw.wg.Add(1)
	go fw.eventLoop()

	log.Println("✅ File watcher başlatıldı")
	return nil
}

// Stop watcher'ı durdurur
func (fw *FileWatcher) Stop() error {
	log.Println("🛑 File watcher durduruluyor...")

	fw.cancel()

	if err := fw.watcher.Close(); err != nil {
		log.Printf("⚠️ Watcher kapatılamadı: %v", err)
	}

	fw.wg.Wait()

	log.Println("✅ File watcher durduruldu")
	return nil
}

// AddFolder klasörü izlemeye başlar
func (fw *FileWatcher) AddFolder(folder *entity.Folder) error {
	fw.mu.Lock()
	defer fw.mu.Unlock()

	// Zaten izleniyor mu?
	if _, exists := fw.watchedFolders[folder.ID]; exists {
		return fmt.Errorf("klasör zaten izleniyor: %s", folder.ID)
	}

	// Klasörü fsnotify'a ekle
	if err := fw.watcher.Add(folder.LocalPath); err != nil {
		return fmt.Errorf("klasör izlenemiyor: %w", err)
	}

	// Alt dizinleri de ekle (recursive watch)
	if err := fw.addSubdirectories(folder.LocalPath); err != nil {
		log.Printf("⚠️ Alt dizinler eklenirken hata: %v", err)
	}

	// WatchedFolder oluştur
	watched := &WatchedFolder{
		FolderID: folder.ID,
		RootPath: folder.LocalPath,
		IgnorePatterns: []string{
			".aether_versions",
			".git",
			".DS_Store",
			"Thumbs.db",
			"desktop.ini",
			"node_modules",
			".idea",
			".vscode",
			// Microsoft Office geçici dosyaları
			"~$",   // Word/Excel lock files (~$document.docx)
			"~WRD", // Word temp files (~WRD0001.tmp)
			"~WRL", // Word recovery files (~WRL0001.tmp)
			".tmp", // Genel temp files
			"~",    // Backup files (file.txt~)
		},
	}

	fw.watchedFolders[folder.ID] = watched

	log.Printf("✅ Klasör izlemeye alındı: %s (%s)", folder.LocalPath, folder.ID[:8])
	return nil
}

// RemoveFolder klasörü izlemeden çıkarır
func (fw *FileWatcher) RemoveFolder(folderID string) error {
	fw.mu.Lock()
	defer fw.mu.Unlock()

	watched, exists := fw.watchedFolders[folderID]
	if !exists {
		return fmt.Errorf("klasör izlenmiyor: %s", folderID)
	}

	// fsnotify'dan kaldır
	if err := fw.watcher.Remove(watched.RootPath); err != nil {
		log.Printf("⚠️ Klasör fsnotify'dan kaldırılamadı: %v", err)
	}

	// Map'ten sil
	delete(fw.watchedFolders, folderID)

	log.Printf("✅ Klasör izlemeden çıkarıldı: %s", folderID[:8])
	return nil
}

// OnEvent event handler ekler
func (fw *FileWatcher) OnEvent(handler func(*FileEvent) error) {
	fw.eventHandlers = append(fw.eventHandlers, handler)
}

// OnError error handler ekler
func (fw *FileWatcher) OnError(handler func(error)) {
	fw.errorHandlers = append(fw.errorHandlers, handler)
}

// eventLoop fsnotify event'lerini işler
func (fw *FileWatcher) eventLoop() {
	defer fw.wg.Done()

	log.Println("🔄 File watcher event loop başladı")

	for {
		select {
		case <-fw.ctx.Done():
			log.Println("🔌 File watcher event loop sonlandı")
			return

		case event, ok := <-fw.watcher.Events:
			if !ok {
				return
			}

			// Event'i işle
			if err := fw.handleFsnotifyEvent(event); err != nil {
				log.Printf("⚠️ Event işleme hatası: %v", err)
				fw.notifyError(err)
			}

		case err, ok := <-fw.watcher.Errors:
			if !ok {
				return
			}
			log.Printf("⚠️ Watcher hatası: %v", err)
			fw.notifyError(err)
		}
	}
}

// handleFsnotifyEvent fsnotify event'ini işler
func (fw *FileWatcher) handleFsnotifyEvent(event fsnotify.Event) error {
	// Event path'ini kontrol et
	absPath := event.Name
	
	// RAW LOG: FSNOTIFY tarafından gelen her eventi gör
	log.Printf("🔔 FSNOTIFY RAW: Op=%s, Path=%s", event.Op, absPath)

	// Hangi folder'a ait?
	fw.mu.RLock()
	watched := fw.findWatchedFolder(absPath)
	fw.mu.RUnlock()

	if watched == nil {
		// İzlenmeyen klasör
		log.Printf("⚠️ Event izlenmeyen bir klasörde veya eşleşme bulunamadı: %s", absPath)
		return nil
	}

	// Ignore pattern kontrolü
	if fw.shouldIgnore(absPath, watched) {
		return nil
	}

	// Relative path hesapla
	relPath, err := filepath.Rel(watched.RootPath, absPath)
	if err != nil {
		return fmt.Errorf("relative path hesaplanamadı: %w", err)
	}
	relPath = filepath.ToSlash(relPath)

	// Event tipini belirle
	var eventType EventType
	switch {
	case event.Op&fsnotify.Create == fsnotify.Create:
		eventType = EventTypeCreate

		// Yeni dizin mi? Onu da watch'a ekle

		// Yeni dizin mi? Onu da watch'a ekle
		stat, err := os.Stat(absPath)
		if err == nil && stat.IsDir() {
			if err := fw.addSubdirectories(absPath); err != nil {
				log.Printf("⚠️ Yeni dizin watch'a eklenemedi: %v", err)
			} else {
				log.Printf("👀 Yeni dizin izleniyor: %s", relPath)
			}
		}


	case event.Op&fsnotify.Write == fsnotify.Write:
		eventType = EventTypeModify

	case event.Op&fsnotify.Remove == fsnotify.Remove:
		eventType = EventTypeDelete

	case event.Op&fsnotify.Rename == fsnotify.Rename:
		eventType = EventTypeRename

	default:
		// Bilinmeyen event tipi
		return nil
	}

	// FileEvent oluştur
	fileEvent := &FileEvent{
		Type:      eventType,
		Path:      relPath,
		AbsPath:   absPath,
		FolderID:  watched.FolderID,
		Timestamp: time.Now(),
	}

	// Log azaltılmış (spam önleme)
	// Sadece CREATE/DELETE için log, MODIFY çok fazla
	if eventType != EventTypeModify {
		log.Printf("📝 File event: %s - %s (folder: %s)", eventType, relPath, watched.FolderID[:8])
	}

	// Handler'ları çağır
	fw.notifyEvent(fileEvent)

	return nil
}

// findWatchedFolder path'e göre WatchedFolder bulur
func (fw *FileWatcher) findWatchedFolder(absPath string) *WatchedFolder {
	for _, watched := range fw.watchedFolders {
		if strings.HasPrefix(absPath, watched.RootPath) {
			return watched
		}
	}
	return nil
}

// shouldIgnore path ignore edilmeli mi?
func (fw *FileWatcher) shouldIgnore(absPath string, watched *WatchedFolder) bool {
	baseName := filepath.Base(absPath)

	// Harici/Sistem dosyalarını ignore et (Office temp files, vs.)
	if strings.HasPrefix(baseName, "~$") || strings.HasSuffix(baseName, ".tmp") {
		return true
	}

	for _, pattern := range watched.IgnorePatterns {
		if strings.Contains(baseName, pattern) {
			return true
		}
		if strings.Contains(absPath, pattern) {
			return true
		}
	}

	return false
}

// addSubdirectories alt dizinleri recursive olarak watch'a ekler
func (fw *FileWatcher) addSubdirectories(rootPath string) error {
	return filepath.Walk(rootPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Sadece dizinler
		if !info.IsDir() {
			return nil
		}

		// Root path zaten eklendi
		if path == rootPath {
			return nil
		}

		// Ignore pattern kontrolü
		baseName := filepath.Base(path)
		if strings.HasPrefix(baseName, ".") ||
			baseName == "node_modules" ||
			baseName == ".git" {
			return filepath.SkipDir
		}

		// Dizini watch'a ekle
		if err := fw.watcher.Add(path); err != nil {
			log.Printf("⚠️ Alt dizin eklenemedi (%s): %v", path, err)
		}

		return nil
	})
}

// notifyEvent event handler'ları çağırır
func (fw *FileWatcher) notifyEvent(event *FileEvent) {
	for _, handler := range fw.eventHandlers {
		// Goroutine'de çalıştır (blocking olmasın)
		go func(h func(*FileEvent) error) {
			if err := h(event); err != nil {
				log.Printf("⚠️ Event handler hatası: %v", err)
			}
		}(handler)
	}
}

// notifyError error handler'ları çağırır
func (fw *FileWatcher) notifyError(err error) {
	for _, handler := range fw.errorHandlers {
		go handler(err)
	}
}

// AddPath belirli bir yolu (ve alt dizinlerini) watch listesine ekler (Public)
func (fw *FileWatcher) AddPath(absPath string) error {
	if fw.watcher == nil {
		return fmt.Errorf("watcher başlatılmamış")
	}

	// Ana dizini ekle
	if err := fw.watcher.Add(absPath); err != nil {
		return fmt.Errorf("watcher'a eklenemedi: %w", err)
	}

	// Alt dizinleri de recursive ekle
	return fw.addSubdirectories(absPath)
}

// UnwatchPath belirtilen yolu ve alt dizinlerini watch listesinden çıkarır
func (fw *FileWatcher) UnwatchPath(absPath string) error {
	if fw.watcher == nil {
		return nil
	}

	// Klasör mevcutsa walk yaparak alt dizinleri de çıkar
	// Eğer klasör zaten silinmişse (externally), sadece path'i remove etmeyi dene
	info, err := os.Stat(absPath)
	if err == nil && info.IsDir() {
		// Recursive olarak çıkar (tersten gitmek daha iyi olabilir ama fsnotify için fark etmez)
		err := filepath.Walk(absPath, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return nil // Hata olsa da devam et
			}
			if info.IsDir() {
				if err := fw.watcher.Remove(path); err != nil {
					// "can't remove non-existent watch" hatası dönebilir, logla ama hata döndürme
					// log.Printf("Debug: Remove watch failed for %s: %v", path, err)
				}
			}
			return nil
		})
		if err != nil {
			log.Printf("⚠️ UnwatchPath walk hatası: %v", err)
		}
	} else {
		// Direkt olarak path'i remove etmeyi dene
		fw.watcher.Remove(absPath)
	}
	
	return nil
}

// GetWatchedFolders izlenen klasörleri döner
func (fw *FileWatcher) GetWatchedFolders() []string {
	fw.mu.RLock()
	defer fw.mu.RUnlock()

	folderIDs := make([]string, 0, len(fw.watchedFolders))
	for folderID := range fw.watchedFolders {
		folderIDs = append(folderIDs, folderID)
	}
	return folderIDs
}
