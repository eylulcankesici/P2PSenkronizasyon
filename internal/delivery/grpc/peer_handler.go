package grpc

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"

	"github.com/pion/webrtc/v3"
	"google.golang.org/protobuf/types/known/timestamppb"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"

	"github.com/aether/sync/internal/infrastructure/p2p/wan"
)

type PeerHandler struct {
	pb.UnimplementedPeerServiceServer
	container *container.Container
}

// NewPeerHandler yeni PeerHandler oluşturur
func NewPeerHandler(cont *container.Container) *PeerHandler {
	return &PeerHandler{container: cont}
}

// DiscoverPeers peer'ları keşfeder (keşfedilen tüm peer'ları döndürür)
func (h *PeerHandler) DiscoverPeers(ctx context.Context, req *pb.DiscoverPeersRequest) (*pb.DiscoverPeersResponse, error) {
	// Sadece keşfedilen peer'ları döndür (henüz bağlanmamış olanlar)
	discoveredPeers, _ := h.container.PeerDiscoveryUseCase().GetDiscoveredPeers(ctx)
	
	pbPeers := make([]*pb.Peer, 0, len(discoveredPeers))
	lanOnly := req.GetLanOnly()
	wanOnly := req.GetWanOnly()

	log.Printf("🔍 DiscoverPeers çağrıldı - lanOnly: %v, wanOnly: %v, toplam keşfedilen: %d", lanOnly, wanOnly, len(discoveredPeers))
	
	for _, discoveredPeer := range discoveredPeers {
		transportTypeStr := "UNKNOWN"
		if discoveredPeer.TransportType == transport.TransportTypeLAN {
			transportTypeStr = "LAN"
		} else if discoveredPeer.TransportType == transport.TransportTypeWAN {
			transportTypeStr = "WAN"
		}
		
		log.Printf("  📡 Peer bulundu: %s (%s) - Transport: %s, Adresler: %v", 
			discoveredPeer.DeviceName, discoveredPeer.DeviceID[:8], transportTypeStr, discoveredPeer.Addresses)

		if lanOnly && discoveredPeer.TransportType != transport.TransportTypeLAN {
			log.Printf("    ⏭️ LAN filtresi nedeniyle atlandı")
			continue
		}
		if wanOnly && discoveredPeer.TransportType != transport.TransportTypeWAN {
			log.Printf("    ⏭️ WAN filtresi nedeniyle atlandı")
			continue
		}

		pbPeer := &pb.Peer{
			DeviceId:       discoveredPeer.DeviceID,
			Name:           discoveredPeer.DeviceName,
			Status:         pb.PeerStatus_PEER_STATUS_UNKNOWN,
			IsTrusted:      false,
			KnownAddresses: discoveredPeer.Addresses,
			WanSupported:   discoveredPeer.TransportType == transport.TransportTypeWAN,
		}
		pbPeers = append(pbPeers, pbPeer)
		log.Printf("    ✅ Peer eklendi: %s", discoveredPeer.DeviceName)
	}

	log.Printf("📤 DiscoverPeers yanıtı: %d peer döndürülüyor", len(pbPeers))
	
	return &pb.DiscoverPeersResponse{
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("%d peer keşfedildi", len(pbPeers)),
			Code:    200,
		},
		Peers: pbPeers,
	}, nil
}

// ConnectToPeer peer'a bağlanır
func (h *PeerHandler) ConnectToPeer(ctx context.Context, req *pb.ConnectToPeerRequest) (*pb.Status, error) {
	err := h.container.PeerDiscoveryUseCase().ConnectToPeer(ctx, req.PeerId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Bağlantı kurulamadı: %v", err),
			Code:    500,
		}, nil
	}
	
	return &pb.Status{
		Success: true,
		Message: "Bağlantı başarıyla kuruldu",
		Code:    200,
	}, nil
}

