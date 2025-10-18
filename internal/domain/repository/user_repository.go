package repository

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// UserRepository kullanıcı verilerine erişim için interface
type UserRepository interface {
	// Create yeni bir kullanıcı oluşturur
	Create(ctx context.Context, user *entity.User) error
	
	// GetByID ID'ye göre kullanıcı getirir
	GetByID(ctx context.Context, id string) (*entity.User, error)
	
	// GetByProfileName profil adına göre kullanıcı getirir
	GetByProfileName(ctx context.Context, profileName string) (*entity.User, error)
	
	// GetAll tüm kullanıcıları getirir
	GetAll(ctx context.Context) ([]*entity.User, error)
	
	// GetAdmins sadece admin kullanıcıları getirir
	GetAdmins(ctx context.Context) ([]*entity.User, error)
	
	// Update kullanıcı bilgilerini günceller
	Update(ctx context.Context, user *entity.User) error
	
	// Delete kullanıcıyı siler
	Delete(ctx context.Context, id string) error
	
	// UpdatePassword kullanıcı şifresini günceller
	UpdatePassword(ctx context.Context, id string, passwordHash string) error
}





