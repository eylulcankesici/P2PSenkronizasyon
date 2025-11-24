package watcher

import (
	"log"
	"sync"
)

// FileEventData dosya event bilgisi (UI için)
type FileEventData struct {
	EventType EventType // file_watcher.go'daki EventType'ı kullan
	FolderID  string
	FileID    string
	FilePath  string // Relative path
	OldPath   string // Rename için eski path
	Timestamp int64  // Unix timestamp (milliseconds)
}

// EventBroadcaster dosya değişikliklerini tüm listener'lara yayınlar
type EventBroadcaster struct {
	listeners map[string]chan *FileEventData
	mu        sync.RWMutex
	closed    bool
}

// NewEventBroadcaster yeni EventBroadcaster oluşturur
func NewEventBroadcaster() *EventBroadcaster {
	return &EventBroadcaster{
		listeners: make(map[string]chan *FileEventData),
	}
}

// Subscribe yeni bir listener ekler ve event kanalını döner
func (eb *EventBroadcaster) Subscribe(listenerID string) <-chan *FileEventData {
	eb.mu.Lock()
	defer eb.mu.Unlock()
	
	if eb.closed {
		return nil
	}
	
	// Buffered channel (100 event kapasitesi)
	ch := make(chan *FileEventData, 100)
	eb.listeners[listenerID] = ch
	
	log.Printf("📡 Event broadcaster: Yeni listener eklendi (%s), toplam: %d", listenerID, len(eb.listeners))
	
	return ch
}

// Unsubscribe listener'ı kaldırır
func (eb *EventBroadcaster) Unsubscribe(listenerID string) {
	eb.mu.Lock()
	defer eb.mu.Unlock()
	
	if ch, exists := eb.listeners[listenerID]; exists {
		close(ch)
		delete(eb.listeners, listenerID)
		log.Printf("📡 Event broadcaster: Listener kaldırıldı (%s), kalan: %d", listenerID, len(eb.listeners))
	}
}

// Broadcast event'i tüm listener'lara yayınlar
func (eb *EventBroadcaster) Broadcast(event *FileEventData) {
	eb.mu.RLock()
	defer eb.mu.RUnlock()
	
	if eb.closed {
		return
	}
	
	if len(eb.listeners) == 0 {
		return // Hiç listener yok, atla
	}
	
	log.Printf("📡 Event broadcasting: type=%v, file=%s -> %d listener", event.EventType, event.FilePath, len(eb.listeners))
	
	// Tüm listener'lara gönder (non-blocking)
	for listenerID, ch := range eb.listeners {
		select {
		case ch <- event:
			// Başarıyla gönderildi
		default:
			// Kanal dolu, listener yavaş
			log.Printf("⚠️ Event broadcaster: Listener kanalı dolu, event atlanıyor (%s)", listenerID)
		}
	}
}

// Close broadcaster'ı kapatır ve tüm listener'ları temizler
func (eb *EventBroadcaster) Close() {
	eb.mu.Lock()
	defer eb.mu.Unlock()
	
	if eb.closed {
		return
	}
	
	eb.closed = true
	
	// Tüm listener channel'larını kapat
	for listenerID, ch := range eb.listeners {
		close(ch)
		log.Printf("📡 Event broadcaster: Listener kapatıldı (%s)", listenerID)
	}
	
	eb.listeners = make(map[string]chan *FileEventData)
	log.Println("📡 Event broadcaster kapatıldı")
}

// ListenerCount aktif listener sayısını döner
func (eb *EventBroadcaster) ListenerCount() int {
	eb.mu.RLock()
	defer eb.mu.RUnlock()
	return len(eb.listeners)
}

