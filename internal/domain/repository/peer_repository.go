package repository

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
	"time"
)

// PeerRepository peer verilerine erişim için interface
type PeerRepository interface {
	// Create yeni bir peer kaydı oluşturur
	Create(ctx context.Context, peer *entity.Peer) error
	
	// GetByID device ID'sine göre peer getirir
	GetByID(ctx context.Context, deviceID string) (*entity.Peer, error)
	
	// GetAll tüm peer'ları getirir
	GetAll(ctx context.Context) ([]*entity.Peer, error)
	
	// GetTrusted sadece güvenilir peer'ları getirir
	GetTrusted(ctx context.Context) ([]*entity.Peer, error)
	
	// GetOnline online olan peer'ları getirir
	GetOnline(ctx context.Context) ([]*entity.Peer, error)
	
	// Update peer bilgilerini günceller
	Update(ctx context.Context, peer *entity.Peer) error
	
	// UpdateLastSeen peer'in son görülme zamanını günceller
	UpdateLastSeen(ctx context.Context, deviceID string) error
	
	// UpdateStatus peer'in durumunu günceller
	UpdateStatus(ctx context.Context, deviceID string, status entity.PeerStatus) error
	
	// Delete peer'ı siler
	Delete(ctx context.Context, deviceID string) error
	
	// GetRecentlySeen belirli bir süre içinde görülen peer'ları getirir
	GetRecentlySeen(ctx context.Context, threshold time.Duration) ([]*entity.Peer, error)
}





