package grpc

import (
	"context"
	"fmt"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"
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
// TODO: Proto derleme sonrası aktif edilecek
/*
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
*/

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
