package grpc

import (
	"context"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
)

// SyncHandler SyncService implementasyonu
type SyncHandler struct {
	pb.UnimplementedSyncServiceServer
	container *container.Container
}

// NewSyncHandler yeni SyncHandler oluşturur
func NewSyncHandler(cont *container.Container) *SyncHandler {
	return &SyncHandler{container: cont}
}

// SyncFile dosya senkronize eder (placeholder)
func (h *SyncHandler) SyncFile(ctx context.Context, req *pb.SyncFileRequest) (*pb.SyncFileResponse, error) {
	return &pb.SyncFileResponse{
		Status: &pb.Status{
			Success: true,
			Message: "SyncHandler - yakında implement edilecek",
			Code:    501,
		},
	}, nil
}

// GetSyncStatus senkronizasyon durumunu getirir (placeholder)
func (h *SyncHandler) GetSyncStatus(ctx context.Context, req *pb.GetSyncStatusRequest) (*pb.SyncStatusResponse, error) {
	return &pb.SyncStatusResponse{
		Status: &pb.Status{
			Success: true,
			Message: "SyncHandler - yakında implement edilecek",
			Code:    501,
		},
	}, nil
}

// PauseSync senkronizasyonu duraklatır (placeholder)
func (h *SyncHandler) PauseSync(ctx context.Context, req *pb.PauseSyncRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "SyncHandler - yakında implement edilecek",
		Code:    501,
	}, nil
}

// ResumeSync senkronizasyonu devam ettirir (placeholder)
func (h *SyncHandler) ResumeSync(ctx context.Context, req *pb.ResumeSyncRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "SyncHandler - yakında implement edilecek",
		Code:    501,
	}, nil
}

// WatchSyncEvents senkronizasyon olaylarını izler - streaming (placeholder)
func (h *SyncHandler) WatchSyncEvents(req *pb.WatchSyncEventsRequest, stream pb.SyncService_WatchSyncEventsServer) error {
	// Streaming implementasyonu yakında eklenecek
	return nil
}
