package grpc

import (
	"context"
	"fmt"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
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

// ConnectToPeer peer'a bağlanır (placeholder)
func (h *PeerHandler) ConnectToPeer(ctx context.Context, req *pb.ConnectToPeerRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "PeerHandler - yakında implement edilecek",
		Code:    501,
	}, nil
}

// DisconnectFromPeer peer bağlantısını keser (placeholder)
func (h *PeerHandler) DisconnectFromPeer(ctx context.Context, req *pb.DisconnectFromPeerRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "PeerHandler - yakında implement edilecek",
		Code:    501,
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

// TrustPeer peer'i güvenilir yapar (placeholder)
func (h *PeerHandler) TrustPeer(ctx context.Context, req *pb.TrustPeerRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "PeerHandler - yakında implement edilecek",
		Code:    501,
	}, nil
}

// UntrustPeer peer'i güvenilmez yapar (placeholder)
func (h *PeerHandler) UntrustPeer(ctx context.Context, req *pb.UntrustPeerRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "PeerHandler - yakında implement edilecek",
		Code:    501,
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
