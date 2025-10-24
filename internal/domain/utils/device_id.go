package utils

import (
	"crypto/rand"
	"crypto/sha256"
	"fmt"
	"net"
	"os"
	"runtime"
	"time"

	"github.com/google/uuid"
)

// DeviceIDGenerator device ID oluşturma ve yönetimi için yardımcı sınıf
type DeviceIDGenerator struct{}

// NewDeviceIDGenerator yeni bir device ID generator oluşturur
func NewDeviceIDGenerator() *DeviceIDGenerator {
	return &DeviceIDGenerator{}
}

// GeneratePersistentDeviceID kalıcı device ID oluşturur
// Her cihazda farklı ve kalıcı ID oluşturur
func (d *DeviceIDGenerator) GeneratePersistentDeviceID() (string, error) {
	// 1. MAC address + hostname + sistem bilgileri + random kombinasyonu
	if deviceID, err := d.generateUniqueDeviceID(); err == nil {
		return deviceID, nil
	}

	// 2. Fallback: UUID kullan
	return uuid.New().String(), nil
}

// generateUniqueDeviceID benzersiz device ID oluşturur
// MAC address + hostname + sistem bilgileri + random kombinasyonu
func (d *DeviceIDGenerator) generateUniqueDeviceID() (string, error) {
	// 1. MAC address'leri topla
	macAddresses := d.getAllMACAddresses()
	
	// 2. Hostname al
	hostname, err := os.Hostname()
	if err != nil {
		hostname = "unknown-host"
	}
	
	// 3. Sistem bilgileri
	osInfo := runtime.GOOS
	archInfo := runtime.GOARCH
	
	// 4. Random bytes oluştur
	randomBytes := make([]byte, 16)
	if _, err := rand.Read(randomBytes); err != nil {
		return "", fmt.Errorf("random bytes oluşturulamadı: %w", err)
	}
	
	// 5. Tüm bilgileri birleştir
	data := fmt.Sprintf("%s-%s-%s-%s-%x-%d", 
		macAddresses, hostname, osInfo, archInfo, randomBytes, time.Now().UnixNano())
	
	// 6. SHA-256 hash'le
	hasher := sha256.New()
	hasher.Write([]byte(data))
	hash := hasher.Sum(nil)

	// 7. UUID format'ına çevir
	deviceID := fmt.Sprintf("%x-%x-%x-%x-%x",
		hash[0:4], hash[4:6], hash[6:8], hash[8:10], hash[10:16])

	return deviceID, nil
}

// getAllMACAddresses tüm MAC address'leri toplar
func (d *DeviceIDGenerator) getAllMACAddresses() string {
	interfaces, err := net.Interfaces()
	if err != nil {
		return "no-mac"
	}

	var macs []string
	for _, iface := range interfaces {
		// Loopback ve inactive interface'leri atla
		if iface.Flags&net.FlagLoopback != 0 || iface.Flags&net.FlagUp == 0 {
			continue
		}

		// MAC address varsa ekle
		if len(iface.HardwareAddr) >= 6 {
			macs = append(macs, iface.HardwareAddr.String())
		}
	}

	if len(macs) == 0 {
		return "no-mac"
	}

	// Tüm MAC'leri birleştir
	result := ""
	for i, mac := range macs {
		if i > 0 {
			result += "-"
		}
		result += mac
	}

	return result
}

// generateFromHostname hostname tabanlı device ID oluşturur (fallback)
func (d *DeviceIDGenerator) generateFromHostname() (string, error) {
	hostname, err := os.Hostname()
	if err != nil {
		return "", fmt.Errorf("hostname alınamadı: %w", err)
	}

	// Hostname + sistem bilgileri + random kombinasyonu
	osInfo := runtime.GOOS
	archInfo := runtime.GOARCH
	
	// Random bytes oluştur
	randomBytes := make([]byte, 16)
	if _, err := rand.Read(randomBytes); err != nil {
		return "", fmt.Errorf("random bytes oluşturulamadı: %w", err)
	}
	
	// Tüm bilgileri birleştir
	data := fmt.Sprintf("%s-%s-%s-%x-%d", 
		hostname, osInfo, archInfo, randomBytes, time.Now().UnixNano())

	// Hash'le
	hasher := sha256.New()
	hasher.Write([]byte(data))
	hash := hasher.Sum(nil)

	// İlk 16 byte'ı UUID format'ına çevir
	deviceID := fmt.Sprintf("%x-%x-%x-%x-%x",
		hash[0:4], hash[4:6], hash[6:8], hash[8:10], hash[10:16])

	return deviceID, nil
}

// GenerateDeviceName cihaz adı oluşturur
func (d *DeviceIDGenerator) GenerateDeviceName() string {
	hostname, err := os.Hostname()
	if err != nil {
		return "Aether Node"
	}

	// Hostname'i temizle ve formatla
	cleanHostname := d.cleanHostname(hostname)
	return fmt.Sprintf("Aether %s", cleanHostname)
}

// cleanHostname hostname'i temizler ve formatlar
func (d *DeviceIDGenerator) cleanHostname(hostname string) string {
	// Küçük harfe çevir
	hostname = fmt.Sprintf("%c%s", hostname[0], hostname[1:])
	
	// İlk harfi büyük yap
	if len(hostname) > 0 {
		hostname = fmt.Sprintf("%c%s", 
			hostname[0]-32, // ASCII'de büyük harfe çevir
			hostname[1:])
	}

	return hostname
}

// ValidateDeviceID device ID'nin geçerli olup olmadığını kontrol eder
func (d *DeviceIDGenerator) ValidateDeviceID(deviceID string) bool {
	if deviceID == "" {
		return false
	}

	// UUID format kontrolü (xxxx-xxxx-xxxx-xxxx-xxxx)
	if len(deviceID) == 36 {
		// Basit format kontrolü
		for i, char := range deviceID {
			if i == 8 || i == 13 || i == 18 || i == 23 {
				if char != '-' {
					return false
				}
			} else {
				if !((char >= '0' && char <= '9') || (char >= 'a' && char <= 'f') || (char >= 'A' && char <= 'F')) {
					return false
				}
			}
		}
		return true
	}

	return false
}

// IsDeviceIDUnique device ID'nin benzersiz olup olmadığını kontrol eder
func (d *DeviceIDGenerator) IsDeviceIDUnique(deviceID string, existingIDs []string) bool {
	if deviceID == "" {
		return false
	}
	
	// Mevcut ID'lerle karşılaştır
	for _, existingID := range existingIDs {
		if deviceID == existingID {
			return false
		}
	}
	
	return true
}

// GenerateUniqueDeviceID benzersiz device ID oluşturur (çakışma kontrolü ile)
func (d *DeviceIDGenerator) GenerateUniqueDeviceID(existingIDs []string) (string, error) {
	maxAttempts := 10
	
	for attempt := 0; attempt < maxAttempts; attempt++ {
		deviceID, err := d.generateUniqueDeviceID()
		if err != nil {
			continue
		}
		
		// Çakışma kontrolü
		if d.IsDeviceIDUnique(deviceID, existingIDs) {
			return deviceID, nil
		}
		
		// Çakışma varsa, random seed'i değiştir
		time.Sleep(time.Millisecond * 10)
	}
	
	// Son çare: UUID kullan
	return uuid.New().String(), nil
}
