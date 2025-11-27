package grpc

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/pion/webrtc/v3"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"
	"github.com/aether/sync/internal/infrastructure/p2p/wan"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// PeerHandler PeerService implementasyonu
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
	
	for _, discoveredPeer := range discoveredPeers {
		pbPeer := &pb.Peer{
			DeviceId:       discoveredPeer.DeviceID,
			Name:           discoveredPeer.DeviceName,
			Status:         pb.PeerStatus_PEER_STATUS_UNKNOWN,
			IsTrusted:      false,
			KnownAddresses: discoveredPeer.Addresses,
		}
		pbPeers = append(pbPeers, pbPeer)
	}
	
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

// GetPendingConnections bekleyen bağlantı isteklerini döner
func (h *PeerHandler) GetPendingConnections(ctx context.Context, req *pb.GetPendingConnectionsRequest) (*pb.GetPendingConnectionsResponse, error) {
	transportProvider := h.container.TransportProvider()
	lanTransport, ok := transportProvider.(*lan.LANTransport)
	if !ok {
		return &pb.GetPendingConnectionsResponse{
			Status: &pb.Status{
				Success: false,
				Message: "LAN transport bulunamadı",
				Code:    500,
			},
			PendingConnections: []*pb.PendingConnection{},
		}, nil
	}
	
	connMgr := lanTransport.GetTCPConnectionManager()
	pendingConns := connMgr.GetPendingConnections()
	
	// Pending connections'ı proto mesajlarına çevir
	pbPendingConns := make([]*pb.PendingConnection, 0, len(pendingConns))
	for _, pending := range pendingConns {
		pbPending := &pb.PendingConnection{
			DeviceId:   pending.DeviceID,
			DeviceName: pending.DeviceName,
			Timestamp:  pending.Timestamp.Unix(),
		}
		pbPendingConns = append(pbPendingConns, pbPending)
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

// AcceptConnection bağlantı isteğini onaylar
func (h *PeerHandler) AcceptConnection(ctx context.Context, req *pb.AcceptConnectionRequest) (*pb.Status, error) {
	transportProvider := h.container.TransportProvider()
	err := AcceptConnectionHelper(transportProvider, req.DeviceId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Bağlantı onaylanamadı: %v", err),
			Code:    500,
		}, nil
	}
	
	return &pb.Status{
		Success: true,
		Message: "Bağlantı başarıyla onaylandı",
		Code:    200,
	}, nil
}

// RejectConnection bağlantı isteğini reddeder
func (h *PeerHandler) RejectConnection(ctx context.Context, req *pb.RejectConnectionRequest) (*pb.Status, error) {
	transportProvider := h.container.TransportProvider()
	err := RejectConnectionHelper(transportProvider, req.DeviceId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Bağlantı reddedilemedi: %v", err),
			Code:    500,
		}, nil
	}
	
	return &pb.Status{
		Success: true,
		Message: "Bağlantı başarıyla reddedildi",
		Code:    200,
	}, nil
}

// AcceptConnectionHelper bağlantı isteğini onaylar (internal helper)
func AcceptConnectionHelper(transportProvider interface{}, deviceID string) error {
	lanTransport, ok := transportProvider.(*lan.LANTransport)
	if !ok {
		return fmt.Errorf("LAN transport bulunamadı")
	}
	
	connMgr := lanTransport.GetTCPConnectionManager()
	return connMgr.AcceptConnection(deviceID)
}

// RejectConnectionHelper bağlantı isteğini reddeder (internal helper)
func RejectConnectionHelper(transportProvider interface{}, deviceID string) error {
	lanTransport, ok := transportProvider.(*lan.LANTransport)
	if !ok {
		return fmt.Errorf("LAN transport bulunamadı")
	}
	
	connMgr := lanTransport.GetTCPConnectionManager()
	return connMgr.RejectConnection(deviceID)
}

