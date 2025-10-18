package repository

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// FileRepository dosya verilerine erişim için interface
type FileRepository interface {
	// Create yeni bir dosya kaydı oluşturur
	Create(ctx context.Context, file *entity.File) error
	
	// GetByID ID'ye göre dosya getirir
	GetByID(ctx context.Context, id string) (*entity.File, error)
	
	// GetByPath klasör ID ve relative path'e göre dosya getirir
	GetByPath(ctx context.Context, folderID, relativePath string) (*entity.File, error)
	
	// GetByFolderID bir klasördeki tüm dosyaları getirir
	GetByFolderID(ctx context.Context, folderID string) ([]*entity.File, error)
	
	// GetByHash hash değerine göre dosyaları getirir (deduplication için)
	GetByHash(ctx context.Context, hash string) ([]*entity.File, error)
	
	// Update dosya bilgilerini günceller
	Update(ctx context.Context, file *entity.File) error
	
	// Delete dosyayı siler (soft delete)
	Delete(ctx context.Context, id string) error
	
	// HardDelete dosyayı veritabanından tamamen siler
	HardDelete(ctx context.Context, id string) error
	
	// GetModifiedSince belirli bir tarihten sonra değişen dosyaları getirir
	GetModifiedSince(ctx context.Context, folderID string, since int64) ([]*entity.File, error)
}





