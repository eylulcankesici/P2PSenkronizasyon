package grpc

import (
	"context"
	"fmt"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
)

// P2PDataHandler P2P data transfer handler (simplified)
type P2PDataHandler struct {
	pb.UnimplementedP2PDataServiceServer
	container *container.Container
}

// NewP2PDataHandler yeni handler oluşturur
func NewP2PDataHandler(cont *container.Container) *P2PDataHandler {
	return &P2PDataHandler{container: cont}
}

// RequestChunk chunk talep eder
func (h *P2PDataHandler) RequestChunk(ctx context.Context, req *pb.ChunkRequest) (*pb.ChunkResponse, error) {
	// Chunk verisini al
	chunkData, err := h.container.ChunkingUseCase().GetChunkData(ctx, req.ChunkHash)
	if err != nil {
		return &pb.ChunkResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Chunk bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}
	
	return &pb.ChunkResponse{
		Status: &pb.Status{
			Success: true,
			Message: "OK",
			Code:    200,
		},
		ChunkData: chunkData,
		ChunkHash: req.ChunkHash,
		ChunkSize: int64(len(chunkData)),
	}, nil
}

// TransferChunk chunk transfer eder (streaming - placeholder)
func (h *P2PDataHandler) TransferChunk(stream pb.P2PDataService_TransferChunkServer) error {
	return fmt.Errorf("not implemented")
}

// ShareFileMetadata metadata paylaşır (placeholder)
func (h *P2PDataHandler) ShareFileMetadata(ctx context.Context, req *pb.FileMetadataRequest) (*pb.FileMetadataResponse, error) {
	return &pb.FileMetadataResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Metadata paylaşımı - yakında",
			Code:    501,
		},
	}, nil
}

// Ping ping-pong
func (h *P2PDataHandler) Ping(ctx context.Context, req *pb.PingRequest) (*pb.PingResponse, error) {
	return &pb.PingResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Pong",
			Code:    200,
		},
		Timestamp: req.Timestamp,
		LatencyMs: 0,
	}, nil
}

