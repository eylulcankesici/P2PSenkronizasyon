package repository

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// FilePeerSyncRepository dosya-peer senkronizasyon durumuna erişim için interface
type FilePeerSyncRepository interface {
	// Create veya Update dosya-peer sync kaydı oluşturur/günceller
	CreateOrUpdate(ctx context.Context, sync *entity.FilePeerSync) error
	
	// GetByFileID dosyanın hangi peer'larla senkronize edildiğini getirir
	GetByFileID(ctx context.Context, fileID string) ([]*entity.FilePeerSync, error)
	
	// GetByFileAndPeerID belirli bir dosya-peer çifti için sync kaydını getirir
	GetByFileAndPeerID(ctx context.Context, fileID, peerID string) (*entity.FilePeerSync, error)
	
	// IsFileSyncedWithPeer dosyanın belirli bir peer ile senkronize edilip edilmediğini kontrol eder
	IsFileSyncedWithPeer(ctx context.Context, fileID, peerID string) (bool, error)
	
	// Delete dosya-peer sync kaydını siler
	Delete(ctx context.Context, fileID, peerID string) error
	
	// DeleteByFileID dosyanın tüm sync kayıtlarını siler
	DeleteByFileID(ctx context.Context, fileID string) error
}

