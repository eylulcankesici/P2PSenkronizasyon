package lan

import (
	"context"
	"fmt"
	"log"
	"net"
	"strconv"
	"sync"
	"time"

	"github.com/hashicorp/mdns"

	"github.com/aether/sync/internal/domain/transport"
)

const (
	// AetherServiceName mDNS servis adı
	AetherServiceName = "_aether._tcp"
	
	// DiscoveryInterval peer keşif aralığı
	DiscoveryInterval = 30 * time.Second // 5 saniyeden 30 saniyeye çıkarıldı
	
	// PeerTimeout peer timeout süresi
	PeerTimeout = 90 * time.Second // 15 saniyeden 90 saniyeye çıkarıldı
)

// MDNSDiscoveryService mDNS tabanlı peer keşif servisi
// Single Responsibility: Sadece mDNS keşif
type MDNSDiscoveryService struct {
	deviceID   string
	deviceName string
	port       int
	metadata   map[string]string
	
	server *mdns.Server
	
	discoveredPeers map[string]*transport.DiscoveredPeer
	mu              sync.RWMutex
	
	ctx    context.Context
	cancel context.CancelFunc
	
	// Callbacks
	onPeerDiscovered func(*transport.DiscoveredPeer)
	onPeerLost       func(string)
}

// NewMDNSDiscoveryService yeni mDNS discovery servisi oluşturur
func NewMDNSDiscoveryService(deviceID, deviceName string, port int) *MDNSDiscoveryService {
	ctx, cancel := context.WithCancel(context.Background())
	
	return &MDNSDiscoveryService{
		deviceID:        deviceID,
		deviceName:      deviceName,
		port:            port,
		metadata:        make(map[string]string),
		discoveredPeers: make(map[string]*transport.DiscoveredPeer),
		ctx:             ctx,
		cancel:          cancel,
	}
}

// Start mDNS keşfi başlatır
func (s *MDNSDiscoveryService) Start(ctx context.Context) error {
	log.Println("🔍 mDNS Discovery başlatılıyor...")
	
	// mDNS server başlat (announce)
	if err := s.Announce(s.deviceID, s.deviceName, s.port, s.metadata); err != nil {
		return fmt.Errorf("mDNS announce başarısız: %w", err)
	}
	
	// Periyodik peer keşfi başlat
	go s.discoveryLoop()
	
	// Timeout kontrolü
	go s.timeoutLoop()
	
	log.Printf("✅ mDNS Discovery başlatıldı (servis: %s.local, port: %d)", AetherServiceName, s.port)
	
	return nil
}

// Stop mDNS keşfi durdurur
func (s *MDNSDiscoveryService) Stop() error {
	log.Println("🛑 mDNS Discovery durduruluyor...")
	
	s.cancel()
	
	if s.server != nil {
		if err := s.server.Shutdown(); err != nil {
			log.Printf("⚠️  mDNS server shutdown hatası: %v", err)
		}
	}
	
	log.Println("✅ mDNS Discovery durduruldu")
	return nil
}

// Announce cihazı mDNS üzerinden duyurur
func (s *MDNSDiscoveryService) Announce(deviceID, deviceName string, port int, metadata map[string]string) error {
	// TXT records hazırla
	txtRecords := []string{
		"device_id=" + deviceID,
		"device_name=" + deviceName,
		"version=1.0.0",
	}
	
	for key, value := range metadata {
		txtRecords = append(txtRecords, key+"="+value)
	}
	
	// mDNS service info
	service, err := mdns.NewMDNSService(
		deviceName,          // Instance name
		AetherServiceName,   // Service type
		"",                  // Domain (local)
		"",                  // Host name (auto-detect)
		port,                // Port
		nil,                 // IPs (auto-detect)
		txtRecords,          // TXT records
	)
	if err != nil {
		return fmt.Errorf("mDNS service oluşturulamadı: %w", err)
	}
	
	// mDNS server başlat
	server, err := mdns.NewServer(&mdns.Config{Zone: service})
	if err != nil {
		return fmt.Errorf("mDNS server başlatılamadı: %w", err)
	}
	
	s.server = server
	
	log.Printf("📡 mDNS Announce: %s (%s) on port %d", deviceName, deviceID, port)
	
	return nil
}

// GetDiscoveredPeers keşfedilen peer'ları döner
func (s *MDNSDiscoveryService) GetDiscoveredPeers() []*transport.DiscoveredPeer {
	s.mu.RLock()
	defer s.mu.RUnlock()
	
	peers := make([]*transport.DiscoveredPeer, 0, len(s.discoveredPeers))
	for _, peer := range s.discoveredPeers {
		peers = append(peers, peer)
	}
	
	return peers
}

// discoveryLoop periyodik peer keşfi yapar
func (s *MDNSDiscoveryService) discoveryLoop() {
	ticker := time.NewTicker(DiscoveryInterval)
	defer ticker.Stop()
	
	// İlk keşfi hemen yap
	s.queryPeers()
	
	for {
		select {
		case <-s.ctx.Done():
			return
		case <-ticker.C:
			s.queryPeers()
		}
	}
}

