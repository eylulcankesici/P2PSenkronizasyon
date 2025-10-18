package usecase

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// PeerUseCase peer yönetimi için use case interface
type PeerUseCase interface {
	// DiscoverPeers yerel ağdaki peer'ları keşfeder
	DiscoverPeers(ctx context.Context) ([]*entity.Peer, error)
	
	// ConnectToPeer belirli bir peer'a bağlanır
	ConnectToPeer(ctx context.Context, peerID string) error
	
	// DisconnectFromPeer peer bağlantısını keser
	DisconnectFromPeer(ctx context.Context, peerID string) error
	
	// GetAllPeers tüm peer'ları getirir
	GetAllPeers(ctx context.Context) ([]*entity.Peer, error)
	
	// GetOnlinePeers online peer'ları getirir
	GetOnlinePeers(ctx context.Context) ([]*entity.Peer, error)
	
	// TrustPeer peer'i güvenilir olarak işaretler
	TrustPeer(ctx context.Context, peerID string) error
	
	// UntrustPeer peer'i güvenilmez olarak işaretler
	UntrustPeer(ctx context.Context, peerID string) error
	
	// RemovePeer peer'ı sistemden kaldırır
	RemovePeer(ctx context.Context, peerID string) error
	
	// GetPeerInfo peer detay bilgisini getirir
	GetPeerInfo(ctx context.Context, peerID string) (*PeerInfo, error)
}

// PeerInfo detaylı peer bilgisi
type PeerInfo struct {
	Peer           *entity.Peer
	SharedFolders  []string
	SharedFiles    int
	TotalChunks    int
	LastActivity   int64
	ConnectionType string // LAN, WAN, Relay
	LatencyMs      int64
}





