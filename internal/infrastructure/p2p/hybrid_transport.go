package p2p

import (
	"context"
	"fmt"
	"log"

	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"
	"github.com/aether/sync/internal/infrastructure/p2p/wan"
)

// HybridTransportProvider aynı anda hem LAN hem WAN transport'u yönetir.
// Transport interface'ini implement ederek üst katmanların tek provider
// üzerinden iki taşıyıcıyı da kullanmasına izin verir.
type HybridTransportProvider struct {
	lan *lan.LANTransport
	wan *wan.WANTransport
}

// NewHybridTransportProvider yeni bir hybrid provider oluşturur.
func NewHybridTransportProvider(lanTransport *lan.LANTransport, wanTransport *wan.WANTransport) *HybridTransportProvider {
	return &HybridTransportProvider{
		lan: lanTransport,
		wan: wanTransport,
	}
}

func (h *HybridTransportProvider) Start(ctx context.Context) error {
	if h.lan != nil {
		if err := h.lan.Start(ctx); err != nil {
			return fmt.Errorf("LAN transport başlatılamadı: %w", err)
		}
	}
	if h.wan != nil {
		if err := h.wan.Start(ctx); err != nil {
			return fmt.Errorf("WAN transport başlatılamadı: %w", err)
		}
	}
	return nil
}

func (h *HybridTransportProvider) Stop() error {
	var firstErr error
	if h.lan != nil {
		if err := h.lan.Stop(); err != nil && firstErr == nil {
			firstErr = err
		}
	}
	if h.wan != nil {
		if err := h.wan.Stop(); err != nil && firstErr == nil {
			firstErr = err
		}
	}
	return firstErr
}

func (h *HybridTransportProvider) StartDiscovery(ctx context.Context) error {
	if h.lan != nil {
		if err := h.lan.StartDiscovery(ctx); err != nil {
			return err
		}
	}
	if h.wan != nil {
		if err := h.wan.StartDiscovery(ctx); err != nil {
			return err
		}
	}
	return nil
}

func (h *HybridTransportProvider) StopDiscovery() error {
	if h.lan != nil {
		if err := h.lan.StopDiscovery(); err != nil {
			return err
		}
	}
	if h.wan != nil {
		if err := h.wan.StopDiscovery(); err != nil {
			return err
		}
	}
	return nil
}

func (h *HybridTransportProvider) GetDiscoveredPeers() []*transport.DiscoveredPeer {
	peers := make([]*transport.DiscoveredPeer, 0)
	lanCount := 0
	wanCount := 0

	if h.lan != nil {
		lanPeers := h.lan.GetDiscoveredPeers()
		lanCount = len(lanPeers)
		peers = append(peers, lanPeers...)
	}
	if h.wan != nil {
		wanPeers := h.wan.GetDiscoveredPeers()
		wanCount = len(wanPeers)
		peers = append(peers, wanPeers...)
	}

	if len(peers) > 0 {
		log.Printf("🔗 HybridTransportProvider: LAN'dan %d, WAN'dan %d peer (toplam: %d)", lanCount, wanCount, len(peers))
	}

	return peers
}

func (h *HybridTransportProvider) Connect(ctx context.Context, peer *transport.DiscoveredPeer) (transport.Connection, error) {
	transportTypeStr := "UNKNOWN"
	if peer.TransportType == transport.TransportTypeWAN {
		transportTypeStr = "WAN"
	} else if peer.TransportType == transport.TransportTypeLAN {
		transportTypeStr = "LAN"
	}
	log.Printf("🔌 HybridTransportProvider.Connect çağrıldı - Peer: %s (%s), Transport: %s",
		peer.DeviceName, peer.DeviceID[:8], transportTypeStr)

	switch peer.TransportType {
	case transport.TransportTypeWAN:
		if h.wan == nil {
			return nil, fmt.Errorf("WAN transport aktif değil")
		}
		log.Printf("🌐 WAN transport üzerinden bağlantı kuruluyor: %s", peer.DeviceID[:8])
		return h.wan.Connect(ctx, peer)
	case transport.TransportTypeLAN:
		if h.lan == nil {
			return nil, fmt.Errorf("LAN transport aktif değil")
		}
		log.Printf("🏠 LAN transport üzerinden bağlantı kuruluyor: %s", peer.DeviceID[:8])
		return h.lan.Connect(ctx, peer)
	default:
		// Transport tipi bilinmiyorsa sırasıyla LAN sonra WAN dene
		if h.lan != nil {
			if conn, err := h.lan.Connect(ctx, peer); err == nil {
				return conn, nil
			}
		}
		if h.wan != nil {
			return h.wan.Connect(ctx, peer)
		}
		return nil, fmt.Errorf("hiçbir transport aktif değil")
	}
}

