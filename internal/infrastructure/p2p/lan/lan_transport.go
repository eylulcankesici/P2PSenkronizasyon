package lan

import (
	"context"
	"fmt"
	"log"
	"net"

	"github.com/aether/sync/internal/domain/transport"
)

// LANTransport LAN üzerinden P2P transport
// Single Responsibility: LAN transport koordinasyonu
// Open/Closed: Interface implement eder, genişletilebilir
type LANTransport struct {
	deviceID   string
	deviceName string
	port       int

	discovery *MDNSDiscoveryService
	connMgr   *TCPConnectionManager

	// Callbacks
	onPeerDiscovered        func(*transport.DiscoveredPeer)
	onPeerLost              func(string)
	onConnectionEstablished func(transport.Connection)
	onConnectionLost        func(string)
}

// NewLANTransport yeni LAN transport oluşturur
func NewLANTransport(deviceID, deviceName string, port int) *LANTransport {
	discovery := NewMDNSDiscoveryService(deviceID, deviceName, port)
	connMgr := NewTCPConnectionManager(port, deviceID, deviceName)

	return &LANTransport{
		deviceID:   deviceID,
		deviceName: deviceName,
		port:       port,
		discovery:  discovery,
		connMgr:    connMgr,
	}
}

// Start transport'u başlatır
func (t *LANTransport) Start(ctx context.Context) error {
	log.Println("🚀 LAN Transport başlatılıyor...")

	// TCP listener başlat
	if err := t.connMgr.Listen(ctx, t.port); err != nil {
		return fmt.Errorf("TCP listener başlatılamadı: %w", err)
	}

	// mDNS discovery başlat
	if err := t.discovery.Start(ctx); err != nil {
		return fmt.Errorf("mDNS discovery başlatılamadı: %w", err)
	}

	// Callbacks bağla
	t.discovery.SetOnPeerDiscovered(t.onPeerDiscovered)
	t.discovery.SetOnPeerLost(t.onPeerLost)

	// Connection lost callback'ini connection manager'a bağla
	t.connMgr.SetOnConnectionLost(func(peerID string) {
		if t.onConnectionLost != nil {
			t.onConnectionLost(peerID)
		}
	})

	log.Printf("✅ LAN Transport hazır (device: %s, port: %d)", t.deviceName, t.port)

	return nil
}

// Stop transport'u durdurur
func (t *LANTransport) Stop() error {
	log.Println("🛑 LAN Transport durduruluyor...")

	t.discovery.Stop()
	t.connMgr.Close()

	log.Println("✅ LAN Transport durduruldu")
	return nil
}

// StartDiscovery peer keşfini başlatır
func (t *LANTransport) StartDiscovery(ctx context.Context) error {
	// Discovery zaten Start()'ta başlatılıyor
	return nil
}

// StopDiscovery peer keşfini durdurur
func (t *LANTransport) StopDiscovery() error {
	return t.discovery.Stop()
}

// GetDiscoveredPeers keşfedilen peer'ları döner
func (t *LANTransport) GetDiscoveredPeers() []*transport.DiscoveredPeer {
	return t.discovery.GetDiscoveredPeers()
}

// Connect peer'a bağlanır
func (t *LANTransport) Connect(ctx context.Context, peer *transport.DiscoveredPeer) (transport.Connection, error) {
	if len(peer.Addresses) == 0 {
		return nil, fmt.Errorf("peer adresi yok: %s", peer.DeviceID)
	}

	// Adresleri önceliklendir (IPv4 private önce, sonra diğerleri)
	sortedAddresses := prioritizeAddresses(peer.Addresses)

	log.Printf("🔌 %d adres deneniyor: %v", len(sortedAddresses), sortedAddresses)

	// Tüm adresleri dene
	var lastErr error
	for i, address := range sortedAddresses {
		log.Printf("  [%d/%d] Adres deneniyor: %s", i+1, len(sortedAddresses), address)

		conn, err := t.connMgr.Connect(ctx, address, peer.DeviceID, peer.DeviceName)
		if err != nil {
			log.Printf("  ❌ Adres başarısız: %s - %v", address, err)
			lastErr = err
			continue // Bir sonraki adresi dene
		}

		log.Printf("  ✅ Bağlantı başarılı: %s", address)

		if t.onConnectionEstablished != nil {
			t.onConnectionEstablished(conn)
		}

		return conn, nil
	}

	// Tüm adresler başarısız oldu
	return nil, fmt.Errorf("tüm adresler başarısız oldu (son hata: %w)", lastErr)
}

