package hashing

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"os"
)

// Hasher dosya hash işlemleri için yardımcı
// Single Responsibility: Sadece hash hesaplama
type Hasher struct{}

// NewHasher yeni bir Hasher oluşturur
func NewHasher() *Hasher {
	return &Hasher{}
}

// HashFile dosyanın SHA-256 hash'ini hesaplar
func (h *Hasher) HashFile(filePath string) (string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return "", fmt.Errorf("dosya açılamadı: %w", err)
	}
	defer file.Close()
	
	hasher := sha256.New()
	if _, err := io.Copy(hasher, file); err != nil {
		return "", fmt.Errorf("dosya hash'i hesaplanamadı: %w", err)
	}
	
	return hex.EncodeToString(hasher.Sum(nil)), nil
}

// HashBytes byte array'in SHA-256 hash'ini hesaplar
func (h *Hasher) HashBytes(data []byte) string {
	hash := sha256.Sum256(data)
	return hex.EncodeToString(hash[:])
}

// HashString string'in SHA-256 hash'ini hesaplar
func (h *Hasher) HashString(s string) string {
	return h.HashBytes([]byte(s))
}

// VerifyFileHash dosya hash'ini doğrular
func (h *Hasher) VerifyFileHash(filePath, expectedHash string) (bool, error) {
	actualHash, err := h.HashFile(filePath)
	if err != nil {
		return false, err
	}
	
	return actualHash == expectedHash, nil
}

// CompareFiles iki dosyanın hash'lerini karşılaştırır
func (h *Hasher) CompareFiles(file1Path, file2Path string) (bool, error) {
	hash1, err := h.HashFile(file1Path)
	if err != nil {
		return false, fmt.Errorf("dosya1 hash'i hesaplanamadı: %w", err)
	}
	
	hash2, err := h.HashFile(file2Path)
	if err != nil {
		return false, fmt.Errorf("dosya2 hash'i hesaplanamadı: %w", err)
	}
	
	return hash1 == hash2, nil
}