func (h *HybridTransportProvider) Disconnect(peerID string) error {
	if h.lan != nil {
		if _, exists := h.lan.GetConnection(peerID); exists {
			return h.lan.Disconnect(peerID)
		}
	}
	if h.wan != nil {
		if _, exists := h.wan.GetConnection(peerID); exists {
			return h.wan.Disconnect(peerID)
		}
	}
	return fmt.Errorf("peer bağlantısı bulunamadı: %s", peerID)
}

func (h *HybridTransportProvider) GetConnection(peerID string) (transport.Connection, bool) {
	if h.lan != nil {
		if conn, ok := h.lan.GetConnection(peerID); ok {
			return conn, true
		}
	}
	if h.wan != nil {
		return h.wan.GetConnection(peerID)
	}
	return nil, false
}

func (h *HybridTransportProvider) GetAllConnections() []transport.Connection {
	conns := make([]transport.Connection, 0)
	if h.lan != nil {
		conns = append(conns, h.lan.GetAllConnections()...)
	}
	if h.wan != nil {
		conns = append(conns, h.wan.GetAllConnections()...)
	}
	return conns
}

func (h *HybridTransportProvider) GetTransportType() transport.TransportType {
	if h.wan != nil {
		return transport.TransportTypeWAN
	}
	return transport.TransportTypeLAN
}

func (h *HybridTransportProvider) GetListenPort() int {
	if h.lan != nil {
		return h.lan.GetListenPort()
	}
	if h.wan != nil {
		return h.wan.GetListenPort()
	}
	return 0
}

func (h *HybridTransportProvider) GetDeviceID() string {
	if h.lan != nil {
		return h.lan.GetDeviceID()
	}
	if h.wan != nil {
		return h.wan.GetDeviceID()
	}
	return ""
}

func (h *HybridTransportProvider) GetDeviceName() string {
	if h.lan != nil {
		return h.lan.GetDeviceName()
	}
	if h.wan != nil {
		return h.wan.GetDeviceName()
	}
	return ""
}

func (h *HybridTransportProvider) OnPeerDiscovered(callback func(*transport.DiscoveredPeer)) {
	if h.lan != nil {
		h.lan.OnPeerDiscovered(func(peer *transport.DiscoveredPeer) {
			if callback != nil {
				callback(peer)
			}
		})
	}
	if h.wan != nil {
		h.wan.OnPeerDiscovered(func(peer *transport.DiscoveredPeer) {
			if callback != nil {
				callback(peer)
			}
		})
	}
}

func (h *HybridTransportProvider) OnPeerLost(callback func(string)) {
	if h.lan != nil {
		h.lan.OnPeerLost(func(peerID string) {
			if callback != nil {
				callback(peerID)
			}
		})
	}
	if h.wan != nil {
		h.wan.OnPeerLost(func(peerID string) {
			if callback != nil {
				callback(peerID)
			}
		})
	}
}

func (h *HybridTransportProvider) OnConnectionEstablished(callback func(transport.Connection)) {
	if h.lan != nil {
		h.lan.OnConnectionEstablished(func(conn transport.Connection) {
			if callback != nil {
				callback(conn)
			}
		})
	}
	if h.wan != nil {
		h.wan.OnConnectionEstablished(func(conn transport.Connection) {
			if callback != nil {
				callback(conn)
			}
		})
	}
}

func (h *HybridTransportProvider) OnConnectionLost(callback func(string)) {
	if h.lan != nil {
		h.lan.OnConnectionLost(func(peerID string) {
			if callback != nil {
				callback(peerID)
			}
		})
	}
	if h.wan != nil {
		h.wan.OnConnectionLost(func(peerID string) {
			if callback != nil {
				callback(peerID)
			}
		})
	}
}

func (h *HybridTransportProvider) SetOnPeerIDUpdated(callback func(oldID, newID, newName string)) {
	if h.wan != nil {
		h.wan.SetOnPeerIDUpdated(callback)
	}
}
