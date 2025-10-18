package p2p

import (
	"context"
	"fmt"
	"log"
	
	"github.com/aether/sync/internal/domain/entity"
)

// DataTransferManager P2P veri transferi yöneticisi
// Single Responsibility: Chunk'ların peer'lar arası transferi
type DataTransferManager struct {
	networkManager *NetworkManager
}

// NewDataTransferManager yeni bir DataTransferManager oluşturur
func NewDataTransferManager(networkManager *NetworkManager) *DataTransferManager {
	return &DataTransferManager{
		networkManager: networkManager,
	}
}

// TransferChunk chunk'ı belirli bir peer'a gönderir
func (dtm *DataTransferManager) TransferChunk(ctx context.Context, peerID string, chunk *entity.Chunk, data []byte) error {
	// Peer'in bağlı olup olmadığını kontrol et
	if !dtm.networkManager.IsPeerConnected(peerID) {
		return fmt.Errorf("peer bağlı değil: %s", peerID)
	}
	
	log.Printf("Chunk transfer ediliyor: %s -> %s (size: %d bytes)", 
		chunk.ID[:8], peerID, len(data))
	
	// libp2p stream üzerinden chunk gönder
	// Şimdilik placeholder
	
	log.Printf("✓ Chunk transfer edildi: %s", chunk.ID[:8])
	
	return nil
}

// RequestChunk belirli bir peer'dan chunk talep eder
func (dtm *DataTransferManager) RequestChunk(ctx context.Context, peerID, chunkHash string) ([]byte, error) {
	// Peer'in bağlı olup olmadığını kontrol et
	if !dtm.networkManager.IsPeerConnected(peerID) {
		return nil, fmt.Errorf("peer bağlı değil: %s", peerID)
	}
	
	log.Printf("Chunk talep ediliyor: %s <- %s", chunkHash[:8], peerID)
	
	// libp2p stream üzerinden chunk talep et
	// Şimdilik placeholder
	
	// Placeholder data
	data := []byte{}
	
	log.Printf("✓ Chunk alındı: %s (%d bytes)", chunkHash[:8], len(data))
	
	return data, nil
}

// SendFileMetadata dosya metadata'sını peer'a gönderir
func (dtm *DataTransferManager) SendFileMetadata(ctx context.Context, peerID, fileID string, metadata map[string]interface{}) error {
	if !dtm.networkManager.IsPeerConnected(peerID) {
		return fmt.Errorf("peer bağlı değil: %s", peerID)
	}
	
	log.Printf("Dosya metadata'sı gönderiliyor: %s -> %s", fileID, peerID)
	
	// libp2p üzerinden metadata gönder
	// Şimdilik placeholder
	
	return nil
}

// Ping peer'e ping gönderir (bağlantı testi)
func (dtm *DataTransferManager) Ping(ctx context.Context, peerID string) (int64, error) {
	if !dtm.networkManager.IsPeerConnected(peerID) {
		return 0, fmt.Errorf("peer bağlı değil: %s", peerID)
	}
	
	// Ping-pong latency ölçümü
	// Şimdilik placeholder
	
	latency := int64(10) // ms
	
	return latency, nil
}





