package usecase

import (
	"context"
)

// P2PTransferUseCase P2P chunk transfer use case
// Business Logic: Chunk'ların peer'lar arası transferi
type P2PTransferUseCase interface {
	// Chunk Transfer
	SendChunkToPeer(ctx context.Context, peerID, chunkHash string) error
	RequestChunkFromPeer(ctx context.Context, peerID, chunkHash string) ([]byte, error)
	
	// File Sync
	SyncFileWithPeer(ctx context.Context, peerID, fileID string) error
	RequestFileFromPeer(ctx context.Context, peerID, fileID string) error
	
	// Status
	GetTransferStatus(ctx context.Context, fileID string) (*TransferStatus, error)
	GetPeerLatency(ctx context.Context, peerID string) (int64, error)
}

// TransferStatus transfer durumu
type TransferStatus struct {
	FileID           string
	TotalChunks      int
	TransferredChunks int
	TotalBytes       int64
	TransferredBytes int64
	IsComplete       bool
	PeerID           string
}

