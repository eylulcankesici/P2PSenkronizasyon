package utils

import (
	"crypto/sha256"
	"fmt"
	"net"
	"os"
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
// Öncelik sırası: MAC address -> Hostname -> UUID
func (d *DeviceIDGenerator) GeneratePersistentDeviceID() (string, error) {
	// 1. MAC address tabanlı ID oluşturmayı dene
	if deviceID, err := d.generateFromMAC(); err == nil {
		return deviceID, nil
	}

	// 2. Hostname tabanlı ID oluşturmayı dene
	if deviceID, err := d.generateFromHostname(); err == nil {
		return deviceID, nil
	}

	// 3. Son çare olarak UUID kullan
	return uuid.New().String(), nil
}

// generateFromMAC MAC address tabanlı device ID oluşturur
func (d *DeviceIDGenerator) generateFromMAC() (string, error) {
	interfaces, err := net.Interfaces()
	if err != nil {
		return "", fmt.Errorf("network interfaces alınamadı: %w", err)
	}

	for _, iface := range interfaces {
		// Loopback ve inactive interface'leri atla
		if iface.Flags&net.FlagLoopback != 0 || iface.Flags&net.FlagUp == 0 {
			continue
		}

		// MAC address varsa kullan
		if len(iface.HardwareAddr) >= 6 {
			// MAC address + hostname + timestamp kombinasyonu
			hostname, _ := os.Hostname()
			timestamp := time.Now().Unix()
			
			// Kombinasyonu hash'le
			data := fmt.Sprintf("%s-%s-%d", iface.HardwareAddr.String(), hostname, timestamp)
			hasher := sha256.New()
			hasher.Write([]byte(data))
			hash := hasher.Sum(nil)

			// İlk 16 byte'ı UUID format'ına çevir
			deviceID := fmt.Sprintf("%x-%x-%x-%x-%x",
				hash[0:4], hash[4:6], hash[6:8], hash[8:10], hash[10:16])

			return deviceID, nil
		}
	}

	return "", fmt.Errorf("uygun MAC address bulunamadı")
}

// generateFromHostname hostname tabanlı device ID oluşturur
func (d *DeviceIDGenerator) generateFromHostname() (string, error) {
	hostname, err := os.Hostname()
	if err != nil {
		return "", fmt.Errorf("hostname alınamadı: %w", err)
	}

	// Hostname + timestamp kombinasyonu
	timestamp := time.Now().Unix()
	data := fmt.Sprintf("%s-%d", hostname, timestamp)

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
