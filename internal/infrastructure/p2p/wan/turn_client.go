package wan

import (
	"context"
	"fmt"
	"log"
	"net"
	"sync"
	"time"

	"github.com/aether/sync/internal/config"
	// "github.com/pion/turn/v2" // TODO: ICE agent implementasyonunda kullanılacak
)

// TURNClient TURN client interface'i
type TURNClient interface {
	Allocate(ctx context.Context, server config.TURNServerConfig) (*TURNAllocation, error)
	CreatePermission(ctx context.Context, peerIP net.IP) error
	RelayData(ctx context.Context, data []byte, peerAddr *net.UDPAddr) error
	Close() error
}

// TURNAllocation TURN allocation bilgisi
type TURNAllocation struct {
	RelayAddress *net.UDPAddr // TURN relay endpoint
	MappedAddress *net.UDPAddr // Mapped address
	Lifetime      time.Duration // Allocation lifetime
}

// turnClientImpl TURN client implementasyonu
type turnClientImpl struct {
	conn        *net.UDPConn
	serverAddr  *net.UDPAddr
	username    string
	password    string
	allocation  *TURNAllocation
	mu          sync.RWMutex
	closed      bool
}

// NewTURNClient yeni TURN client oluşturur
func NewTURNClient() TURNClient {
	return &turnClientImpl{
		closed: false,
	}
}

// Allocate TURN allocation oluşturur
func (c *turnClientImpl) Allocate(ctx context.Context, server config.TURNServerConfig) (*TURNAllocation, error) {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.closed {
		return nil, fmt.Errorf("TURN client kapalı")
	}

	// TURN server adresini parse et
	addr, err := parseTURNAddress(server.URL)
	if err != nil {
		return nil, fmt.Errorf("TURN adresi parse edilemedi: %w", err)
	}

	c.serverAddr = addr
	c.username = server.Username
	c.password = server.Password

	// UDP connection oluştur
	conn, err := net.ListenUDP("udp4", nil)
	if err != nil {
		return nil, fmt.Errorf("UDP connection oluşturulamadı: %w", err)
	}

	c.conn = conn

	// TURN allocation request
	allocation, err := c.requestAllocation(ctx, conn, addr, server.Username, server.Password)
	if err != nil {
		conn.Close()
		return nil, fmt.Errorf("TURN allocation başarısız: %w", err)
	}

	c.allocation = allocation
	log.Printf("✅ TURN allocation başarılı: relay=%s, mapped=%s", 
		allocation.RelayAddress.String(), allocation.MappedAddress.String())

	return allocation, nil
}

// requestAllocation TURN allocation isteği gönderir
func (c *turnClientImpl) requestAllocation(ctx context.Context, conn *net.UDPConn, serverAddr *net.UDPAddr, username, password string) (*TURNAllocation, error) {
	// NOT: Bu basit bir placeholder implementasyon
	// Gerçek TURN allocation ICE agent ile entegre edilecek
	// Şimdilik sadece yapıyı hazırlıyoruz
	
	// TODO: Pion TURN client ile gerçek allocation yapılacak
	// ICE agent implementasyonunda TURN client'ı kullanacağız
	
	log.Printf("⚠️ TURN allocation placeholder - gerçek implementasyon ICE agent'ta yapılacak")
	
	// Placeholder allocation
	localAddr := conn.LocalAddr().(*net.UDPAddr)
	
	return &TURNAllocation{
		RelayAddress:  serverAddr, // Placeholder
		MappedAddress: localAddr,
		Lifetime:      10 * time.Minute,
	}, nil
}

// CreatePermission peer IP için TURN permission oluşturur
func (c *turnClientImpl) CreatePermission(ctx context.Context, peerIP net.IP) error {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if c.closed || c.allocation == nil {
		return fmt.Errorf("TURN allocation yok")
	}

	// TURN permission request gönder
	// TODO: Gerçek permission ICE agent ile yönetilecek
	// Pion TURN client ile permission oluştur
	// Bu basit implementasyonda şimdilik placeholder
	// Gerçek permission Pion TURN client içinde otomatik yönetilir

	log.Printf("📝 TURN permission oluşturuldu: peer=%s", peerIP.String())
	return nil
}

// RelayData TURN relay üzerinden data gönderir
func (c *turnClientImpl) RelayData(ctx context.Context, data []byte, peerAddr *net.UDPAddr) error {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if c.closed || c.allocation == nil {
		return fmt.Errorf("TURN allocation yok")
	}

	// TURN relay üzerinden data gönder
	// Basit implementasyon: UDP üzerinden TURN send indication gönder
	// Gerçek implementasyonda Pion TURN client kullanılmalı

	// Timeout ayarla
	deadline := time.Now().Add(5 * time.Second)
	if ctxDeadline, ok := ctx.Deadline(); ok {
		if ctxDeadline.Before(deadline) {
			deadline = ctxDeadline
		}
	}

	if err := c.conn.SetWriteDeadline(deadline); err != nil {
		return fmt.Errorf("deadline ayarlanamadı: %w", err)
	}

	// Data gönder (basit UDP write - gerçekte TURN Send Indication kullanılmalı)
	_, err := c.conn.WriteToUDP(data, c.allocation.RelayAddress)
	if err != nil {
		return fmt.Errorf("data gönderilemedi: %w", err)
	}

	log.Printf("📤 TURN relay üzerinden data gönderildi: %d bytes -> %s", len(data), peerAddr.String())
	return nil
}

// Close TURN client'ı kapatır
func (c *turnClientImpl) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.closed {
		return nil
	}

	c.closed = true

	if c.conn != nil {
		if err := c.conn.Close(); err != nil {
			return err
		}
		c.conn = nil
	}

	if c.allocation != nil {
		// Allocation'ı kapat
		c.allocation = nil
	}

	log.Println("✅ TURN client kapatıldı")
	return nil
}

// parseTURNAddress TURN URL'sini net.UDPAddr'e çevirir
func parseTURNAddress(url string) (*net.UDPAddr, error) {
	// Format: "turn:host:port" veya "turn://host:port"
	url = removePrefix(url, "turn://")
	url = removePrefix(url, "turns://")
	url = removePrefix(url, "turn:")
	url = removePrefix(url, "turns:")

	// Host ve port'u ayır
	addr, err := net.ResolveUDPAddr("udp", url)
	if err != nil {
		return nil, fmt.Errorf("TURN adresi resolve edilemedi: %w", err)
	}

	return addr, nil
}

