package wan

import (
	"context"
	"fmt"
	"log"
	"net"
	"sync"
	"time"

	"github.com/pion/stun"
)

// NATType NAT tipi
type NATType string

const (
	NATTypeUnknown           NATType = "unknown"
	NATTypeNone              NATType = "none"                // Public IP, NAT yok
	NATTypeFullCone          NATType = "full_cone"           // Endpoint-independent mapping, endpoint-independent filtering
	NATTypeRestrictedCone    NATType = "restricted_cone"     // Endpoint-independent mapping, address-dependent filtering
	NATTypePortRestrictedCone NATType = "port_restricted_cone" // Endpoint-independent mapping, address and port-dependent filtering
	NATTypeSymmetric         NATType = "symmetric"           // Address-dependent mapping
)

// STUNClient STUN client interface'i
type STUNClient interface {
	GetPublicIP(ctx context.Context) (net.IP, error)
	GetMappedPort(ctx context.Context) (int, error)
	DetectNATType(ctx context.Context) (NATType, error)
	Close() error
}

// stunClientImpl STUN client implementasyonu
type stunClientImpl struct {
	stunServers []string
	conn        net.PacketConn
	mu          sync.RWMutex
	cachedIP    net.IP
	cachedPort  int
	cachedNATType NATType
	lastUpdate  time.Time
	cacheTTL    time.Duration
}

// NewSTUNClient yeni STUN client oluşturur
func NewSTUNClient(stunServers []string) STUNClient {
	if len(stunServers) == 0 {
		// Varsayılan STUN server'ları
		stunServers = []string{
			"stun:stun.l.google.com:19302",
			"stun:stun1.l.google.com:19302",
		}
	}

	return &stunClientImpl{
		stunServers: stunServers,
		cacheTTL:    5 * time.Minute, // 5 dakika cache
	}
}

// GetPublicIP public IP adresini alır
func (c *stunClientImpl) GetPublicIP(ctx context.Context) (net.IP, error) {
	c.mu.RLock()
	if c.cachedIP != nil && time.Since(c.lastUpdate) < c.cacheTTL {
		ip := make(net.IP, len(c.cachedIP))
		copy(ip, c.cachedIP)
		c.mu.RUnlock()
		return ip, nil
	}
	c.mu.RUnlock()

	// UDP connection oluştur
	conn, err := net.ListenPacket("udp4", ":0")
	if err != nil {
		return nil, fmt.Errorf("UDP connection oluşturulamadı: %w", err)
	}
	defer conn.Close()

	// İlk STUN server'ı dene
	for _, serverURL := range c.stunServers {
		ip, err := c.queryPublicIP(ctx, conn, serverURL)
		if err != nil {
			log.Printf("⚠️ STUN server %s'den IP alınamadı: %v", serverURL, err)
			continue
		}

		// Cache'e kaydet
		c.mu.Lock()
		c.cachedIP = ip
		c.lastUpdate = time.Now()
		c.mu.Unlock()

		log.Printf("✅ Public IP alındı: %s (STUN: %s)", ip.String(), serverURL)
		return ip, nil
	}

	return nil, fmt.Errorf("hiçbir STUN server'dan IP alınamadı")
}

// queryPublicIP belirli bir STUN server'dan public IP sorgular
func (c *stunClientImpl) queryPublicIP(ctx context.Context, conn net.PacketConn, serverURL string) (net.IP, error) {
	// STUN server adresini parse et
	addr, err := parseSTUNAddress(serverURL)
	if err != nil {
		return nil, fmt.Errorf("STUN adresi parse edilemedi: %w", err)
	}

	// STUN binding request oluştur
	message := stun.MustBuild(stun.TransactionID, stun.BindingRequest)

	// Timeout ayarla
	deadline := time.Now().Add(5 * time.Second)
	if ctxDeadline, ok := ctx.Deadline(); ok {
		if ctxDeadline.Before(deadline) {
			deadline = ctxDeadline
		}
	}
	conn.SetReadDeadline(deadline)

	// Request gönder
	_, err = conn.WriteTo(message.Raw, addr)
	if err != nil {
		return nil, fmt.Errorf("STUN request gönderilemedi: %w", err)
	}

	// Response al
	buffer := make([]byte, 1500)
	n, _, err := conn.ReadFrom(buffer)
	if err != nil {
		return nil, fmt.Errorf("STUN response alınamadı: %w", err)
	}

	// STUN message parse et
	var responseMessage stun.Message
	if err := responseMessage.UnmarshalBinary(buffer[:n]); err != nil {
		return nil, fmt.Errorf("STUN response parse edilemedi: %w", err)
	}

	// MappedAddress attribute'ünü al
	var mappedAddr stun.XORMappedAddress
	if err := mappedAddr.GetFrom(&responseMessage); err == nil {
		return mappedAddr.IP, nil
	}

	// XORMappedAddress yoksa MappedAddress dene
	var mappedAddr2 stun.MappedAddress
	if err := mappedAddr2.GetFrom(&responseMessage); err == nil {
		return mappedAddr2.IP, nil
	}

	return nil, fmt.Errorf("mapped address bulunamadı")
}

