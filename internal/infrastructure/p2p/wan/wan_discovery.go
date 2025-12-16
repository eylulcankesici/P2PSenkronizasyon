package wan

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/aether/sync/internal/domain/transport"
)

// WANDiscoveryService WAN peer discovery servisi
// WAN'da mDNS çalışmaz, manuel peer ID girişi veya invitation code kullanılır
type WANDiscoveryService struct {
	deviceID   string
	deviceName string

	// Keşfedilen peer'lar (manuel eklenenler)
	discoveredPeers map[string]*transport.DiscoveredPeer
	mu              sync.RWMutex

	// Oluşturulan invitation code'lar (karşılıklı ekleme için)
	// Key: invitation code, Value: invitation data
	invitationCodes map[string]*InvitationData
	invitationMu    sync.RWMutex

	// State
	started bool

	// Callbacks
	onPeerDiscovered func(*transport.DiscoveredPeer)
	onPeerLost       func(string)
}

// NewWANDiscoveryService yeni WAN discovery service oluşturur
func NewWANDiscoveryService(deviceID, deviceName string) *WANDiscoveryService {
	return &WANDiscoveryService{
		deviceID:        deviceID,
		deviceName:      deviceName,
		discoveredPeers: make(map[string]*transport.DiscoveredPeer),
		invitationCodes: make(map[string]*InvitationData),
		started:         false,
	}
}

// Start discovery service'i başlatır
func (d *WANDiscoveryService) Start(ctx context.Context) error {
	d.mu.Lock()
	defer d.mu.Unlock()

	if d.started {
		return nil
	}

	log.Println("📡 WAN Discovery Service başlatıldı")
	log.Println("   ⚠️ WAN'da otomatik peer keşfi yok, manuel peer ID girişi gerekli")

	d.started = true
	return nil
}

// Stop discovery service'i durdurur
func (d *WANDiscoveryService) Stop() error {
	d.mu.Lock()
	defer d.mu.Unlock()

	if !d.started {
		return nil
	}

	d.started = false
	log.Println("📡 WAN Discovery Service durduruldu")
	return nil
}

// GetDiscoveredPeers keşfedilen peer'ları döner
func (d *WANDiscoveryService) GetDiscoveredPeers() []*transport.DiscoveredPeer {
	d.mu.RLock()
	defer d.mu.RUnlock()

	result := make([]*transport.DiscoveredPeer, 0, len(d.discoveredPeers))
	for _, peer := range d.discoveredPeers {
		result = append(result, peer)
	}

	return result
}

// AddPeer manuel olarak peer ekler (peer ID ile)
func (d *WANDiscoveryService) AddPeer(peerID, peerName string, publicIP string, iceCandidates []ICECandidate) error {
	d.mu.Lock()
	defer d.mu.Unlock()

	if !d.started {
		return fmt.Errorf("discovery service başlatılmamış")
	}

	// Addresses'leri ICE candidate'lardan oluştur
	addresses := make([]string, 0, len(iceCandidates))
	for _, candidate := range iceCandidates {
		addresses = append(addresses, fmt.Sprintf("%s:%d", candidate.IP.String(), candidate.Port))
	}

	// Public IP varsa ekle
	if publicIP != "" {
		// Public IP'yi de adres olarak ekle
		found := false
		for _, addr := range addresses {
			if addr == publicIP {
				found = true
				break
			}
		}
		if !found {
			// Port bilgisi yoksa varsayılan port kullan
			addresses = append(addresses, publicIP)
		}
	}

	// ICE candidates'ı JSON olarak metadata'ya ekle
	iceCandidatesJSON := "[]"
	if len(iceCandidates) > 0 {
		candidatesData := make([]map[string]interface{}, len(iceCandidates))
		for i, cand := range iceCandidates {
			candidatesData[i] = map[string]interface{}{
				"type":     cand.Type,
				"ip":       cand.IP.String(),
				"port":     cand.Port,
				"priority": cand.Priority,
				"protocol": cand.Protocol,
			}
		}
		jsonBytes, err := json.Marshal(candidatesData)
		if err == nil {
			iceCandidatesJSON = string(jsonBytes)
		}
	}

	peer := &transport.DiscoveredPeer{
		DeviceID:      peerID,
		DeviceName:    peerName,
		Addresses:     addresses,
		TransportType: transport.TransportTypeWAN,
		DiscoveredAt:  time.Now(),
		Metadata: map[string]string{
			"public_ip":      publicIP,
			"wan_mode":       "true",
			"ice_candidates": iceCandidatesJSON,
			// grpc_address metadata'ya eklenecek (invitation code'dan gelecek)
		},
	}

	d.discoveredPeers[peerID] = peer

	log.Printf("✅ WAN peer eklendi: %s (%s) - %d adres", peerName, peerID[:8], len(addresses))

	// Callback çağır
	if d.onPeerDiscovered != nil {
		d.onPeerDiscovered(peer)
	}

	return nil
}