// DisconnectFromPeer peer bağlantısını keser
func (h *PeerHandler) DisconnectFromPeer(ctx context.Context, req *pb.DisconnectFromPeerRequest) (*pb.Status, error) {
	err := h.container.PeerDiscoveryUseCase().DisconnectFromPeer(ctx, req.PeerId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Bağlantı kesilemedi: %v", err),
			Code:    500,
		}, nil
	}
	
	return &pb.Status{
		Success: true,
		Message: "Bağlantı başarıyla kesildi",
		Code:    200,
	}, nil
}

// ListPeers peer'ları listeler (sadece BAĞLI olan peer'lar)
func (h *PeerHandler) ListPeers(ctx context.Context, req *pb.ListPeersRequest) (*pb.ListPeersResponse, error) {
	// Bağlı peer'ları almak için transport provider'dan bağlantıları kontrol et
	transportProvider := h.container.TransportProvider()
	connections := transportProvider.GetAllConnections()
	
	pbPeers := make([]*pb.Peer, 0)
	
	// Sadece bağlı olan peer'ları ekle
	for _, conn := range connections {
		if !conn.IsConnected() {
			continue
		}
		
		// Peer bilgilerini veritabanından al
		peer, err := h.container.PeerRepository().GetByID(ctx, conn.GetPeerID())
		if err != nil {
			// Veritabanında yoksa atla
			continue
		}
		
		pbPeer := &pb.Peer{
			DeviceId:       peer.DeviceID,
			Name:           peer.Name,
			Status:         pb.PeerStatus_PEER_STATUS_ONLINE, // Bağlı olduğu için online
			IsTrusted:      peer.IsTrusted,
			KnownAddresses: peer.KnownAddresses,
		}
		
		// last_seen timestamp
		if !peer.LastSeen.IsZero() {
			pbPeer.LastSeen = timestamppb.New(peer.LastSeen)
		}
		
		pbPeers = append(pbPeers, pbPeer)
	}
	
	return &pb.ListPeersResponse{
		Peers: pbPeers,
		Pagination: &pb.PaginationResponse{
			TotalCount: int32(len(pbPeers)),
		},
	}, nil
}

// GetPeerInfo peer detay bilgisi getirir (placeholder)
func (h *PeerHandler) GetPeerInfo(ctx context.Context, req *pb.GetPeerInfoRequest) (*pb.PeerInfoResponse, error) {
	return &pb.PeerInfoResponse{
		Status: &pb.Status{
			Success: true,
			Message: "PeerHandler - yakında implement edilecek",
			Code:    501,
		},
	}, nil
}

// TrustPeer peer'i güvenilir yapar
func (h *PeerHandler) TrustPeer(ctx context.Context, req *pb.TrustPeerRequest) (*pb.Status, error) {
	peer, err := h.container.PeerRepository().GetByID(ctx, req.PeerId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Peer bulunamadı: %v", err),
			Code:    404,
		}, nil
	}
	
	peer.IsTrusted = true
	if err := h.container.PeerRepository().Update(ctx, peer); err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Peer güncellenemedi: %v", err),
			Code:    500,
		}, nil
	}
	
	return &pb.Status{
		Success: true,
		Message: "Peer güvenilir olarak işaretlendi",
		Code:    200,
	}, nil
}

// UntrustPeer peer'i güvenilmez yapar
func (h *PeerHandler) UntrustPeer(ctx context.Context, req *pb.UntrustPeerRequest) (*pb.Status, error) {
	peer, err := h.container.PeerRepository().GetByID(ctx, req.PeerId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Peer bulunamadı: %v", err),
			Code:    404,
		}, nil
	}
	
	peer.IsTrusted = false
	if err := h.container.PeerRepository().Update(ctx, peer); err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Peer güncellenemedi: %v", err),
			Code:    500,
		}, nil
	}
	
	return &pb.Status{
		Success: true,
		Message: "Peer güvenilmez olarak işaretlendi",
		Code:    200,
	}, nil
}

// RemovePeer peer'ı kaldırır (placeholder)
func (h *PeerHandler) RemovePeer(ctx context.Context, req *pb.RemovePeerRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "PeerHandler - yakında implement edilecek",
		Code:    501,
	}, nil
}