// GetMappedPort mapped port'u alır
func (c *stunClientImpl) GetMappedPort(ctx context.Context) (int, error) {
	c.mu.RLock()
	if c.cachedPort > 0 && time.Since(c.lastUpdate) < c.cacheTTL {
		port := c.cachedPort
		c.mu.RUnlock()
		return port, nil
	}
	c.mu.RUnlock()

	// UDP connection oluştur
	conn, err := net.ListenPacket("udp4", ":0")
	if err != nil {
		return 0, fmt.Errorf("UDP connection oluşturulamadı: %w", err)
	}
	defer conn.Close()

	// İlk STUN server'ı dene
	for _, serverURL := range c.stunServers {
		port, err := c.queryMappedPort(ctx, conn, serverURL)
		if err != nil {
			log.Printf("⚠️ STUN server %s'den port alınamadı: %v", serverURL, err)
			continue
		}

		// Cache'e kaydet
		c.mu.Lock()
		c.cachedPort = port
		c.lastUpdate = time.Now()
		c.mu.Unlock()

		log.Printf("✅ Mapped port alındı: %d (STUN: %s)", port, serverURL)
		return port, nil
	}

	return 0, fmt.Errorf("hiçbir STUN server'dan port alınamadı")
}

// queryMappedPort belirli bir STUN server'dan mapped port sorgular
func (c *stunClientImpl) queryMappedPort(ctx context.Context, conn net.PacketConn, serverURL string) (int, error) {
	// STUN server adresini parse et
	addr, err := parseSTUNAddress(serverURL)
	if err != nil {
		return 0, fmt.Errorf("STUN adresi parse edilemedi: %w", err)
	}

	// STUN binding request oluştur
	message := stun.MustBuild(stun.TransactionID, stun.BindingRequest)

	// Timeout ayarla
	deadline := time.Now().Add(5 * time.Second)
	if ctxDeadline, ok := ctx.Deadline(); ok {
		if ctxDeadline.Before(deadline) {
			deadline = ctxDeadline
		}
	}
	conn.SetReadDeadline(deadline)

	// Request gönder
	_, err = conn.WriteTo(message.Raw, addr)
	if err != nil {
		return 0, fmt.Errorf("STUN request gönderilemedi: %w", err)
	}

	// Response al
	buffer := make([]byte, 1500)
	n, _, err := conn.ReadFrom(buffer)
	if err != nil {
		return 0, fmt.Errorf("STUN response alınamadı: %w", err)
	}

	// STUN message parse et
	var responseMessage stun.Message
	if err := responseMessage.UnmarshalBinary(buffer[:n]); err != nil {
		return 0, fmt.Errorf("STUN response parse edilemedi: %w", err)
	}

	// MappedAddress attribute'ünü al
	var mappedAddr stun.XORMappedAddress
	if err := mappedAddr.GetFrom(&responseMessage); err == nil {
		return mappedAddr.Port, nil
	}

	// XORMappedAddress yoksa MappedAddress dene
	var mappedAddr2 stun.MappedAddress
	if err := mappedAddr2.GetFrom(&responseMessage); err == nil {
		return mappedAddr2.Port, nil
	}

	return 0, fmt.Errorf("mapped port bulunamadı")
}

// DetectNATType NAT tipini tespit eder
func (c *stunClientImpl) DetectNATType(ctx context.Context) (NATType, error) {
	c.mu.RLock()
	if c.cachedNATType != NATTypeUnknown && time.Since(c.lastUpdate) < c.cacheTTL {
		natType := c.cachedNATType
		c.mu.RUnlock()
		return natType, nil
	}
	c.mu.RUnlock()

	// Basit NAT type detection
	// Full detection için multiple STUN server ve endpoint testleri gerekir
	// Şimdilik basit bir yaklaşım kullanıyoruz

	// Public IP al
	publicIP, err := c.GetPublicIP(ctx)
	if err != nil {
		return NATTypeUnknown, err
	}

	// Local IP al
	localIP := getLocalIP()
	if localIP == nil {
		return NATTypeUnknown, fmt.Errorf("local IP alınamadı")
	}

	// Public IP ile local IP aynıysa NAT yok
	if publicIP.Equal(localIP) {
		c.mu.Lock()
		c.cachedNATType = NATTypeNone
		c.lastUpdate = time.Now()
		c.mu.Unlock()
		return NATTypeNone, nil
	}

	// Şimdilik symmetric NAT varsayıyoruz (en güvenli varsayım)
	// Daha detaylı detection için ek testler gerekir
	c.mu.Lock()
	c.cachedNATType = NATTypeSymmetric
	c.lastUpdate = time.Now()
	c.mu.Unlock()

	log.Printf("📡 NAT type tespit edildi: %s (public: %s, local: %s)", NATTypeSymmetric, publicIP, localIP)
	return NATTypeSymmetric, nil
}

// Close STUN client'ı kapatır
func (c *stunClientImpl) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.conn != nil {
		if err := c.conn.Close(); err != nil {
			return err
		}
		c.conn = nil
	}

	return nil
}

// parseSTUNAddress STUN URL'sini net.UDPAddr'e çevirir
func parseSTUNAddress(url string) (*net.UDPAddr, error) {
	// Format: "stun:host:port" veya "stun://host:port"
	url = removePrefix(url, "stun://")
	url = removePrefix(url, "stun:")

	// Host ve port'u ayır
	addr, err := net.ResolveUDPAddr("udp", url)
	if err != nil {
		return nil, fmt.Errorf("STUN adresi resolve edilemedi: %w", err)
	}

	return addr, nil
}

// removePrefix string'in başındaki prefix'i kaldırır
func removePrefix(s, prefix string) string {
	if len(s) >= len(prefix) && s[:len(prefix)] == prefix {
		return s[len(prefix):]
	}
	return s
}

// getLocalIP local IP adresini alır
func getLocalIP() net.IP {
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		return nil
	}
	defer conn.Close()

	localAddr := conn.LocalAddr().(*net.UDPAddr)
	return localAddr.IP
}