// GetPendingConnectionsHelper bekleyen bağlantıları döner (internal helper)
func GetPendingConnectionsHelper(transportProvider interface{}) ([]interface {
	DeviceID() string
	DeviceName() string
	Timestamp() int64
}, error) {
	lanTransport, ok := transportProvider.(*lan.LANTransport)
	if !ok {
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
	transportProvider := h.container.TransportProvider()
	wanTransport, ok := transportProvider.(*wan.WANTransport)
	if !ok {
		return &pb.CreateInvitationResponse{
			Status: &pb.Status{
				Success: false,
				Message: "WAN transport aktif değil",
				Code:    400,
			},
		}, nil
	}

	// Device bilgilerini al
	deviceID, err := h.container.GetDeviceID()
	if err != nil {
		return &pb.CreateInvitationResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Device ID alınamadı: %v", err),
				Code:    500,
			},
		}, nil
	}
	deviceName := h.container.GetDeviceName()

	// Public IP al
	publicIP, err := wanTransport.GetPublicIP(ctx)
	if err != nil {
		log.Printf("⚠️ Public IP alınamadı: %v (devam ediliyor)", err)
		publicIP = "" // Devam et, public IP olmadan da code oluşturulabilir
	}

	// NAT type al
	natType, err := wanTransport.GetNATType(ctx)
	if err != nil {
		log.Printf("⚠️ NAT type alınamadı: %v (devam ediliyor)", err)
		natType = "unknown"
	}

	// ICE candidates al
	iceCandidates, err := wanTransport.GetICECandidates()
	if err != nil {
		log.Printf("⚠️ ICE candidates alınamadı: %v (devam ediliyor)", err)
		iceCandidates = []wan.ICECandidate{}
	}

	// gRPC server adresi oluştur (public IP + port)
	cfg := h.container.Config()
	grpcAddress := ""
	if publicIP != "" {
		grpcAddress = fmt.Sprintf("%s:%d", publicIP, cfg.GRPC.Port)
	} else {
		// Public IP yoksa, localhost kullan (sınırlı kullanım)
		grpcAddress = fmt.Sprintf("%s:%d", cfg.GRPC.Host, cfg.GRPC.Port)
		log.Printf("⚠️ Public IP olmadığı için gRPC adresi: %s (sınırlı kullanım)", grpcAddress)
	}

	// Invitation service oluştur
	invitationService := wan.NewInvitationService(deviceID, nil) // Key deviceID'den türetilecek

	// Expiry duration (varsayılan: 24 saat)
	expiryHours := req.ExpiryHours
	if expiryHours <= 0 {
		expiryHours = 24
	}
	expiryDuration := time.Duration(expiryHours) * time.Hour

	// Invitation code oluştur
	code, err := invitationService.GenerateInvitationCode(
		deviceID,
		deviceName,
		publicIP,
		grpcAddress, // gRPC server adresi eklendi
		natType,
		iceCandidates,
		expiryDuration,
	)
	if err != nil {
		return &pb.CreateInvitationResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Invitation code oluşturulamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// Invitation link oluştur
	link := invitationService.GenerateInvitationLink(code)

	// Expiry timestamp
	expiresAt := time.Now().Add(expiryDuration).Unix()

	log.Printf("✅ Invitation code oluşturuldu: %s (expires in %d hours)", code[:20], expiryHours)

	return &pb.CreateInvitationResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Invitation code başarıyla oluşturuldu",
			Code:    200,
		},
		InvitationCode:  code,
		InvitationLink:  link,
		QrCodeImage:     "", // TODO: QR code image oluştur (opsiyonel)
		ExpiresAt:       expiresAt,
	}, nil
}