// GetPendingConnections bekleyen bağlantı isteklerini döner (LAN ve WAN)
func (h *PeerHandler) GetPendingConnections(ctx context.Context, req *pb.GetPendingConnectionsRequest) (*pb.GetPendingConnectionsResponse, error) {
	pbPendingConns := make([]*pb.PendingConnection, 0)
	
	// LAN transport'tan pending connections al
	lanTransport := h.container.LANTransport()
	if lanTransport != nil {
		connMgr := lanTransport.GetTCPConnectionManager()
		if connMgr != nil {
			lanPendingConns := connMgr.GetPendingConnections()
			for _, pending := range lanPendingConns {
				pbPending := &pb.PendingConnection{
					DeviceId:   pending.DeviceID,
					DeviceName: pending.DeviceName,
					Timestamp:  pending.Timestamp.Unix(),
				}
				pbPendingConns = append(pbPendingConns, pbPending)
			}
		}
	}
	
	// WAN transport'tan pending connections al
	wanTransport := h.container.WANTransport()
	if wanTransport != nil {
		wanPendingConns := wanTransport.GetPendingConnections()
		for _, pending := range wanPendingConns {
			pbPending := &pb.PendingConnection{
				DeviceId:   pending.DeviceID,
				DeviceName: pending.DeviceName,
				Timestamp:  pending.Timestamp.Unix(),
			}
			pbPendingConns = append(pbPendingConns, pbPending)
		}
	}
	
	return &pb.GetPendingConnectionsResponse{
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("%d bekleyen bağlantı", len(pbPendingConns)),
			Code:    200,
		},
		PendingConnections: pbPendingConns,
	}, nil
}

// AcceptConnection bağlantı isteğini onaylar (LAN ve WAN)
func (h *PeerHandler) AcceptConnection(ctx context.Context, req *pb.AcceptConnectionRequest) (*pb.Status, error) {
	// Önce LAN transport'ta dene
	lanTransport := h.container.LANTransport()
	if lanTransport != nil {
		err := AcceptConnectionHelper(lanTransport, req.DeviceId)
		if err == nil {
			return &pb.Status{
				Success: true,
				Message: "Bağlantı başarıyla onaylandı",
				Code:    200,
			}, nil
		}
	}
	
	// WAN transport'ta dene
	wanTransport := h.container.WANTransport()
	if wanTransport != nil {
		connMgr := wanTransport.GetWebRTCConnectionManager()
		if connMgr != nil {
			err := connMgr.AcceptPendingConnection(req.DeviceId)
			if err == nil {
				return &pb.Status{
					Success: true,
					Message: "Bağlantı başarıyla onaylandı",
					Code:    200,
				}, nil
			}
		}
	}
	
	return &pb.Status{
		Success: false,
		Message: fmt.Sprintf("Bağlantı onaylanamadı: peer bulunamadı veya pending connection yok"),
		Code:    404,
	}, nil
}

// RejectConnection bağlantı isteğini reddeder (LAN ve WAN)
func (h *PeerHandler) RejectConnection(ctx context.Context, req *pb.RejectConnectionRequest) (*pb.Status, error) {
	// Önce LAN transport'ta dene
	lanTransport := h.container.LANTransport()
	if lanTransport != nil {
		err := RejectConnectionHelper(lanTransport, req.DeviceId)
		if err == nil {
			return &pb.Status{
				Success: true,
				Message: "Bağlantı başarıyla reddedildi",
				Code:    200,
			}, nil
		}
	}
	
	// WAN transport'ta dene
	wanTransport := h.container.WANTransport()
	if wanTransport != nil {
		connMgr := wanTransport.GetWebRTCConnectionManager()
		if connMgr != nil {
			err := connMgr.RejectPendingConnection(req.DeviceId)
			if err == nil {
				return &pb.Status{
					Success: true,
					Message: "Bağlantı başarıyla reddedildi",
					Code:    200,
				}, nil
			}
		}
	}
	
	return &pb.Status{
		Success: false,
		Message: fmt.Sprintf("Bağlantı reddedilemedi: peer bulunamadı veya pending connection yok"),
		Code:    404,
	}, nil
}

