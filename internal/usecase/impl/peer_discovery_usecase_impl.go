package impl

import (
	"context"
	"fmt"
	"log"

	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/domain/usecase"
)

// PeerDiscoveryUseCaseImpl PeerDiscoveryUseCase implementasyonu
// Dependency Inversion: Interface'lere bağımlı
type PeerDiscoveryUseCaseImpl struct {
	transportProvider transport.TransportProvider
	peerRepo          repository.PeerRepository
}

// NewPeerDiscoveryUseCase yeni use case oluşturur
func NewPeerDiscoveryUseCase(
	transportProvider transport.TransportProvider,
	peerRepo repository.PeerRepository,
) usecase.PeerDiscoveryUseCase {
	return &PeerDiscoveryUseCaseImpl{
		transportProvider: transportProvider,
		peerRepo:          peerRepo,
	}
}

// StartDiscovery peer keşfi başlatır
func (uc *PeerDiscoveryUseCaseImpl) StartDiscovery(ctx context.Context) error {
	log.Println("🔍 Peer discovery başlatılıyor...")

	if err := uc.transportProvider.StartDiscovery(ctx); err != nil {
		return fmt.Errorf("discovery başlatılamadı: %w", err)
	}

	log.Println("✅ Peer discovery başlatıldı")
	return nil
}

// StopDiscovery peer keşfi durdurur
func (uc *PeerDiscoveryUseCaseImpl) StopDiscovery() error {
	log.Println("🛑 Peer discovery durduruluyor...")

	if err := uc.transportProvider.StopDiscovery(); err != nil {
		return fmt.Errorf("discovery durdurulamadı: %w", err)
	}

	log.Println("✅ Peer discovery durduruldu")
	return nil
}

// GetDiscoveredPeers keşfedilen peer'ları döner
func (uc *PeerDiscoveryUseCaseImpl) GetDiscoveredPeers(ctx context.Context) ([]*transport.DiscoveredPeer, error) {
	discoveredPeers := uc.transportProvider.GetDiscoveredPeers()

	log.Printf("📊 GetDiscoveredPeers çağrıldı - Toplam keşfedilen peer sayısı: %d", len(discoveredPeers))
	for i, peer := range discoveredPeers {
		transportTypeStr := "UNKNOWN"
		if peer.TransportType == transport.TransportTypeLAN {
			transportTypeStr = "LAN"
		} else if peer.TransportType == transport.TransportTypeWAN {
			transportTypeStr = "WAN"
		}
		log.Printf("  [%d] %s (%s) - Transport: %s, Adresler: %v",
			i+1, peer.DeviceName, peer.DeviceID[:8], transportTypeStr, peer.Addresses)
	}

	return discoveredPeers, nil
}

// ConnectToPeer peer'a bağlanır
func (uc *PeerDiscoveryUseCaseImpl) ConnectToPeer(ctx context.Context, peerID string) error {
	log.Printf("🔗 Peer'a bağlanılıyor: %s", peerID[:8])

	// Önce keşfedilen peer'ları kontrol et
	discoveredPeers := uc.transportProvider.GetDiscoveredPeers()
	var targetPeer *transport.DiscoveredPeer

	for _, peer := range discoveredPeers {
		if peer.DeviceID == peerID {
			targetPeer = peer
			break
		}
	}

	if targetPeer == nil {
		// Veritabanından peer bilgisi al
		dbPeer, err := uc.peerRepo.GetByID(ctx, peerID)
		if err != nil {
			log.Printf("❌ Peer bulunamadı: %v", err)
			return fmt.Errorf("peer bulunamadı: %w", err)
		}

		// DiscoveredPeer'a dönüştür
		targetPeer = &transport.DiscoveredPeer{
			DeviceID:      dbPeer.DeviceID,
			DeviceName:    dbPeer.Name,
			Addresses:     dbPeer.KnownAddresses,
			TransportType: transport.TransportTypeLAN,
		}
	}

	log.Printf("🌐 Peer adresi: %v (device: %s)", targetPeer.Addresses, targetPeer.DeviceName)

	// Bağlantı kur
	conn, err := uc.transportProvider.Connect(ctx, targetPeer)
	if err != nil {
		log.Printf("❌ Bağlantı hatası: %v (peer: %s, adres: %v)", err, peerID[:8], targetPeer.Addresses)
		return fmt.Errorf("bağlantı kurulamadı: %w", err)
	}

	// Peer'ı veritabanına kaydet (yoksa)
	existingPeer, err := uc.peerRepo.GetByID(ctx, peerID)
	if err != nil || existingPeer == nil {
		// Yeni peer oluştur
		newPeer := entity.NewPeer(targetPeer.DeviceID, targetPeer.DeviceName)
		newPeer.Status = entity.PeerStatusOnline

		if err := uc.peerRepo.Create(ctx, newPeer); err != nil {
			log.Printf("⚠️ Peer veritabanına kaydedilemedi: %v", err)
		}
	} else {
		// Mevcut peer'ı güncelle
		if err := uc.peerRepo.UpdateStatus(ctx, existingPeer.DeviceID, entity.PeerStatusOnline); err != nil {
			log.Printf("⚠️ Peer durumu güncellenemedi: %v", err)
		}

		if err := uc.peerRepo.UpdateLastSeen(ctx, existingPeer.DeviceID); err != nil {
			log.Printf("⚠️ Peer last seen güncellenemedi: %v", err)
		}
	}

	log.Printf("✅ Peer'a bağlanıldı: %s (%s)", targetPeer.DeviceName, conn.GetAddress())

	return nil
}

