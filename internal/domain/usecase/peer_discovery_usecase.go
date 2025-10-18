package usecase

import (
	"context"

	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/transport"
)

// PeerDiscoveryUseCase peer keşif ve yönetim use case
// Business Logic: Peer keşfi, bağlantı, güven yönetimi
type PeerDiscoveryUseCase interface {
	// Discovery
	StartDiscovery(ctx context.Context) error
	StopDiscovery() error
	GetDiscoveredPeers(ctx context.Context) ([]*transport.DiscoveredPeer, error)
	
	// Connection Management
	ConnectToPeer(ctx context.Context, peerID string) error
	DisconnectFromPeer(ctx context.Context, peerID string) error
	GetConnectedPeers(ctx context.Context) ([]*entity.Peer, error)
	
	// Peer Management
	TrustPeer(ctx context.Context, peerID string) error
	UntrustPeer(ctx context.Context, peerID string) error
	RemovePeer(ctx context.Context, peerID string) error
	
	// Info
	GetPeerInfo(ctx context.Context, peerID string) (*entity.Peer, error)
	IsPeerConnected(ctx context.Context, peerID string) (bool, error)
	GetTransportInfo(ctx context.Context) (transportType transport.TransportType, port int, deviceID string)
}

