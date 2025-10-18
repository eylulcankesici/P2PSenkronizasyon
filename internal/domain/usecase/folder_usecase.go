package usecase

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// FolderUseCase klasör yönetimi için use case interface
type FolderUseCase interface {
	// CreateFolder yeni bir senkronize klasör oluşturur
	CreateFolder(ctx context.Context, localPath string, syncMode entity.SyncMode) (*entity.Folder, error)
	
	// GetFolder ID'ye göre klasör getirir
	GetFolder(ctx context.Context, id string) (*entity.Folder, error)
	
	// GetAllFolders tüm klasörleri getirir
	GetAllFolders(ctx context.Context) ([]*entity.Folder, error)
	
	// UpdateFolder klasör bilgilerini günceller
	UpdateFolder(ctx context.Context, folder *entity.Folder) error
	
	// DeleteFolder klasörü siler
	DeleteFolder(ctx context.Context, id string) error
	
	// ActivateFolder klasörü aktif hale getirir
	ActivateFolder(ctx context.Context, id string) error
	
	// DeactivateFolder klasörü pasif hale getirir
	DeactivateFolder(ctx context.Context, id string) error
	
	// ValidateFolderPath klasör yolunun geçerliliğini kontrol eder
	ValidateFolderPath(ctx context.Context, path string) error
}





