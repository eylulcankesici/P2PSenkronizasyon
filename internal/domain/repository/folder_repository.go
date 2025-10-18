package repository

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// FolderRepository klasör verilerine erişim için interface
// Interface Segregation: Sadece folder ile ilgili metodları içerir
type FolderRepository interface {
	// Create yeni bir klasör oluşturur
	Create(ctx context.Context, folder *entity.Folder) error
	
	// GetByID ID'ye göre klasör getirir
	GetByID(ctx context.Context, id string) (*entity.Folder, error)
	
	// GetByPath dosya yoluna göre klasör getirir
	GetByPath(ctx context.Context, path string) (*entity.Folder, error)
	
	// GetAll tüm klasörleri getirir
	GetAll(ctx context.Context) ([]*entity.Folder, error)
	
	// GetActive sadece aktif klasörleri getirir
	GetActive(ctx context.Context) ([]*entity.Folder, error)
	
	// Update klasör bilgilerini günceller
	Update(ctx context.Context, folder *entity.Folder) error
	
	// Delete klasörü siler
	Delete(ctx context.Context, id string) error
	
	// UpdateScanTime son tarama zamanını günceller
	UpdateScanTime(ctx context.Context, id string) error
}





