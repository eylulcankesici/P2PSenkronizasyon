package usecase

import (
	"context"
	"github.com/aether/sync/internal/domain/entity"
)

// AuthUseCase kimlik doğrulama için use case interface
type AuthUseCase interface {
	// Register yeni kullanıcı kaydı oluşturur
	Register(ctx context.Context, profileName, password string, role entity.UserRole) (*entity.User, error)
	
	// Login kullanıcı girişi yapar
	Login(ctx context.Context, profileName, password string) (*AuthToken, error)
	
	// Logout kullanıcı çıkışı yapar
	Logout(ctx context.Context, token string) error
	
	// ValidateToken token'ı doğrular
	ValidateToken(ctx context.Context, token string) (*entity.User, error)
	
	// ChangePassword kullanıcı şifresini değiştirir
	ChangePassword(ctx context.Context, userID, oldPassword, newPassword string) error
	
	// IsAdmin kullanıcının admin olup olmadığını kontrol eder
	IsAdmin(ctx context.Context, userID string) (bool, error)
}

// AuthToken kimlik doğrulama token'ı
type AuthToken struct {
	Token     string
	UserID    string
	ExpiresAt int64
	Role      entity.UserRole
}





