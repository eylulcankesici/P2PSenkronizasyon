package repository

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// VersionRepository dosya versiyon verilerine erişim için interface
type VersionRepository interface {
	// Create yeni bir versiyon kaydı oluşturur
	Create(ctx context.Context, version *entity.FileVersion) error
	
	// GetByID ID'ye göre versiyon getirir
	GetByID(ctx context.Context, id string) (*entity.FileVersion, error)
	
	// GetByFileID dosya ID'sine göre tüm versiyonları getirir (en yeniden eskiye)
	GetByFileID(ctx context.Context, fileID string) ([]*entity.FileVersion, error)
	
	// GetLatestVersion dosyanın en son versiyonunu getirir
	GetLatestVersion(ctx context.Context, fileID string) (*entity.FileVersion, error)
	
	// GetByVersionNumber dosyanın belirli versiyon numarasını getirir
	GetByVersionNumber(ctx context.Context, fileID string, versionNumber int) (*entity.FileVersion, error)
	
	// Delete versiyon kaydını siler
	Delete(ctx context.Context, id string) error
	
	// DeleteOldVersions belirli sayıdan eski versiyonları siler
	DeleteOldVersions(ctx context.Context, fileID string, keepCount int) error
	
	// GetTotalVersionCount toplam versiyon sayısını getirir
	GetTotalVersionCount(ctx context.Context, fileID string) (int, error)
}