// AcceptConnectionHelper bağlantı isteğini onaylar (internal helper)
func AcceptConnectionHelper(lanTransport *lan.LANTransport, deviceID string) error {
	if lanTransport == nil {
		return fmt.Errorf("LAN transport bulunamadı")
	}
	
	connMgr := lanTransport.GetTCPConnectionManager()
	return connMgr.AcceptConnection(deviceID)
}

// RejectConnectionHelper bağlantı isteğini reddeder (internal helper)
func RejectConnectionHelper(lanTransport *lan.LANTransport, deviceID string) error {
	if lanTransport == nil {
		return fmt.Errorf("LAN transport bulunamadı")
	}
	
	connMgr := lanTransport.GetTCPConnectionManager()
	return connMgr.RejectConnection(deviceID)
}

// GetPendingConnectionsHelper bekleyen bağlantıları döner (internal helper)
func GetPendingConnectionsHelper(lanTransport *lan.LANTransport) ([]interface {
	DeviceID() string
	DeviceName() string
	Timestamp() int64
}, error) {
	if lanTransport == nil {
		return nil, fmt.Errorf("LAN transport bulunamadı")
	}
	
	connMgr := lanTransport.GetTCPConnectionManager()
	pendingConns := connMgr.GetPendingConnections()
	
	// PendingConnection'ları interface'e dönüştür
	result := make([]interface {
		DeviceID() string
		DeviceName() string
		Timestamp() int64
	}, len(pendingConns))
	
	for i, p := range pendingConns {
		result[i] = pendingConnWrapper{p}
	}
	
	return result, nil
}

// pendingConnWrapper pending connection wrapper
type pendingConnWrapper struct {
	pending *lan.PendingConnection
}

func (w pendingConnWrapper) DeviceID() string {
	return w.pending.DeviceID
}

func (w pendingConnWrapper) DeviceName() string {
	return w.pending.DeviceName
}

func (w pendingConnWrapper) Timestamp() int64 {
	return w.pending.Timestamp.Unix()
}

// mapPeerStatus entity.PeerStatus'ü pb.PeerStatus'a çevirir
func mapPeerStatus(status entity.PeerStatus) pb.PeerStatus {
	switch status {
	case entity.PeerStatusOnline:
		return pb.PeerStatus_PEER_STATUS_ONLINE
	case entity.PeerStatusOffline:
		return pb.PeerStatus_PEER_STATUS_OFFLINE
	case entity.PeerStatusUnknown:
		return pb.PeerStatus_PEER_STATUS_UNKNOWN
	default:
		return pb.PeerStatus_PEER_STATUS_UNKNOWN
	}
}

