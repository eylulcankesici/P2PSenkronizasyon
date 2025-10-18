package entity

import (
	"time"
)

// UserRole kullanıcı rolünü tanımlar
type UserRole string

const (
	UserRoleAdmin    UserRole = "admin"
	UserRoleStandard UserRole = "standard"
)

// User sistem kullanıcısını temsil eder
type User struct {
	ID           string
	ProfileName  string
	Role         UserRole
	PasswordHash string // Bcrypt hash
	IsActive     bool
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// NewUser yeni bir User oluşturur
func NewUser(profileName string, role UserRole, passwordHash string) *User {
	now := time.Now()
	return &User{
		ProfileName:  profileName,
		Role:         role,
		PasswordHash: passwordHash,
		IsActive:     true,
		CreatedAt:    now,
		UpdatedAt:    now,
	}
}

// Validate kullanıcının geçerliliğini kontrol eder
func (u *User) Validate() error {
	if u.ProfileName == "" {
		return ErrInvalidProfileName
	}
	
	if u.Role != UserRoleAdmin && u.Role != UserRoleStandard {
		return ErrInvalidUserRole
	}
	
	if u.PasswordHash == "" {
		return ErrInvalidPasswordHash
	}
	
	return nil
}

// IsAdmin kullanıcının admin olup olmadığını kontrol eder
func (u *User) IsAdmin() bool {
	return u.Role == UserRoleAdmin
}

// Activate kullanıcıyı aktif hale getirir
func (u *User) Activate() {
	u.IsActive = true
	u.UpdatedAt = time.Now()
}

// Deactivate kullanıcıyı pasif hale getirir
func (u *User) Deactivate() {
	u.IsActive = false
	u.UpdatedAt = time.Now()
}

// UpdatePassword şifre hash'ini günceller
func (u *User) UpdatePassword(newPasswordHash string) {
	u.PasswordHash = newPasswordHash
	u.UpdatedAt = time.Now()
}