// Disconnect peer bağlantısını keser
func (t *LANTransport) Disconnect(peerID string) error {
	// Connection manager'dan bağlantıyı kes ve map'ten kaldır
	if err := t.connMgr.Disconnect(peerID); err != nil {
		return err
	}

	// Callback çağır
	if t.onConnectionLost != nil {
		t.onConnectionLost(peerID)
	}

	return nil
}

// GetConnection peer bağlantısını döner
func (t *LANTransport) GetConnection(peerID string) (transport.Connection, bool) {
	return t.connMgr.GetConnection(peerID)
}

// GetAllConnections tüm bağlantıları döner
func (t *LANTransport) GetAllConnections() []transport.Connection {
	return t.connMgr.GetAllConnections()
}

// GetTransportType transport türünü döner
func (t *LANTransport) GetTransportType() transport.TransportType {
	return transport.TransportTypeLAN
}

// GetListenPort dinleme portunu döner
func (t *LANTransport) GetListenPort() int {
	return t.port
}

// GetDeviceID cihaz ID'sini döner
func (t *LANTransport) GetDeviceID() string {
	return t.deviceID
}

// GetDeviceName cihaz adını döner
func (t *LANTransport) GetDeviceName() string {
	return t.deviceName
}

// Callback setters

func (t *LANTransport) OnPeerDiscovered(callback func(*transport.DiscoveredPeer)) {
	t.onPeerDiscovered = callback
}

func (t *LANTransport) OnPeerLost(callback func(string)) {
	t.onPeerLost = callback
}

func (t *LANTransport) OnConnectionEstablished(callback func(transport.Connection)) {
	t.onConnectionEstablished = callback
}

func (t *LANTransport) OnConnectionLost(callback func(string)) {
	t.onConnectionLost = callback
}

// SetChunkHandler chunk handler'ı set eder
func (t *LANTransport) SetChunkHandler(handler func(chunkHash string) ([]byte, error)) {
	// Connection manager'a handler'ı bağla
	t.connMgr.SetChunkHandler(handler)
}

// GetTCPConnectionManager TCP connection manager'ı döner (internal use)
func (t *LANTransport) GetTCPConnectionManager() *TCPConnectionManager {
	return t.connMgr
}

// prioritizeAddresses adresleri önceliğe göre sıralar
// Öncelik: IPv4 private > IPv4 other > IPv6 (link-local hariç)
func prioritizeAddresses(addresses []string) []string {
	var ipv4Private []string
	var ipv4Other []string
	var ipv6 []string

	for _, addr := range addresses {
		host, _, err := net.SplitHostPort(addr)
		if err != nil {
			// Geçersiz format, sona ekle
			ipv6 = append(ipv6, addr)
			continue
		}

		ip := net.ParseIP(host)
		if ip == nil {
			// Parse edilemeyen, sona ekle
			ipv6 = append(ipv6, addr)
			continue
		}

		if ip.To4() != nil {
			// IPv4
			if ip.IsPrivate() && !ip.IsLoopback() {
				ipv4Private = append(ipv4Private, addr)
			} else {
				ipv4Other = append(ipv4Other, addr)
			}
		} else {
			// IPv6 - link-local'ı zaten filtreledik ama yine de kontrol edelim
			if !ip.IsLinkLocalUnicast() {
				ipv6 = append(ipv6, addr)
			}
		}
	}

	// Öncelik sırası: IPv4 private > IPv4 other > IPv6
	result := append(ipv4Private, ipv4Other...)
	result = append(result, ipv6...)
	return result
}
