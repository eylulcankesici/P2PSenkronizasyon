package crypto

import (
	"fmt"
	
	"golang.org/x/crypto/bcrypt"
)

const (
	// DefaultCost bcrypt için varsayılan maliyet
	DefaultCost = 12
)

// PasswordHasher şifre hash işlemleri için yardımcı
type PasswordHasher struct {
	cost int
}

// NewPasswordHasher yeni bir PasswordHasher oluşturur
func NewPasswordHasher() *PasswordHasher {
	return &PasswordHasher{
		cost: DefaultCost,
	}
}

// Hash şifreyi hash'ler
func (p *PasswordHasher) Hash(password string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), p.cost)
	if err != nil {
		return "", fmt.Errorf("şifre hash'lenemedi: %w", err)
	}
	
	return string(hash), nil
}

// Verify şifre hash'ini doğrular
func (p *PasswordHasher) Verify(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

// SetCost bcrypt maliyetini ayarlar
func (p *PasswordHasher) SetCost(cost int) {
	if cost >= bcrypt.MinCost && cost <= bcrypt.MaxCost {
		p.cost = cost
	}
}





