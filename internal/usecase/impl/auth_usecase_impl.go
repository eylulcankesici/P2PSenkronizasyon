package impl

import (
	"context"
	"fmt"
	"time"
	
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/usecase"
	"github.com/aether/sync/pkg/crypto"
	"github.com/google/uuid"
)

// AuthUseCaseImpl auth use case implementasyonu
type AuthUseCaseImpl struct {
	userRepo       repository.UserRepository
	passwordHasher *crypto.PasswordHasher
	// Token store için simple bir in-memory map (gerçek implementasyonda Redis vs kullanılabilir)
	tokenStore map[string]*usecase.AuthToken
}

// NewAuthUseCase yeni bir AuthUseCase oluşturur
func NewAuthUseCase(userRepo repository.UserRepository) usecase.AuthUseCase {
	return &AuthUseCaseImpl{
		userRepo:       userRepo,
		passwordHasher: crypto.NewPasswordHasher(),
		tokenStore:     make(map[string]*usecase.AuthToken),
	}
}

// Register yeni kullanıcı kaydı oluşturur
func (uc *AuthUseCaseImpl) Register(ctx context.Context, profileName, password string, role entity.UserRole) (*entity.User, error) {
	// Kullanıcı adı kontrolü
	existingUser, err := uc.userRepo.GetByProfileName(ctx, profileName)
	if err == nil && existingUser != nil {
		return nil, entity.ErrAlreadyExists
	}
	
	// Şifreyi hash'le
	passwordHash, err := uc.passwordHasher.Hash(password)
	if err != nil {
		return nil, fmt.Errorf("şifre hash'lenemedi: %w", err)
	}
	
	// Yeni kullanıcı oluştur
	user := entity.NewUser(profileName, role, passwordHash)
	if err := user.Validate(); err != nil {
		return nil, err
	}
	
	if err := uc.userRepo.Create(ctx, user); err != nil {
		return nil, fmt.Errorf("kullanıcı oluşturulamadı: %w", err)
	}
	
	return user, nil
}

// Login kullanıcı girişi yapar
func (uc *AuthUseCaseImpl) Login(ctx context.Context, profileName, password string) (*usecase.AuthToken, error) {
	// Kullanıcıyı bul
	user, err := uc.userRepo.GetByProfileName(ctx, profileName)
	if err != nil {
		return nil, entity.ErrUnauthorized
	}
	
	// Aktif mi kontrol et
	if !user.IsActive {
		return nil, fmt.Errorf("kullanıcı aktif değil")
	}
	
	// Şifreyi doğrula
	if !uc.passwordHasher.Verify(password, user.PasswordHash) {
		return nil, entity.ErrUnauthorized
	}
	
	// Token oluştur
	token := &usecase.AuthToken{
		Token:     uuid.New().String(),
		UserID:    user.ID,
		ExpiresAt: time.Now().Add(24 * time.Hour).Unix(), // 24 saat
		Role:      user.Role,
	}
	
	// Token'ı store'a kaydet
	uc.tokenStore[token.Token] = token
	
	return token, nil
}

// Logout kullanıcı çıkışı yapar
func (uc *AuthUseCaseImpl) Logout(ctx context.Context, token string) error {
	delete(uc.tokenStore, token)
	return nil
}

// ValidateToken token'ı doğrular
func (uc *AuthUseCaseImpl) ValidateToken(ctx context.Context, token string) (*entity.User, error) {
	// Token'ı bul
	authToken, exists := uc.tokenStore[token]
	if !exists {
		return nil, entity.ErrUnauthorized
	}
	
	// Süresi dolmuş mu kontrol et
	if time.Now().Unix() > authToken.ExpiresAt {
		delete(uc.tokenStore, token)
		return nil, entity.ErrUnauthorized
	}
	
	// Kullanıcıyı getir
	user, err := uc.userRepo.GetByID(ctx, authToken.UserID)
	if err != nil {
		return nil, entity.ErrUnauthorized
	}
	
	return user, nil
}

// ChangePassword kullanıcı şifresini değiştirir
func (uc *AuthUseCaseImpl) ChangePassword(ctx context.Context, userID, oldPassword, newPassword string) error {
	// Kullanıcıyı bul
	user, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return err
	}
	
	// Eski şifreyi doğrula
	if !uc.passwordHasher.Verify(oldPassword, user.PasswordHash) {
		return entity.ErrUnauthorized
	}
	
	// Yeni şifreyi hash'le
	newPasswordHash, err := uc.passwordHasher.Hash(newPassword)
	if err != nil {
		return fmt.Errorf("yeni şifre hash'lenemedi: %w", err)
	}
	
	// Şifreyi güncelle
	if err := uc.userRepo.UpdatePassword(ctx, userID, newPasswordHash); err != nil {
		return fmt.Errorf("şifre güncellenemedi: %w", err)
	}
	
	return nil
}

// IsAdmin kullanıcının admin olup olmadığını kontrol eder
func (uc *AuthUseCaseImpl) IsAdmin(ctx context.Context, userID string) (bool, error) {
	user, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return false, err
	}
	
	return user.IsAdmin(), nil
}





