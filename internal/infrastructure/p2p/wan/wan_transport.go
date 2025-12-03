package wan

import (
	"context"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/infrastructure/p2p/signaling"
)

// WANTransport WAN üzerinden P2P transport
// Single Responsibility: WAN transport koordinasyonu
// Open/Closed: Interface implement eder, genişletilebilir
type WANTransport struct {
	deviceID   string
	deviceName string
	port       int

	// WAN components
	stunClient  STUNClient
	turnClient  TURNClient
	iceAgent    ICEAgent
	discovery   *WANDiscoveryService

	connMgr     *WebRTCConnectionManager
	signaling   *signaling.SignalingClient

	// Config
	wanConfig config.NetworkConfig

	// Callbacks
	onPeerDiscovered        func(*transport.DiscoveredPeer)
	onPeerLost              func(string)
	onConnectionEstablished func(transport.Connection)
	onConnectionLost        func(string)
	onConnectionRequested   func(deviceID, deviceName string)
	onPeerIDUpdated         func(oldID, newID, newName string)

	// State
	mu     sync.RWMutex
	started bool
}

// NewWANTransport yeni WAN transport oluşturur
func NewWANTransport(deviceID, deviceName string, wanConfig config.NetworkConfig) *WANTransport {
	// STUN client oluştur
	stunClient := NewSTUNClient(wanConfig.STUNServers)

	// TURN client oluştur
	turnClient := NewTURNClient()

	// ICE agent oluştur
	iceAgent := NewICEAgent(
		wanConfig.STUNServers,
		wanConfig.TURNServers,
		wanConfig.WebRTCPortRange,
		time.Duration(wanConfig.ICEGatheringTimeout)*time.Second,
	)

	// Discovery service oluştur
	discovery := NewWANDiscoveryService(deviceID, deviceName)

	// Connection manager oluştur
	connMgr := NewWebRTCConnectionManager(deviceID, deviceName, iceAgent, wanConfig)

	return &WANTransport{
		deviceID:   deviceID,
		deviceName: deviceName,
		port:       wanConfig.ListenPort,
		stunClient: stunClient,
		turnClient: turnClient,
		iceAgent:   iceAgent,
		discovery:  discovery,
		connMgr:    connMgr,
		wanConfig:  wanConfig,
		started:    false,
	}
}

// Start transport'u başlatır
func (t *WANTransport) Start(ctx context.Context) error {
	t.mu.Lock()
	defer t.mu.Unlock()

	if t.started {
		return fmt.Errorf("WAN transport zaten başlatılmış")
	}

	log.Println("🚀 WAN Transport başlatılıyor...")

	// STUN client ile public IP al
	log.Println("📡 Public IP alınıyor...")
	publicIP, err := t.stunClient.GetPublicIP(ctx)
	if err != nil {
		log.Printf("⚠️ Public IP alınamadı: %v (devam ediliyor)", err)
	} else {
		log.Printf("✅ Public IP: %s", publicIP.String())
	}

	// NAT type detect et
	log.Println("📡 NAT type tespit ediliyor...")
	natType, err := t.stunClient.DetectNATType(ctx)
	if err != nil {
		log.Printf("⚠️ NAT type tespit edilemedi: %v (devam ediliyor)", err)
		log.Printf("📡 NAT type: unknown (hata nedeniyle tespit edilemedi)")
	} else {
		log.Printf("✅ NAT type tespit edildi: %s", string(natType))
		if natType == NATTypeSymmetric {
			log.Printf("   ⚠️ Symmetric NAT tespit edildi - TURN server gerekebilir")
		} else if natType == NATTypeNone {
			log.Printf("   ✅ NAT yok - Doğrudan bağlantı mümkün")
		} else {
			log.Printf("   ℹ️ NAT type: %s - STUN ile bağlantı mümkün olabilir", string(natType))
		}
	}

	// TURN server bilgilerini logla
	if len(t.wanConfig.TURNServers) > 0 {
		log.Printf("🔄 TURN server'lar yapılandırıldı: %d server", len(t.wanConfig.TURNServers))
		for i, turnServer := range t.wanConfig.TURNServers {
			log.Printf("   [%d] %s", i+1, turnServer.URL)
		}
	} else {
		log.Println("ℹ️ TURN server yapılandırılmamış (sadece STUN kullanılacak)")
	}

	// ICE agent ile candidate gathering başlat
	log.Println("📡 ICE candidate gathering başlatılıyor...")
	if err := t.iceAgent.StartGathering(ctx); err != nil {
		return fmt.Errorf("ICE candidate gathering başlatılamadı: %w", err)
	}

	// Discovery service başlat
	if err := t.discovery.Start(ctx); err != nil {
		return fmt.Errorf("discovery service başlatılamadı: %w", err)
	}

	// Callbacks bağla
	t.discovery.SetOnPeerDiscovered(t.onPeerDiscovered)
	t.discovery.SetOnPeerLost(t.onPeerLost)

	// Connection manager callback'lerini bağla
	t.connMgr.SetOnConnectionEstablished(func(conn transport.Connection) {
		if t.onConnectionEstablished != nil {
			t.onConnectionEstablished(conn)
		}
	})

	t.connMgr.SetOnConnectionLost(func(peerID string) {
		if t.onConnectionLost != nil {
			t.onConnectionLost(peerID)
		}
	})

	t.connMgr.SetOnPeerIDUpdated(func(oldID, newID, newName string) {
		if t.onPeerIDUpdated != nil {
			t.onPeerIDUpdated(oldID, newID, newName)
		}
	})

	t.started = true
	log.Printf("✅ WAN Transport hazır (device: %s, port: %d)", t.deviceName, t.port)

	return nil
}

