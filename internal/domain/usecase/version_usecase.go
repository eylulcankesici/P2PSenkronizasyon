package usecase

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// VersionUseCase dosya versiyonlama için use case interface
type VersionUseCase interface {
	// CreateVersion dosya için yeni bir versiyon oluşturur
	CreateVersion(ctx context.Context, fileID, originalPath string) (*entity.FileVersion, error)
	
	// GetVersions dosyanın tüm versiyonlarını getirir
	GetVersions(ctx context.Context, fileID string) ([]*entity.FileVersion, error)
	
	// RestoreVersion dosyayı belirli bir versiyona geri yükler
	RestoreVersion(ctx context.Context, versionID string) error
	
	// DeleteVersion belirli bir versiyonu siler
	DeleteVersion(ctx context.Context, versionID string) error
	
	// CleanupOldVersions eski versiyonları temizler
	CleanupOldVersions(ctx context.Context, fileID string, keepCount int) error
	
	// GetVersionInfo versiyon detay bilgisini getirir
	GetVersionInfo(ctx context.Context, versionID string) (*VersionInfo, error)
}

// VersionInfo detaylı versiyon bilgisi
type VersionInfo struct {
	Version      *entity.FileVersion
	CanRestore   bool
	BackupExists bool
	SizeOnDisk   int64
}