// queryPeers mDNS sorgusu yapar
func (s *MDNSDiscoveryService) queryPeers() {
	entriesCh := make(chan *mdns.ServiceEntry, 10)
	
	go func() {
		for entry := range entriesCh {
			s.handleDiscoveredPeer(entry)
		}
	}()
	
	// mDNS query
	params := &mdns.QueryParam{
		Service:             AetherServiceName,
		Domain:              "local",
		Timeout:             2 * time.Second,
		Entries:             entriesCh,
		WantUnicastResponse: false,
	}
	
	if err := mdns.Query(params); err != nil {
		log.Printf("⚠️  mDNS query hatası: %v", err)
	}
	
	close(entriesCh)
}

// handleDiscoveredPeer keşfedilen peer'ı işler
func (s *MDNSDiscoveryService) handleDiscoveredPeer(entry *mdns.ServiceEntry) {
	// Kendi cihazımızı filtrele
	deviceID := extractTXTValue(entry.InfoFields, "device_id")
	if deviceID == s.deviceID {
		return
	}
	
	if deviceID == "" {
		log.Printf("⚠️  Geçersiz mDNS entry (device_id yok): %s", entry.Name)
		return
	}
	
	// Peer bilgilerini çıkar
	deviceName := extractTXTValue(entry.InfoFields, "device_name")
	if deviceName == "" {
		deviceName = entry.Name
	}
	
	version := extractTXTValue(entry.InfoFields, "version")
	
	// Adresleri topla
	addresses := make([]string, 0)
	if entry.AddrV4 != nil {
		addresses = append(addresses, net.JoinHostPort(entry.AddrV4.String(), strconv.Itoa(entry.Port)))
	}
	if entry.AddrV6 != nil {
		addresses = append(addresses, net.JoinHostPort(entry.AddrV6.String(), strconv.Itoa(entry.Port)))
	}
	
	if len(addresses) == 0 {
		log.Printf("⚠️  Peer adresi bulunamadı: %s", deviceID)
		return
	}
	
	// Metadata hazırla
	metadata := make(map[string]string)
	for _, field := range entry.InfoFields {
		if key, value := parseTXTRecord(field); key != "" {
			metadata[key] = value
		}
	}
	
	// DiscoveredPeer oluştur
	peer := &transport.DiscoveredPeer{
		DeviceID:      deviceID,
		DeviceName:    deviceName,
		Addresses:     addresses,
		Port:          entry.Port,
		Version:       version,
		Metadata:      metadata,
		DiscoveredAt:  time.Now(),
		TransportType: transport.TransportTypeLAN,
	}
	
	// Peer'ı kaydet
	s.mu.Lock()
	existingPeer, exists := s.discoveredPeers[deviceID]
	s.discoveredPeers[deviceID] = peer
	s.mu.Unlock()
	
	if !exists {
		log.Printf("🆕 Peer keşfedildi: %s (%s) @ %s", deviceName, deviceID[:8], addresses[0])
		
		if s.onPeerDiscovered != nil {
			s.onPeerDiscovered(peer)
		}
	} else {
		// Mevcut peer'ı güncelle
		existingPeer.DiscoveredAt = time.Now()
	}
}

// timeoutLoop peer timeout'larını kontrol eder
func (s *MDNSDiscoveryService) timeoutLoop() {
	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-s.ctx.Done():
			return
		case <-ticker.C:
			s.checkTimeouts()
		}
	}
}

// checkTimeouts timeout olan peer'ları temizler
func (s *MDNSDiscoveryService) checkTimeouts() {
	s.mu.Lock()
	defer s.mu.Unlock()
	
	now := time.Now()
	for deviceID, peer := range s.discoveredPeers {
		if now.Sub(peer.DiscoveredAt) > PeerTimeout {
			delete(s.discoveredPeers, deviceID)
			log.Printf("⏱️  Peer timeout: %s (%s)", peer.DeviceName, deviceID[:8])
			
			if s.onPeerLost != nil {
				s.onPeerLost(deviceID)
			}
		}
	}
}

// SetOnPeerDiscovered peer keşfedildiğinde callback
func (s *MDNSDiscoveryService) SetOnPeerDiscovered(callback func(*transport.DiscoveredPeer)) {
	s.onPeerDiscovered = callback
}

// SetOnPeerLost peer kaybolduğunda callback
func (s *MDNSDiscoveryService) SetOnPeerLost(callback func(string)) {
	s.onPeerLost = callback
}

// Helper functions

// extractTXTValue TXT record'dan değer çıkarır
func extractTXTValue(fields []string, key string) string {
	prefix := key + "="
	for _, field := range fields {
		if len(field) > len(prefix) && field[:len(prefix)] == prefix {
			return field[len(prefix):]
		}
	}
	return ""
}

// parseTXTRecord TXT record'u key=value olarak parse eder
func parseTXTRecord(record string) (key, value string) {
	for i := 0; i < len(record); i++ {
		if record[i] == '=' {
			return record[:i], record[i+1:]
		}
	}
	return "", ""
}