// Stop transport'u durdurur
func (t *WANTransport) Stop() error {
	t.mu.Lock()
	defer t.mu.Unlock()

	if !t.started {
		return nil
	}

	log.Println("🛑 WAN Transport durduruluyor...")

	if t.discovery != nil {
		if err := t.discovery.Stop(); err != nil {
			log.Printf("⚠️ Discovery service durdurulamadı: %v", err)
		}
	}

	if t.connMgr != nil {
		if err := t.connMgr.Close(); err != nil {
			log.Printf("⚠️ Connection manager kapatılamadı: %v", err)
		}
	}

	if t.iceAgent != nil {
		if err := t.iceAgent.Close(); err != nil {
			log.Printf("⚠️ ICE agent kapatılamadı: %v", err)
		}
	}

	if t.stunClient != nil {
		if err := t.stunClient.Close(); err != nil {
			log.Printf("⚠️ STUN client kapatılamadı: %v", err)
		}
	}

	if t.turnClient != nil {
		if err := t.turnClient.Close(); err != nil {
			log.Printf("⚠️ TURN client kapatılamadı: %v", err)
		}
	}

	t.started = false
	log.Println("✅ WAN Transport durduruldu")

	return nil
}

// StartDiscovery peer keşfini başlatır
func (t *WANTransport) StartDiscovery(ctx context.Context) error {
	t.mu.RLock()
	defer t.mu.RUnlock()

	if !t.started {
		return fmt.Errorf("WAN transport başlatılmamış")
	}

	// Discovery zaten Start()'ta başlatılıyor
	return nil
}

// StopDiscovery peer keşfini durdurur
func (t *WANTransport) StopDiscovery() error {
	if t.discovery != nil {
		return t.discovery.Stop()
	}
	return nil
}

// GetDiscoveredPeers keşfedilen peer'ları döner
func (t *WANTransport) GetDiscoveredPeers() []*transport.DiscoveredPeer {
	if t.discovery == nil {
		return []*transport.DiscoveredPeer{}
	}
	return t.discovery.GetDiscoveredPeers()
}

// Connect peer'a bağlanır
func (t *WANTransport) Connect(ctx context.Context, peer *transport.DiscoveredPeer) (transport.Connection, error) {
	t.mu.RLock()
	defer t.mu.RUnlock()

	if !t.started {
		return nil, fmt.Errorf("WAN transport başlatılmamış")
	}

	if peer.TransportType != transport.TransportTypeWAN {
		return nil, fmt.Errorf("peer WAN transport tipinde değil: %s", peer.TransportType)
	}

	log.Printf("🔌 WAN bağlantısı başlatılıyor: %s (%s)", peer.DeviceName, peer.DeviceID[:8])

	// WebRTC connection manager ile bağlan
	conn, err := t.connMgr.Connect(ctx, peer)
	if err != nil {
		return nil, fmt.Errorf("WAN bağlantısı kurulamadı: %w", err)
	}

	log.Printf("✅ WAN bağlantısı kuruldu: %s", peer.DeviceID[:8])

	if t.onConnectionEstablished != nil {
		t.onConnectionEstablished(conn)
	}

	return conn, nil
}

// Disconnect peer bağlantısını keser
func (t *WANTransport) Disconnect(peerID string) error {
	t.mu.Lock()
	defer t.mu.Unlock()

	if t.connMgr != nil {
		if err := t.connMgr.Disconnect(peerID); err != nil {
			return err
		}
	}

	if t.onConnectionLost != nil {
		t.onConnectionLost(peerID)
	}

	return nil
}

// GetConnection peer bağlantısını döner
func (t *WANTransport) GetConnection(peerID string) (transport.Connection, bool) {
	if t.connMgr == nil {
		return nil, false
	}
	return t.connMgr.GetConnection(peerID)
}

