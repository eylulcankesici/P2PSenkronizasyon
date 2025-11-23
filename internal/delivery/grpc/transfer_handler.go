package grpc

import (
	"context"
	"fmt"
	"log"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
)

// TransferHandler TransferService implementasyonu
type TransferHandler struct {
	pb.UnimplementedTransferServiceServer
	container *container.Container
}

// NewTransferHandler yeni TransferHandler oluşturur
func NewTransferHandler(cont *container.Container) *TransferHandler {
	return &TransferHandler{container: cont}
}

// ListTransfers aktif transferleri listeler
func (h *TransferHandler) ListTransfers(ctx context.Context, req *pb.ListTransfersRequest) (*pb.ListTransfersResponse, error) {
	log.Printf("📋 Transferler listeleniyor: active_only=%v, completed_only=%v, failed_only=%v",
		req.ActiveOnly, req.CompletedOnly, req.FailedOnly)

	// Transfer manager'dan transferleri al
	transferManager := h.container.TransferManager()
	transfers := transferManager.ListTransfers(ctx, req.ActiveOnly, req.CompletedOnly, req.FailedOnly)

	// Proto mesajlarına dönüştür
	pbTransfers := make([]*pb.TransferInfo, 0, len(transfers))
	for _, transfer := range transfers {
		pbTransfers = append(pbTransfers, transfer.ToProto())
	}

	log.Printf("✅ %d transfer bulundu", len(pbTransfers))

	return &pb.ListTransfersResponse{
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("%d transfer bulundu", len(pbTransfers)),
			Code:    200,
		},
		Transfers: pbTransfers,
	}, nil
}

// GetTransferStatus belirli bir transfer durumunu getirir
func (h *TransferHandler) GetTransferStatus(ctx context.Context, req *pb.GetTransferStatusRequest) (*pb.GetTransferStatusResponse, error) {
	log.Printf("📊 Transfer durumu alınıyor: file_id=%s", req.FileId)

	// Transfer manager'dan transfer'i al
	transferManager := h.container.TransferManager()
	transfer, exists := transferManager.GetTransfer(req.FileId)

	if !exists {
		return &pb.GetTransferStatusResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Transfer bulunamadı: %s", req.FileId),
				Code:    404,
			},
		}, nil
	}

	log.Printf("✅ Transfer durumu alındı: %s (state: %v, progress: %.1f%%)",
		req.FileId, transfer.State, transfer.ToProto().ProgressPercentage)

	return &pb.GetTransferStatusResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Transfer durumu alındı",
			Code:    200,
		},
		Transfer: transfer.ToProto(),
	}, nil
}

// CancelTransfer transfer'i iptal eder
func (h *TransferHandler) CancelTransfer(ctx context.Context, req *pb.CancelTransferRequest) (*pb.Status, error) {
	log.Printf("❌ Transfer iptal ediliyor: file_id=%s", req.FileId)

	// Transfer manager'dan transfer'i iptal et
	transferManager := h.container.TransferManager()
	transfer, exists := transferManager.GetTransfer(req.FileId)

	if !exists {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Transfer bulunamadı: %s", req.FileId),
			Code:    404,
		}, nil
	}

	// Sadece aktif transferler iptal edilebilir
	if transfer.State != pb.TransferState_TRANSFER_STATE_ACTIVE {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Transfer iptal edilemez (state: %v)", transfer.State),
			Code:    400,
		}, nil
	}

	// Transfer'i iptal et (hem SEND hem RECEIVE için çalışır)
	transferManager.CancelTransfer(req.FileId)
	
	// Yön bilgisini logla
	directionStr := "SEND"
	if transfer.Direction == pb.TransferDirection_TRANSFER_DIRECTION_RECEIVE {
		directionStr = "RECEIVE"
	}
	
	log.Printf("✅ Transfer iptal edildi: %s (direction: %s, peer: %s)", req.FileId, directionStr, transfer.PeerID[:8])
	
	// Eğer alıcı taraf iptal edildiyse, gönderen tarafa bildirim gönder
	if transfer.Direction == pb.TransferDirection_TRANSFER_DIRECTION_RECEIVE {
		log.Printf("  📤 Alıcı taraf iptal edildi, gönderen tarafa bildirim gönderiliyor (peer: %s, file: %s)...", transfer.PeerID[:8], req.FileId[:8])
		
		// Gönderen tarafa transfer cancel bildirimi gönder
		conn, exists := h.container.TransportProvider().GetConnection(transfer.PeerID)
		if !exists {
			log.Printf("  ❌ Peer bağlı değil, transfer iptal bildirimi gönderilemedi: %s", transfer.PeerID[:8])
		} else {
			log.Printf("  ✅ Peer bağlantısı bulundu: %s", transfer.PeerID[:8])
			
			// Type assertion ile SendTransferCancel metoduna eriş
			if tcpConn, ok := conn.(interface {
				SendTransferCancel(ctx context.Context, fileID, reason string) error
			}); !ok {
				log.Printf("  ❌ Connection type SendTransferCancel desteklemiyor: %T", conn)
			} else {
				reason := "Alıcı taraf tarafından iptal edildi"
				log.Printf("  📨 Transfer cancel mesajı gönderiliyor...")
				if err := tcpConn.SendTransferCancel(context.Background(), req.FileId, reason); err != nil {
					log.Printf("  ❌ Transfer iptal bildirimi gönderilemedi (peer: %s): %v", transfer.PeerID[:8], err)
				} else {
					log.Printf("  ✅ Transfer iptal bildirimi başarıyla gönderildi (peer: %s, file: %s)", transfer.PeerID[:8], req.FileId[:8])
				}
			}
		}
	} else {
		log.Printf("  ℹ️ Gönderen taraf iptal edildi, bildirim göndermeye gerek yok (direction: SEND)")
	}

	return &pb.Status{
		Success: true,
		Message: "Transfer iptal edildi",
		Code:    200,
	}, nil
}