// CreateInvitation invitation code oluşturur (WAN için)
func (h *PeerHandler) CreateInvitation(ctx context.Context, req *pb.CreateInvitationRequest) (*pb.CreateInvitationResponse, error) {
	// WAN transport kontrolü
	wanTransport := h.container.WANTransport()
	if wanTransport == nil {
		return &pb.CreateInvitationResponse{
			Status: &pb.Status{
				Success: false,
				Message: "WAN transport aktif değil",
				Code:    400,
			},
		}, nil
	}




	// 6 haneli Room ID oluştur
	rand.Seed(time.Now().UnixNano())
	roomID := fmt.Sprintf("%06d", rand.Intn(1000000))
	
	log.Printf("🚀 Signaling başlatılıyor (Room: %s)...", roomID)

	// Signaling başlat
	signalingURL := os.Getenv("SIGNALING_URL")
	if signalingURL == "" {
		signalingURL = "ws://localhost:8080/ws"
	}
	signalingClient, err := wanTransport.StartSignaling(signalingURL, roomID)
	if err != nil {
		return &pb.CreateInvitationResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Signaling başlatılamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// WebRTC config oluştur
	cfg := h.container.Config()
	webrtcConfig := wan.CreateWebRTCConfiguration(
		cfg.Network.STUNServers,
		cfg.Network.TURNServers,
		cfg.Network.WebRTCPortRange,
	)
	
	// WebRTC peer oluştur
	webrtcPeer, peerErr := wan.NewWebRTCPeer(webrtcConfig)
	if peerErr != nil {
		return &pb.CreateInvitationResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("WebRTC peer oluşturulamadı: %v", peerErr),
				Code:    500,
			},
		}, nil
	}

	// Data channel oluştur (Offer oluşturan taraf olarak)
	dc, err := webrtcPeer.CreateDataChannel("aether-chunks", true)
	if err != nil {
		log.Printf("❌ Data channel oluşturulamadı: %v", err)
		return &pb.CreateInvitationResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Data channel oluşturulamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// Data Channel açıldığında connection'ı kaydet
	dc.OnOpen(func() {
		log.Printf("✅ Data Channel açıldı (Offerer): %s", dc.Label())
		
		// Geçici olarak roomID'yi device ID olarak kullan
		tempDeviceID := roomID
		
		// WebRTC connection oluştur
		conn := wan.NewWebRTCConnection(tempDeviceID, "Unknown Peer", webrtcPeer, dc)
		
		// Connection manager'a kaydet
		wanTransport.GetWebRTCConnectionManager().RegisterConnection(tempDeviceID, conn)
	})

	// Signaling callback'leri
	signalingClient.OnAnswer = func(sdp string) {
		log.Printf("📩 Answer alındı, set ediliyor...")
		desc := webrtc.SessionDescription{Type: webrtc.SDPTypeAnswer, SDP: sdp}
		if err := webrtcPeer.SetRemoteDescription(desc); err != nil {
			log.Printf("❌ Remote description hatası: %v", err)
		}
	}
	
	signalingClient.OnCandidate = func(candidate string) {
		log.Printf("📩 Candidate alındı, ekleniyor...")
		webrtcPeer.AddICECandidateFromJSON(candidate)
	}

	// Peer katıldığında Offer gönder
	signalingClient.OnReady = func() {
		log.Printf("👤 Peer odaya katıldı, Offer gönderiliyor...")
		
		// Offer oluştur (Async - ICE gathering bekleme)
		offer, offerErr := webrtcPeer.CreateOfferAsync()
		if offerErr != nil {
			log.Printf("❌ Offer oluşturulamadı: %v", offerErr)
			return
		}
		
		// Offer gönder
		if err := signalingClient.SendOffer(offer.SDP); err != nil {
			log.Printf("❌ Offer gönderilemedi: %v", err)
			return
		}
		log.Printf("📤 Offer gönderildi")
	}
	
	// WebRTC callback'leri - Candidate bulunduğunda gönder
	webrtcPeer.SetOnICECandidate(func(c *webrtc.ICECandidate) {
		if c != nil {
			bytes, _ := json.Marshal(c.ToJSON())
			signalingClient.SendCandidate(string(bytes))
		}
	})
	
	// Register pending invitation (Room ID ile)
	wanTransport.GetWebRTCConnectionManager().RegisterInvitation(roomID, webrtcPeer)

	log.Printf("\n\n")
	log.Printf("🔵 🔵 🔵 ROOM ID (Bunu arkadaşına gönder) 🔵 🔵 🔵")
	log.Printf("=== START CODE ===")
	log.Printf("%s", roomID)
	log.Printf("=== END CODE ===")
	log.Printf("\n")
	log.Printf("⏳ Peer bekleniyor...")

	return &pb.CreateInvitationResponse{
		InvitationCode: roomID,
		Status: &pb.Status{
			Success: true,
			Message: "Invitation code oluşturuldu, peer bekleniyor...",
			Code:    200,
		},
	}, nil
}
// AddWANPeer manuel olarak WAN peer ekler (invitation code olmadan)
func (h *PeerHandler) AddWANPeer(ctx context.Context, req *pb.AddWANPeerRequest) (*pb.Status, error) {
	log.Printf("🔵 AddWANPeer FONKSİYONU ÇAĞRILDI - PeerID: %s, PeerName: %s, PublicIP: %s", 
		req.PeerId[:8], req.PeerName, req.PublicIp)
	
	if req.PeerId == "" {
		return &pb.Status{
			Success: false,
			Message: "Peer ID boş olamaz",
			Code:    400,
		}, nil
	}

	// WAN transport kontrolü
	wanTransport := h.container.WANTransport()
	if wanTransport == nil {
		return &pb.Status{
			Success: false,
			Message: "WAN transport aktif değil",
			Code:    400,
		}, nil
	}

	// Discovery service al
	discoveryService := wanTransport.GetDiscoveryService()
	if discoveryService == nil {
		return &pb.Status{
			Success: false,
			Message: "Discovery service bulunamadı",
			Code:    500,
		}, nil
	}

	// Peer name (eğer yoksa peer ID'nin ilk kısmını kullan)
	peerName := req.PeerName
	if peerName == "" {
		peerName = req.PeerId[:8] + "..."
	}

	// Peer'ı ekle
	err := discoveryService.AddPeer(
		req.PeerId,
		peerName,
		req.PublicIp,
		[]wan.ICECandidate{}, // Boş ICE candidates
	)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Peer eklenemedi: %v", err),
			Code:    500,
		}, nil
	}

	log.Printf("✅ WAN peer manuel olarak eklendi: %s (%s)", peerName, req.PeerId[:8])

	return &pb.Status{
		Success: true,
		Message: fmt.Sprintf("Peer başarıyla eklendi: %s", peerName),
		Code:    200,
	}, nil
}

