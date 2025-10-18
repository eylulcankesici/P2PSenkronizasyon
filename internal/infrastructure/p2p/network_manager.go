package p2p

import (
	"context"
	"fmt"
	"log"
	"sync"
	
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/google/uuid"
)

// NetworkManager P2P ağ yöneticisi
// Single Responsibility: P2P ağ bağlantılarını yönetir
type NetworkManager struct {
	deviceID   string
	deviceName string
	listenPort int
	
	peerRepo repository.PeerRepository
	
	connectedPeers map[string]*PeerConnection
	mu             sync.RWMutex
	
	ctx    context.Context
	cancel context.CancelFunc
}

// PeerConnection bir peer bağlantısını temsil eder
type PeerConnection struct {
	Peer      *entity.Peer
	Connected bool
	// libp2p host connection bilgileri buraya eklenecek
}

// NewNetworkManager yeni bir NetworkManager oluşturur
func NewNetworkManager(
	peerRepo repository.PeerRepository,
	listenPort int,
) (*NetworkManager, error) {
	deviceID := uuid.New().String()
	
	ctx, cancel := context.WithCancel(context.Background())
	
	nm := &NetworkManager{
		deviceID:       deviceID,
		deviceName:     "Aether Node", // Config'den alınabilir
		listenPort:     listenPort,
		peerRepo:       peerRepo,
		connectedPeers: make(map[string]*PeerConnection),
		ctx:            ctx,
		cancel:         cancel,
	}
	
	return nm, nil
}

// Start P2P networking'i başlatır
func (nm *NetworkManager) Start() error {
	log.Printf("P2P Network Manager başlatılıyor... (Device ID: %s)", nm.deviceID)
	
	// libp2p host'u burada başlatılacak
	// Şimdilik placeholder
	
	log.Printf("✓ P2P Network Manager port %d üzerinde dinliyor", nm.listenPort)
	
	return nil
}

// Stop P2P networking'i durdurur
func (nm *NetworkManager) Stop() error {
	log.Println("P2P Network Manager durduruluyor...")
	
	nm.cancel()
	
	// Tüm peer bağlantılarını kapat
	nm.mu.Lock()
	defer nm.mu.Unlock()
	
	for peerID := range nm.connectedPeers {
		if err := nm.disconnectPeer(peerID); err != nil {
			log.Printf("Peer bağlantısı kesilemedi %s: %v", peerID, err)
		}
	}
	
	log.Println("✓ P2P Network Manager durduruldu")
	return nil
}

// ConnectToPeer belirli bir peer'a bağlanır
func (nm *NetworkManager) ConnectToPeer(peerID string) error {
	nm.mu.Lock()
	defer nm.mu.Unlock()
	
	// Zaten bağlı mı kontrol et
	if conn, exists := nm.connectedPeers[peerID]; exists && conn.Connected {
		return nil
	}
	
	// Peer bilgisini al
	peer, err := nm.peerRepo.GetByID(nm.ctx, peerID)
	if err != nil {
		return fmt.Errorf("peer bulunamadı: %w", err)
	}
	
	// libp2p bağlantısı burada kurulacak
	// Şimdilik placeholder
	
	// Bağlantıyı kaydet
	nm.connectedPeers[peerID] = &PeerConnection{
		Peer:      peer,
		Connected: true,
	}
	
	// Peer durumunu güncelle
	if err := nm.peerRepo.UpdateStatus(nm.ctx, peerID, entity.PeerStatusOnline); err != nil {
		log.Printf("Peer durumu güncellenemedi: %v", err)
	}
	
	log.Printf("✓ Peer'a bağlanıldı: %s (%s)", peer.Name, peer.DeviceID)
	
	return nil
}

// DisconnectFromPeer peer bağlantısını keser
func (nm *NetworkManager) DisconnectFromPeer(peerID string) error {
	nm.mu.Lock()
	defer nm.mu.Unlock()
	
	return nm.disconnectPeer(peerID)
}

// disconnectPeer (internal) peer bağlantısını keser
func (nm *NetworkManager) disconnectPeer(peerID string) error {
	conn, exists := nm.connectedPeers[peerID]
	if !exists {
		return nil
	}
	
	// libp2p bağlantısını kapat
	// Şimdilik placeholder
	
	conn.Connected = false
	delete(nm.connectedPeers, peerID)
	
	// Peer durumunu güncelle
	if err := nm.peerRepo.UpdateStatus(nm.ctx, peerID, entity.PeerStatusOffline); err != nil {
		log.Printf("Peer durumu güncellenemedi: %v", err)
	}
	
	log.Printf("Peer bağlantısı kesildi: %s", peerID)
	
	return nil
}

// DiscoverPeers yerel ağdaki peer'ları keşfeder
func (nm *NetworkManager) DiscoverPeers() ([]*entity.Peer, error) {
	// mDNS ile peer keşfi burada yapılacak
	// Şimdilik veritabanındaki tüm peer'ları döndür
	
	peers, err := nm.peerRepo.GetAll(nm.ctx)
	if err != nil {
		return nil, fmt.Errorf("peer'lar alınamadı: %w", err)
	}
	
	return peers, nil
}

// GetConnectedPeers bağlı peer'ları döner
func (nm *NetworkManager) GetConnectedPeers() []*entity.Peer {
	nm.mu.RLock()
	defer nm.mu.RUnlock()
	
	peers := make([]*entity.Peer, 0, len(nm.connectedPeers))
	for _, conn := range nm.connectedPeers {
		if conn.Connected {
			peers = append(peers, conn.Peer)
		}
	}
	
	return peers
}

// GetDeviceID cihaz ID'sini döner
func (nm *NetworkManager) GetDeviceID() string {
	return nm.deviceID
}

// IsPeerConnected peer'in bağlı olup olmadığını kontrol eder
func (nm *NetworkManager) IsPeerConnected(peerID string) bool {
	nm.mu.RLock()
	defer nm.mu.RUnlock()
	
	conn, exists := nm.connectedPeers[peerID]
	return exists && conn.Connected
}





