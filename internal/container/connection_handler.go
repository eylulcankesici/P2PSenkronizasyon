package container

import (
	"context"
	"log"
	"time"

	"github.com/aether/sync/internal/infrastructure/watcher"
)

// handleIncomingConnectionRequest gelen bağlantı isteğini işler
func (c *Container) handleIncomingConnectionRequest(ctx context.Context, deviceID, deviceName string) error {
	log.Printf("🔔 Bağlantı isteği işleniyor: %s (%s)", deviceName, deviceID[:8])
	
	// Event broadcaster ile UI'a bildir
	if c.eventBroadcaster != nil {
		c.eventBroadcaster.Broadcast(&watcher.FileEvent{
			Type:      watcher.EventTypePeerFound, // UI bu event'i dinleyip listeyi yenileyebilir
			Path:      deviceName,                 // Bilgi olarak device name
			FolderID:  deviceID,                   // Bilgi olarak device ID
			Timestamp: time.Now(),
		})
	}
	
	return nil
}