// ExchangeSDP SDP offer/answer exchange yapar (WAN WebRTC için)
func (h *PeerHandler) ExchangeSDP(ctx context.Context, req *pb.ExchangeSDPRequest) (*pb.ExchangeSDPResponse, error) {
	log.Printf("📥 ExchangeSDP çağrıldı - PeerID: %s, SDPType: %s, SDP uzunluk: %d", 
		req.PeerId[:8], req.SdpType, len(req.Sdp))
	
	if req.PeerId == "" {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: "Peer ID boş olamaz",
				Code:    400,
			},
		}, nil
	}

	if req.SdpType == "" || req.Sdp == "" {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: "SDP type veya SDP boş olamaz",
				Code:    400,
			},
		}, nil
	}

	// WAN transport kontrolü
	wanTransport := h.container.WANTransport()
	if wanTransport == nil {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: "WAN transport aktif değil",
				Code:    400,
			},
		}, nil
	}

	// Device ID doğrulama
	deviceID, err := h.container.GetDeviceID()
	if err != nil {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Device ID alınamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// Kendi device ID'si ile eşleşirse hata
	if req.PeerId == deviceID {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: "Kendi peer ID'nizi kullanamazsınız",
				Code:    400,
			},
		}, nil
	}

	// WebRTC connection manager al
	connMgr := wanTransport.GetWebRTCConnectionManager()
	if connMgr == nil {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: "Connection manager bulunamadı",
				Code:    500,
			},
		}, nil
	}

	log.Printf("📋 SDP exchange isteği: peer=%s, type=%s", req.PeerId[:8], req.SdpType)

	// Peer connection'ı bul veya oluştur
	discoveredPeers := wanTransport.GetDiscoveredPeers()
	var targetPeer *transport.DiscoveredPeer
	for _, peer := range discoveredPeers {
		if peer.DeviceID == req.PeerId {
			targetPeer = peer
			break
		}
	}

	if targetPeer == nil {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Peer bulunamadı: %s", req.PeerId[:8]),
				Code:    404,
			},
		}, nil
	}

	// Connection'ı al veya oluştur
	conn, exists := connMgr.GetConnection(req.PeerId)
	if !exists {
		// Connection yok, oluştur
		conn, err = connMgr.Connect(ctx, targetPeer)
		if err != nil {
			return &pb.ExchangeSDPResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Connection oluşturulamadı: %v", err),
					Code:    500,
				},
			}, nil
		}
	}

	// WebRTC connection'ı al
	webrtcConn, ok := conn.(*wan.WebRTCConnection)
	if !ok {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: "Connection WebRTC connection değil",
				Code:    500,
			},
		}, nil
	}

	// WebRTC peer al
	webrtcPeer := webrtcConn.GetWebRTCPeer()
	if webrtcPeer == nil {
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: false,
				Message: "WebRTC peer bulunamadı",
				Code:    500,
			},
		}, nil
	}

	// SDP type'a göre işle
	if req.SdpType == "offer" {
		// Incoming offer - pending connection oluştur
		deviceName := targetPeer.DeviceName
		if deviceName == "" {
			deviceName = req.PeerId[:8] + "..."
		}
		
		// Pending connection oluştur (UI'a bildir)
		connMgr.AddPendingConnection(req.PeerId, deviceName, req.Sdp)
		log.Printf("🔔 WAN bağlantı isteği oluşturuldu: %s (%s)", deviceName, req.PeerId[:8])
		
		// Hemen answer döndürme, pending connection olarak işaretle
		sdpDesc := webrtc.SessionDescription{
			Type: webrtc.SDPTypeOffer,
			SDP:  req.Sdp,
		}

		if err := webrtcPeer.SetRemoteDescription(sdpDesc); err != nil {
			return &pb.ExchangeSDPResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Remote description set edilemedi: %v", err),
					Code:    500,
				},
			}, nil
		}

		// Answer oluştur
		answer, err := webrtcPeer.CreateAnswer(ctx)
		if err != nil {
			return &pb.ExchangeSDPResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Answer oluşturulamadı: %v", err),
					Code:    500,
				},
			}, nil
		}

		log.Printf("✅ SDP answer oluşturuldu: peer=%s", req.PeerId[:8])

		// Answer SDP string'ini direkt kullan
		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: true,
				Message: "SDP answer oluşturuldu",
				Code:    200,
			},
			SdpType: "answer",
			Sdp:     answer.SDP, // SDP string direkt kullanılır
		}, nil

	} else if req.SdpType == "answer" {
		// Remote answer alındı, set et
		sdpDesc := webrtc.SessionDescription{
			Type: webrtc.SDPTypeAnswer,
			SDP:  req.Sdp,
		}

		if err := webrtcPeer.SetRemoteDescription(sdpDesc); err != nil {
			return &pb.ExchangeSDPResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Remote description set edilemedi: %v", err),
					Code:    500,
				},
			}, nil
		}

		log.Printf("✅ SDP answer alındı ve set edildi: peer=%s", req.PeerId[:8])

		return &pb.ExchangeSDPResponse{
			Status: &pb.Status{
				Success: true,
				Message: "SDP answer alındı",
				Code:    200,
			},
			SdpType: "answer",
			Sdp:     "", // Answer alındı, cevap gerekmez
		}, nil
	}

	return &pb.ExchangeSDPResponse{
		Status: &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Geçersiz SDP type: %s", req.SdpType),
			Code:    400,
		},
	}, nil
}