// GetAllConnections tüm bağlantıları döner
func (t *WANTransport) GetAllConnections() []transport.Connection {
	if t.connMgr == nil {
		return []transport.Connection{}
	}
	return t.connMgr.GetAllConnections()
}

// GetTransportType transport türünü döner
func (t *WANTransport) GetTransportType() transport.TransportType {
	return transport.TransportTypeWAN
}

// GetListenPort dinleme portunu döner
func (t *WANTransport) GetListenPort() int {
	return t.port
}

// GetDeviceID cihaz ID'sini döner
func (t *WANTransport) GetDeviceID() string {
	return t.deviceID
}

// GetDeviceName cihaz adını döner
func (t *WANTransport) GetDeviceName() string {
	return t.deviceName
}

// Callback setters

// OnPeerDiscovered peer keşfedildiğinde çağrılacak callback'i ayarlar
func (t *WANTransport) OnPeerDiscovered(callback func(*transport.DiscoveredPeer)) {
	t.onPeerDiscovered = callback
	if t.discovery != nil {
		t.discovery.SetOnPeerDiscovered(callback)
	}
}

// OnPeerLost peer kaybedildiğinde çağrılacak callback'i ayarlar
func (t *WANTransport) OnPeerLost(callback func(string)) {
	t.onPeerLost = callback
	if t.discovery != nil {
		t.discovery.SetOnPeerLost(callback)
	}
}

// OnConnectionEstablished bağlantı kurulduğunda çağrılacak callback'i ayarlar
func (t *WANTransport) OnConnectionEstablished(callback func(transport.Connection)) {
	t.onConnectionEstablished = callback
	if t.connMgr != nil {
		t.connMgr.SetOnConnectionEstablished(callback)
	}
}

// OnConnectionLost bağlantı kesildiğinde çağrılacak callback'i ayarlar
func (t *WANTransport) OnConnectionLost(callback func(string)) {
	t.onConnectionLost = callback
	if t.connMgr != nil {
		t.connMgr.SetOnConnectionLost(callback)
	}
}

// SetChunkHandler chunk handler'ı set eder
func (t *WANTransport) SetChunkHandler(handler func(chunkHash string) ([]byte, error)) {
	if t.connMgr != nil {
		t.connMgr.SetChunkHandler(handler)
	}
}

// GetPendingConnections bekleyen bağlantı isteklerini döner
func (t *WANTransport) GetPendingConnections() []*PendingConnection {
	if t.connMgr == nil {
		return []*PendingConnection{}
	}
	return t.connMgr.GetPendingConnections()
}

// GetWebRTCConnectionManager WebRTC connection manager'ı döner (callback bağlamak için)
func (t *WANTransport) GetWebRTCConnectionManager() *WebRTCConnectionManager {
	return t.connMgr
}

// GetPublicIP public IP adresini döner
func (t *WANTransport) GetPublicIP(ctx context.Context) (string, error) {
	if t.stunClient == nil {
		return "", fmt.Errorf("STUN client hazır değil")
	}

	ip, err := t.stunClient.GetPublicIP(ctx)
	if err != nil {
		return "", err
	}

	return ip.String(), nil
}

// GetNATType NAT tipini döner
func (t *WANTransport) GetNATType(ctx context.Context) (string, error) {
	if t.stunClient == nil {
		return "", fmt.Errorf("STUN client hazır değil")
	}

	natType, err := t.stunClient.DetectNATType(ctx)
	if err != nil {
		return "", err
	}

	return string(natType), nil
}

// GetICECandidates ICE candidate'ları döner
func (t *WANTransport) GetICECandidates() ([]ICECandidate, error) {
	if t.iceAgent == nil {
		return nil, fmt.Errorf("ICE agent hazır değil")
	}

	return t.iceAgent.GetLocalCandidates()
}


// SetOnPeerIDUpdated peer ID updated callback'ini ayarlar
func (t *WANTransport) SetOnPeerIDUpdated(callback func(oldID, newID, newName string)) {
	t.onPeerIDUpdated = callback
}

// StartSignaling signaling başlatır
func (t *WANTransport) StartSignaling(serverURL, roomID string) (*signaling.SignalingClient, error) {
	client := signaling.NewSignalingClient(serverURL)
	if err := client.Connect(); err != nil {
		return nil, fmt.Errorf("signaling bağlantı hatası: %w", err)
	}

	if err := client.JoinRoom(roomID); err != nil {
		client.Close()
		return nil, fmt.Errorf("oda katılma hatası: %w", err)
	}

	t.mu.Lock()
	t.signaling = client
	t.mu.Unlock()

	return client, nil
}

// GetDiscoveryService discovery service'i döner (invitation için)
func (t *WANTransport) GetDiscoveryService() *WANDiscoveryService {
	return t.discovery
}
