package lan

import (
	"encoding/json"
	"fmt"
	"io"
	"net"
	"time"
)

// HandshakeMessage bağlantı kurulurken değiş tokuş edilen mesaj
type HandshakeMessage struct {
	DeviceID   string `json:"device_id"`
	DeviceName string `json:"device_name"`
	Version    string `json:"version"`
	Timestamp  int64  `json:"timestamp"`
}

// HandshakeTimeout handshake için maksimum süre
const HandshakeTimeout = 10 * time.Second

// PerformClientHandshake client tarafında handshake yapar
func PerformClientHandshake(conn net.Conn, deviceID, deviceName string) (*HandshakeMessage, error) {
	// Timeout ayarla
	conn.SetDeadline(time.Now().Add(HandshakeTimeout))
	defer conn.SetDeadline(time.Time{}) // Reset deadline
	
	// Kendi bilgilerimizi gönder
	ourHandshake := &HandshakeMessage{
		DeviceID:   deviceID,
		DeviceName: deviceName,
		Version:    "1.0.0",
		Timestamp:  time.Now().Unix(),
	}
	
	data, err := json.Marshal(ourHandshake)
	if err != nil {
		return nil, fmt.Errorf("handshake marshal hatası: %w", err)
	}
	
	// Handshake mesajı boyutunu gönder (4 bytes)
	size := uint32(len(data))
	sizeBuf := make([]byte, 4)
	sizeBuf[0] = byte(size >> 24)
	sizeBuf[1] = byte(size >> 16)
	sizeBuf[2] = byte(size >> 8)
	sizeBuf[3] = byte(size)
	
	if _, err := conn.Write(sizeBuf); err != nil {
		return nil, fmt.Errorf("handshake size yazılamadı: %w", err)
	}
	
	// Handshake mesajını gönder
	if _, err := conn.Write(data); err != nil {
		return nil, fmt.Errorf("handshake yazılamadı: %w", err)
	}
	
	// Karşı tarafın handshake'ini bekle
	peerHandshake, err := receiveHandshake(conn)
	if err != nil {
		return nil, fmt.Errorf("peer handshake alınamadı: %w", err)
	}
	
	// Version uyumluluğu kontrol et (basit kontrol)
	if peerHandshake.Version != ourHandshake.Version {
		return nil, fmt.Errorf("version uyumsuzluğu: local=%s, peer=%s", 
			ourHandshake.Version, peerHandshake.Version)
	}
	
	return peerHandshake, nil
}

// PerformServerHandshake server tarafında handshake yapar
func PerformServerHandshake(conn net.Conn, deviceID, deviceName string) (*HandshakeMessage, error) {
	// Timeout ayarla
	conn.SetDeadline(time.Now().Add(HandshakeTimeout))
	defer conn.SetDeadline(time.Time{}) // Reset deadline
	
	// Önce karşı tarafın handshake'ini al
	peerHandshake, err := receiveHandshake(conn)
	if err != nil {
		return nil, fmt.Errorf("peer handshake alınamadı: %w", err)
	}
	
	// Kendi bilgilerimizi gönder
	ourHandshake := &HandshakeMessage{
		DeviceID:   deviceID,
		DeviceName: deviceName,
		Version:    "1.0.0",
		Timestamp:  time.Now().Unix(),
	}
	
	data, err := json.Marshal(ourHandshake)
	if err != nil {
		return nil, fmt.Errorf("handshake marshal hatası: %w", err)
	}
	
	// Handshake mesajı boyutunu gönder
	size := uint32(len(data))
	sizeBuf := make([]byte, 4)
	sizeBuf[0] = byte(size >> 24)
	sizeBuf[1] = byte(size >> 16)
	sizeBuf[2] = byte(size >> 8)
	sizeBuf[3] = byte(size)
	
	if _, err := conn.Write(sizeBuf); err != nil {
		return nil, fmt.Errorf("handshake size yazılamadı: %w", err)
	}
	
	// Handshake mesajını gönder
	if _, err := conn.Write(data); err != nil {
		return nil, fmt.Errorf("handshake yazılamadı: %w", err)
	}
	
	// Version uyumluluğu kontrol et
	if peerHandshake.Version != ourHandshake.Version {
		return nil, fmt.Errorf("version uyumsuzluğu: local=%s, peer=%s", 
			ourHandshake.Version, peerHandshake.Version)
	}
	
	return peerHandshake, nil
}

// receiveHandshake handshake mesajını alır
func receiveHandshake(conn net.Conn) (*HandshakeMessage, error) {
	// Mesaj boyutunu oku (4 bytes)
	sizeBuf := make([]byte, 4)
	if _, err := io.ReadFull(conn, sizeBuf); err != nil {
		return nil, fmt.Errorf("handshake size okunamadı: %w", err)
	}
	
	size := uint32(sizeBuf[0])<<24 | uint32(sizeBuf[1])<<16 | 
	        uint32(sizeBuf[2])<<8 | uint32(sizeBuf[3])
	
	// Makul bir boyut kontrolü
	if size > 10*1024 { // 10 KB maksimum
		return nil, fmt.Errorf("handshake mesajı çok büyük: %d bytes", size)
	}
	
	// Handshake mesajını oku
	data := make([]byte, size)
	if _, err := io.ReadFull(conn, data); err != nil {
		return nil, fmt.Errorf("handshake okunamadı: %w", err)
	}
	
	// JSON unmarshal
	var handshake HandshakeMessage
	if err := json.Unmarshal(data, &handshake); err != nil {
		return nil, fmt.Errorf("handshake unmarshal hatası: %w", err)
	}
	
	// Temel validasyon
	if handshake.DeviceID == "" {
		return nil, fmt.Errorf("geçersiz handshake: device_id boş")
	}
	
	return &handshake, nil
}

// ValidateHandshake handshake mesajını doğrular
func ValidateHandshake(handshake *HandshakeMessage) error {
	if handshake.DeviceID == "" {
		return fmt.Errorf("device_id boş olamaz")
	}
	
	if handshake.DeviceName == "" {
		return fmt.Errorf("device_name boş olamaz")
	}
	
	if handshake.Version == "" {
		return fmt.Errorf("version boş olamaz")
	}
	
	// Timestamp kontrolü (çok eski veya gelecek tarihli olmamalı)
	now := time.Now().Unix()
	if handshake.Timestamp < now-3600 || handshake.Timestamp > now+3600 {
		return fmt.Errorf("geçersiz timestamp: %d (now: %d)", handshake.Timestamp, now)
	}
	
	return nil
}

