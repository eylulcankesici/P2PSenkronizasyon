package wan

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"strings"
	"time"
)

// InvitationData invitation code içeriği
type InvitationData struct {
	DeviceID      string         `json:"device_id"`
	DeviceName    string         `json:"device_name"`
	PublicIP      string         `json:"public_ip"`
	GRPCAddress   string         `json:"grpc_address"`   // gRPC server adresi (public IP:port)
	NATType       string         `json:"nat_type"`
	ICECandidates []ICECandidate `json:"ice_candidates"`
	CreatedAt     time.Time      `json:"created_at"`
	ExpiresAt     time.Time      `json:"expires_at"`
	Version       string         `json:"version"`
}

// InvitationService invitation code servisi
type InvitationService struct {
	encryptionKey []byte // 32 bytes (AES-256)
}

// NewInvitationService yeni invitation service oluşturur
// encryptionKey 32 byte olmalı (AES-256 için)
// Eğer nil ise ortak master key kullanılır (tüm cihazlar için aynı)
func NewInvitationService(deviceID string, encryptionKey []byte) *InvitationService {
	key := encryptionKey
	
	// Eğer key yoksa ortak master key kullan (tüm cihazlar için aynı)
	// NOT: Production'da bu key config'den veya environment variable'dan alınmalı
	if len(key) != 32 {
		hasher := sha256.New()
		// Ortak master key - tüm cihazlar için aynı
		hasher.Write([]byte("aether-invitation-master-key-v1"))
		key = hasher.Sum(nil) // 32 bytes
	}
	
	return &InvitationService{
		encryptionKey: key,
	}
}

// GenerateInvitationCode invitation code oluşturur
func (s *InvitationService) GenerateInvitationCode(
	deviceID, deviceName, publicIP, grpcAddress, natType string,
	iceCandidates []ICECandidate,
	expiryDuration time.Duration,
) (string, error) {
	// 1. Invitation data oluştur
	now := time.Now()
	data := InvitationData{
		DeviceID:      deviceID,
		DeviceName:    deviceName,
		PublicIP:      publicIP,
		GRPCAddress:   grpcAddress, // gRPC server adresi (public IP:port)
		NATType:       natType,
		ICECandidates: iceCandidates,
		CreatedAt:     now,
		ExpiresAt:     now.Add(expiryDuration),
		Version:       "1.0",
	}

	// 2. JSON'a çevir
	jsonData, err := json.Marshal(data)
	if err != nil {
		return "", fmt.Errorf("invitation data marshal hatası: %w", err)
	}

	// 3. Şifrele (AES-256-GCM)
	encrypted, err := s.encrypt(jsonData)
	if err != nil {
		return "", fmt.Errorf("invitation data encryption hatası: %w", err)
	}

	// 4. Base64 URL-safe encode
	code := base64.URLEncoding.EncodeToString(encrypted)

	return code, nil
}

// ParseInvitationCode invitation code'u parse eder
func (s *InvitationService) ParseInvitationCode(code string) (*InvitationData, error) {
	// 0. Code'u temizle (boşluklar, yeni satırlar, URL encoding karakterleri)
	code = strings.TrimSpace(code)
	code = strings.ReplaceAll(code, "\n", "")
	code = strings.ReplaceAll(code, "\r", "")
	code = strings.ReplaceAll(code, " ", "")
	
	// 1. Base64 decode (URL-safe encoding kullanılıyor)
	encrypted, err := base64.URLEncoding.DecodeString(code)
	if err != nil {
		// Eğer URL-safe decode başarısız olursa, standart base64 dene
		encrypted, err = base64.StdEncoding.DecodeString(code)
		if err != nil {
			return nil, fmt.Errorf("invitation code decode hatası: %w", err)
		}
	}

	// 2. Decrypt
	decrypted, err := s.decrypt(encrypted)
	if err != nil {
		return nil, fmt.Errorf("invitation code decryption hatası: %w", err)
	}

	// 3. JSON parse
	var data InvitationData
	if err := json.Unmarshal(decrypted, &data); err != nil {
		return nil, fmt.Errorf("invitation data unmarshal hatası: %w", err)
	}

	// 4. Expiry kontrol
	if time.Now().After(data.ExpiresAt) {
		return nil, fmt.Errorf("invitation code expired (expired at: %v)", data.ExpiresAt)
	}

	// 5. Version kontrol (opsiyonel, gelecek uyumluluk için)
	if data.Version != "1.0" {
		return nil, fmt.Errorf("unsupported invitation code version: %s", data.Version)
	}

	return &data, nil
}

// encrypt AES-256-GCM ile şifreler
func (s *InvitationService) encrypt(plaintext []byte) ([]byte, error) {
	block, err := aes.NewCipher(s.encryptionKey)
	if err != nil {
		return nil, fmt.Errorf("cipher oluşturulamadı: %w", err)
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, fmt.Errorf("GCM oluşturulamadı: %w", err)
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err := rand.Read(nonce); err != nil {
		return nil, fmt.Errorf("nonce oluşturulamadı: %w", err)
	}

	ciphertext := gcm.Seal(nonce, nonce, plaintext, nil)
	return ciphertext, nil
}

// decrypt AES-256-GCM ile şifre çözer
func (s *InvitationService) decrypt(ciphertext []byte) ([]byte, error) {
	block, err := aes.NewCipher(s.encryptionKey)
	if err != nil {
		return nil, fmt.Errorf("cipher oluşturulamadı: %w", err)
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, fmt.Errorf("GCM oluşturulamadı: %w", err)
	}

	nonceSize := gcm.NonceSize()
	if len(ciphertext) < nonceSize {
		return nil, fmt.Errorf("ciphertext too short")
	}

	nonce, ciphertext := ciphertext[:nonceSize], ciphertext[nonceSize:]
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return nil, fmt.Errorf("decryption hatası: %w", err)
	}

	return plaintext, nil
}

// GenerateInvitationLink invitation link oluşturur
// Format: aether://invite?code=<base64_code>
func (s *InvitationService) GenerateInvitationLink(code string) string {
	return fmt.Sprintf("aether://invite?code=%s", code)
}