// DisconnectFromPeer peer bağlantısını keser
func (uc *PeerDiscoveryUseCaseImpl) DisconnectFromPeer(ctx context.Context, peerID string) error {
	log.Printf("🔌 Peer bağlantısı kesiliyor: %s", peerID[:8])

	if err := uc.transportProvider.Disconnect(peerID); err != nil {
		return fmt.Errorf("bağlantı kesilemedi: %w", err)
	}

	// Peer durumunu güncelle
	if err := uc.peerRepo.UpdateStatus(ctx, peerID, entity.PeerStatusOffline); err != nil {
		log.Printf("⚠️ Peer durumu güncellenemedi: %v", err)
	}

	log.Printf("✅ Peer bağlantısı kesildi: %s", peerID[:8])

	return nil
}

// GetConnectedPeers bağlı peer'ları döner
func (uc *PeerDiscoveryUseCaseImpl) GetConnectedPeers(ctx context.Context) ([]*entity.Peer, error) {
	connections := uc.transportProvider.GetAllConnections()

	peers := make([]*entity.Peer, 0, len(connections))
	for _, conn := range connections {
		if !conn.IsConnected() {
			continue
		}

		peer, err := uc.peerRepo.GetByID(ctx, conn.GetPeerID())
		if err != nil {
			log.Printf("⚠️ Peer bilgisi alınamadı: %v", err)
			continue
		}

		peers = append(peers, peer)
	}

	log.Printf("📊 Bağlı peer sayısı: %d", len(peers))

	return peers, nil
}

// TrustPeer peer'ı güvenilir yapar
func (uc *PeerDiscoveryUseCaseImpl) TrustPeer(ctx context.Context, peerID string) error {
	log.Printf("✅ Peer güvenilir yapılıyor: %s", peerID[:8])

	peer, err := uc.peerRepo.GetByID(ctx, peerID)
	if err != nil {
		return fmt.Errorf("peer bulunamadı: %w", err)
	}
	peer.IsTrusted = true
	if err := uc.peerRepo.Update(ctx, peer); err != nil {
		return fmt.Errorf("peer güvenilir yapılamadı: %w", err)
	}

	log.Printf("✅ Peer güvenilir yapıldı: %s", peerID[:8])

	return nil
}

// UntrustPeer peer'ı güvenilmez yapar
func (uc *PeerDiscoveryUseCaseImpl) UntrustPeer(ctx context.Context, peerID string) error {
	log.Printf("⚠️ Peer güvenilmez yapılıyor: %s", peerID[:8])

	peer, err := uc.peerRepo.GetByID(ctx, peerID)
	if err != nil {
		return fmt.Errorf("peer bulunamadı: %w", err)
	}
	peer.IsTrusted = false
	if err := uc.peerRepo.Update(ctx, peer); err != nil {
		return fmt.Errorf("peer güvenilmez yapılamadı: %w", err)
	}

	log.Printf("✅ Peer güvenilmez yapıldı: %s", peerID[:8])

	return nil
}

// RemovePeer peer'ı kaldırır
func (uc *PeerDiscoveryUseCaseImpl) RemovePeer(ctx context.Context, peerID string) error {
	log.Printf("🗑️ Peer kaldırılıyor: %s", peerID[:8])

	// Önce bağlantıyı kes
	uc.transportProvider.Disconnect(peerID)

	// Veritabanından sil
	if err := uc.peerRepo.Delete(ctx, peerID); err != nil {
		return fmt.Errorf("peer silinemedi: %w", err)
	}

	log.Printf("✅ Peer kaldırıldı: %s", peerID[:8])

	return nil
}

// GetPeerInfo peer bilgilerini döner
func (uc *PeerDiscoveryUseCaseImpl) GetPeerInfo(ctx context.Context, peerID string) (*entity.Peer, error) {
	peer, err := uc.peerRepo.GetByID(ctx, peerID)
	if err != nil {
		return nil, fmt.Errorf("peer bulunamadı: %w", err)
	}

	return peer, nil
}

// IsPeerConnected peer'in bağlı olup olmadığını kontrol eder
func (uc *PeerDiscoveryUseCaseImpl) IsPeerConnected(ctx context.Context, peerID string) (bool, error) {
	conn, exists := uc.transportProvider.GetConnection(peerID)
	if !exists {
		return false, nil
	}

	return conn.IsConnected(), nil
}

// GetTransportInfo transport bilgilerini döner
func (uc *PeerDiscoveryUseCaseImpl) GetTransportInfo(ctx context.Context) (transport.TransportType, int, string) {
	return uc.transportProvider.GetTransportType(),
		uc.transportProvider.GetListenPort(),
		uc.transportProvider.GetDeviceID()
}