// AddPeerWithGRPC peer ekler (gRPC address ile)
func (d *WANDiscoveryService) AddPeerWithGRPC(peerID, peerName string, publicIP, grpcAddress string, iceCandidates []ICECandidate) error {
	d.mu.Lock()
	defer d.mu.Unlock()

	if !d.started {
		return fmt.Errorf("discovery service başlatılmamış")
	}

	// Addresses'leri ICE candidate'lardan oluştur
	addresses := make([]string, 0, len(iceCandidates))
	for _, candidate := range iceCandidates {
		addresses = append(addresses, fmt.Sprintf("%s:%d", candidate.IP.String(), candidate.Port))
	}

	// Public IP varsa ekle
	if publicIP != "" {
		// Public IP'yi de adres olarak ekle
		found := false
		for _, addr := range addresses {
			if addr == publicIP {
				found = true
				break
			}
		}
		if !found {
			// Port bilgisi yoksa varsayılan port kullan
			addresses = append(addresses, publicIP)
		}
	}

	// ICE candidates'ı JSON olarak metadata'ya ekle
	iceCandidatesJSON := "[]"
	if len(iceCandidates) > 0 {
		candidatesData := make([]map[string]interface{}, len(iceCandidates))
		for i, cand := range iceCandidates {
			candidatesData[i] = map[string]interface{}{
				"type":     cand.Type,
				"ip":       cand.IP.String(),
				"port":     cand.Port,
				"priority": cand.Priority,
				"protocol": cand.Protocol,
			}
		}
		jsonBytes, err := json.Marshal(candidatesData)
		if err == nil {
			iceCandidatesJSON = string(jsonBytes)
		}
	}

	metadata := map[string]string{
		"public_ip":      publicIP,
		"wan_mode":       "true",
		"ice_candidates": iceCandidatesJSON,
	}

	// gRPC address varsa metadata'ya ekle
	if grpcAddress != "" {
		metadata["grpc_address"] = grpcAddress
	}

	peer := &transport.DiscoveredPeer{
		DeviceID:      peerID,
		DeviceName:    peerName,
		Addresses:     addresses,
		TransportType: transport.TransportTypeWAN,
		DiscoveredAt:  time.Now(),
		Metadata:      metadata,
	}

	d.discoveredPeers[peerID] = peer

	log.Printf("✅ WAN peer eklendi: %s (%s) - %d adres, gRPC: %s", peerName, peerID[:8], len(addresses), grpcAddress)

	// Callback çağır
	if d.onPeerDiscovered != nil {
		d.onPeerDiscovered(peer)
	}

	return nil
}

// RemovePeer peer'ı kaldırır
func (d *WANDiscoveryService) RemovePeer(peerID string) error {
	d.mu.Lock()
	defer d.mu.Unlock()

	if _, exists := d.discoveredPeers[peerID]; !exists {
		return fmt.Errorf("peer bulunamadı: %s", peerID)
	}

	delete(d.discoveredPeers, peerID)

	log.Printf("🗑️ WAN peer kaldırıldı: %s", peerID[:8])

	// Callback çağır
	if d.onPeerLost != nil {
		d.onPeerLost(peerID)
	}

	return nil
}

// SetOnPeerDiscovered callback'i ayarlar
func (d *WANDiscoveryService) SetOnPeerDiscovered(callback func(*transport.DiscoveredPeer)) {
	d.onPeerDiscovered = callback
}

// SetOnPeerLost callback'i ayarlar
func (d *WANDiscoveryService) SetOnPeerLost(callback func(string)) {
	d.onPeerLost = callback
}

// SaveInvitationCode invitation code'u kaydeder (karşılıklı ekleme için)
func (d *WANDiscoveryService) SaveInvitationCode(code string, data *InvitationData) {
	d.invitationMu.Lock()
	defer d.invitationMu.Unlock()

	d.invitationCodes[code] = data
	log.Printf("💾 Invitation code kaydedildi: %s (device: %s)", code[:20], data.DeviceName)
}

// GetInvitationCode invitation code'u döner
func (d *WANDiscoveryService) GetInvitationCode(code string) *InvitationData {
	d.invitationMu.RLock()
	defer d.invitationMu.RUnlock()

	return d.invitationCodes[code]
}

// RemoveInvitationCode invitation code'u kaldırır (expired olduğunda)
func (d *WANDiscoveryService) RemoveInvitationCode(code string) {
	d.invitationMu.Lock()
	defer d.invitationMu.Unlock()

	delete(d.invitationCodes, code)
	log.Printf("🗑️ Invitation code kaldırıldı: %s", code[:20])
}
