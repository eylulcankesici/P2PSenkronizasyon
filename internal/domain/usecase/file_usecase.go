package usecase

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// FileUseCase dosya yönetimi için use case interface
type FileUseCase interface {
	// GetFile ID'ye göre dosya getirir
	GetFile(ctx context.Context, id string) (*entity.File, error)
	
	// GetFilesByFolder klasördeki tüm dosyaları getirir
	GetFilesByFolder(ctx context.Context, folderID string) ([]*entity.File, error)
	
	// GetFileInfo dosya bilgilerini getirir
	GetFileInfo(ctx context.Context, fileID string) (*FileInfo, error)
	
	// DeleteFile dosyayı siler
	DeleteFile(ctx context.Context, fileID string) error
	
	// RestoreFile dosyayı belirli bir versiyona geri yükler
	RestoreFile(ctx context.Context, fileID string, versionID string) error
	
	// GetFileVersions dosyanın tüm versiyonlarını getirir
	GetFileVersions(ctx context.Context, fileID string) ([]*entity.FileVersion, error)
}

// FileInfo detaylı dosya bilgisi
type FileInfo struct {
	File            *entity.File
	Chunks          []*entity.Chunk
	AvailablePeers  []string
	VersionCount    int
	SyncPercentage  float64
	LastSyncTime    int64
}





