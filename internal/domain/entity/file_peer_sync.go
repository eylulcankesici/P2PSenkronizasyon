package entity

import (
	"time"
)

// FilePeerSync bir dosyanın bir peer ile senkronize edildiğini temsil eder
type FilePeerSync struct {
	FileID         string    // Dosya ID
	PeerID         string    // Peer ID (alıcı peer)
	SenderDeviceID string    // Gönderen cihazın device ID'si
	SyncedAt       time.Time // Senkronize edilme zamanı
}

// NewFilePeerSync yeni bir FilePeerSync oluşturur
func NewFilePeerSync(fileID, peerID, senderDeviceID string) *FilePeerSync {
	return &FilePeerSync{
		FileID:         fileID,
		PeerID:         peerID,
		SenderDeviceID: senderDeviceID,
		SyncedAt:       time.Now(),
	}
}