// AddPeerByInvitation davet kodu ile peer ekler (WAN için)
func (h *PeerHandler) AddPeerByInvitation(ctx context.Context, req *pb.AddPeerByInvitationRequest) (*pb.Status, error) {
	invitationCode := req.InvitationCode
	if invitationCode == "" {
		return &pb.Status{
			Success: false,
			Message: "Davet kodu boş olamaz",
			Code:    400,
		}, nil
	}

	log.Printf("🚀 Davet kodu ile bağlanılıyor: %s", invitationCode)

	// WAN transport kontrolü
	wanTransport := h.container.WANTransport()
	if wanTransport == nil {
		return &pb.Status{
			Success: false,
			Message: "WAN transport aktif değil",
			Code:    400,
		}, nil
	}

	// Signaling başlat (Joiner olarak)
	signalingURL := os.Getenv("SIGNALING_URL")
	if signalingURL == "" {
		signalingURL = "ws://localhost:8080/ws"
	}
	
	// Signaling client başlat ve odaya katıl
	signalingClient, err := wanTransport.StartSignaling(signalingURL, invitationCode)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Signaling başlatılamadı: %v", err),
			Code:    500,
		}, nil
	}

	// WebRTC config oluştur
	cfg := h.container.Config()
	webrtcConfig := wan.CreateWebRTCConfiguration(
		cfg.Network.STUNServers,
		cfg.Network.TURNServers,
		cfg.Network.WebRTCPortRange,
	)
	
	// WebRTC peer oluştur
	webrtcPeer, peerErr := wan.NewWebRTCPeer(webrtcConfig)
	if peerErr != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("WebRTC peer oluşturulamadı: %v", peerErr),
			Code:    500,
		}, nil
	}

	// Signaling callback'leri
	signalingClient.OnOffer = func(sdp string) {
		log.Printf("📩 Offer alındı, answer oluşturuluyor...")
		
		// Remote description set et
		desc := webrtc.SessionDescription{Type: webrtc.SDPTypeOffer, SDP: sdp}
		if err := webrtcPeer.SetRemoteDescription(desc); err != nil {
			log.Printf("❌ Remote description hatası: %v", err)
			return
		}
		
		// Answer oluştur
		answer, err := webrtcPeer.CreateAnswer(ctx)
		if err != nil {
			log.Printf("❌ Answer oluşturma hatası: %v", err)
			return
		}
		
		// Answer gönder
		if err := signalingClient.SendAnswer(answer.SDP); err != nil {
			log.Printf("❌ Answer gönderme hatası: %v", err)
			return
		}
		log.Printf("📤 Answer gönderildi")
	}
	
	signalingClient.OnCandidate = func(candidate string) {
		log.Printf("📩 Candidate alındı, ekleniyor...")
		webrtcPeer.AddICECandidateFromJSON(candidate)
	}
	
	// WebRTC callback'leri - Candidate bulunduğunda gönder
	webrtcPeer.SetOnICECandidate(func(c *webrtc.ICECandidate) {
		if c != nil {
			bytes, _ := json.Marshal(c.ToJSON())
			signalingClient.SendCandidate(string(bytes))
		}
	})
	
	// Data Channel handler (Joiner tarafı için)
	webrtcPeer.SetOnDataChannel(func(dc *webrtc.DataChannel) {
		log.Printf("✅ Data Channel açıldı (Joiner): %s", dc.Label())
		
		// Geçici olarak invitation code'u device ID olarak kullan
		// Handshake sırasında gerçek ID ile güncellenecek
		tempDeviceID := invitationCode
		
		// WebRTC connection oluştur
		conn := wan.NewWebRTCConnection(tempDeviceID, "Unknown Peer", webrtcPeer, dc)
		
		// Connection manager'a kaydet
		wanTransport.GetWebRTCConnectionManager().RegisterConnection(tempDeviceID, conn)
		
		// Handshake başlat (Joiner olarak biz de kimliğimizi gönderelim)
		go func() {
			// Biraz bekle ki karşı taraf hazır olsun
			time.Sleep(500 * time.Millisecond)
			
			deviceID, err := h.container.GetDeviceID()
			if err != nil {
				log.Printf("❌ Device ID alınamadı: %v", err)
				return
			}
			
			deviceName := h.container.GetDeviceName()

			reqData, err := conn.GetProtocol().EncodeConnectionRequest(
				deviceID,
				deviceName,
			)
			if err == nil {
				if err := dc.Send(reqData); err != nil {
					log.Printf("❌ Handshake request gönderilemedi: %v", err)
				} else {
					log.Printf("📤 Handshake request gönderildi (Joiner)")
				}
			}
		}()
	})
	
	// Invitation'ı kaydet (Referans tutmak için)
	wanTransport.GetWebRTCConnectionManager().RegisterInvitation(invitationCode, webrtcPeer)

	// Ready mesajı gönder (Sender'a "ben geldim" de)
	if err := signalingClient.SendReady(); err != nil {
		log.Printf("⚠️ Ready mesajı gönderilemedi: %v", err)
	} else {
		log.Printf("📤 Ready mesajı gönderildi")
	}

	return &pb.Status{
		Success: true,
		Message: "Davet koduna bağlanılıyor...",
		Code:    200,
	}, nil
}