// AddPeerByInvitation invitation code ile peer ekler (WAN için)
func (h *PeerHandler) AddPeerByInvitation(ctx context.Context, req *pb.AddPeerByInvitationRequest) (*pb.Status, error) {
	if req.InvitationCode == "" {
		return &pb.Status{
			Success: false,
			Message: "Invitation code boş olamaz",
			Code:    400,
		}, nil
	}

	// WAN transport kontrolü
	transportProvider := h.container.TransportProvider()
	wanTransport, ok := transportProvider.(*wan.WANTransport)
	if !ok {
		return &pb.Status{
			Success: false,
			Message: "WAN transport aktif değil",
			Code:    400,
		}, nil
	}

	// Device ID al (invitation service için)
	deviceID, err := h.container.GetDeviceID()
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Device ID alınamadı: %v", err),
			Code:    500,
		}, nil
	}

	// Invitation service oluştur
	invitationService := wan.NewInvitationService(deviceID, nil)

	// Invitation code parse et
	invitationData, err := invitationService.ParseInvitationCode(req.InvitationCode)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Invitation code parse edilemedi: %v", err),
			Code:    400,
		}, nil
	}

	// Kendi device ID'si ile eşleşirse hata
	if invitationData.DeviceID == deviceID {
		return &pb.Status{
			Success: false,
			Message: "Kendi invitation code'unuzu kullanamazsınız",
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

	// Peer'ı ekle (gRPC address ile)
	err = discoveryService.AddPeerWithGRPC(
		invitationData.DeviceID,
		invitationData.DeviceName,
		invitationData.PublicIP,
		invitationData.GRPCAddress, // gRPC address direkt ekleniyor
		invitationData.ICECandidates,
	)
	
	if invitationData.GRPCAddress != "" {
		log.Printf("✅ gRPC address metadata'ya eklendi: %s", invitationData.GRPCAddress)
	}
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Peer eklenemedi: %v", err),
			Code:    500,
		}, nil
	}

	log.Printf("✅ Peer invitation code ile eklendi: %s (%s)", invitationData.DeviceName, invitationData.DeviceID[:8])

	// (Opsiyonel) Otomatik bağlanmayı dene
	go func() {
		// Peer'ı bul
		discoveredPeers := discoveryService.GetDiscoveredPeers()
		for _, peer := range discoveredPeers {
			if peer.DeviceID == invitationData.DeviceID {
				// Bağlanmayı dene
				_, err := wanTransport.Connect(ctx, peer)
				if err != nil {
					log.Printf("⚠️ Otomatik bağlantı kurulamadı: %v (peer manuel olarak bağlanabilir)", err)
				} else {
					log.Printf("✅ Otomatik bağlantı kuruldu: %s", peer.DeviceName)
				}
				break
			}
		}
	}()

	return &pb.Status{
		Success: true,
		Message: fmt.Sprintf("Peer başarıyla eklendi: %s", invitationData.DeviceName),
		Code:    200,
	}, nil
}

// AddWANPeer manuel olarak WAN peer ekler (invitation code olmadan)
func (h *PeerHandler) AddWANPeer(ctx context.Context, req *pb.AddWANPeerRequest) (*pb.Status, error) {
	if req.PeerId == "" {
		return &pb.Status{
			Success: false,
			Message: "Peer ID boş olamaz",
			Code:    400,
		}, nil
	}

	// WAN transport kontrolü
	transportProvider := h.container.TransportProvider()
	wanTransport, ok := transportProvider.(*wan.WANTransport)
	if !ok {
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

	// ICE candidates parse et (eğer varsa)
	iceCandidates := []wan.ICECandidate{}
	// TODO: ICE candidates'ı string array'den parse et
	// Şimdilik boş bırakıyoruz, public IP varsa onu kullanır

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
		iceCandidates,
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
	transportProvider := h.container.TransportProvider()
	wanTransport, ok := transportProvider.(*wan.WANTransport)
	if !ok {
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

	// NOT: req.PeerId aslında gönderen peer'ın ID'si (bize bağlanan peer)
	// ExchangeSDP'de peer'ı bulmak yerine, gelen offer'a göre connection oluşturmalıyız

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
		// Remote offer alındı, answer oluştur
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
