package grpc

import (
	"context"
	"fmt"
	"log"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
)

// WatcherHandler WatcherService implementasyonu
type WatcherHandler struct {
	pb.UnimplementedWatcherServiceServer
	container *container.Container
}

// NewWatcherHandler yeni WatcherHandler oluşturur
func NewWatcherHandler(cont *container.Container) *WatcherHandler {
	return &WatcherHandler{container: cont}
}

// StartWatching klasör izlemeye başlar
func (h *WatcherHandler) StartWatching(ctx context.Context, req *pb.StartWatchingRequest) (*pb.Status, error) {
	log.Printf("📂 Klasör izlemeye alınıyor: %s", req.FolderId[:8])
	
	// Folder'ı veritabanından al
	folder, err := h.container.FolderRepository().GetByID(ctx, req.FolderId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
			Code:    404,
		}, nil
	}
	
	// FileWatcher'a ekle
	if err := h.container.FileWatcher().AddFolder(folder); err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Klasör izlemeye alınamadı: %v", err),
			Code:    500,
		}, nil
	}
	
	log.Printf("✅ Klasör izlemeye alındı: %s", folder.LocalPath)
	
	return &pb.Status{
		Success: true,
		Message: "Klasör izlemeye alındı",
		Code:    200,
	}, nil
}

// StopWatching klasör izlemeyi durdurur
func (h *WatcherHandler) StopWatching(ctx context.Context, req *pb.StopWatchingRequest) (*pb.Status, error) {
	log.Printf("🛑 Klasör izlemeden çıkarılıyor: %s", req.FolderId[:8])
	
	// FileWatcher'dan kaldır
	if err := h.container.FileWatcher().RemoveFolder(req.FolderId); err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Klasör izlemeden çıkarılamadı: %v", err),
			Code:    500,
		}, nil
	}
	
	log.Printf("✅ Klasör izlemeden çıkarıldı: %s", req.FolderId[:8])
	
	return &pb.Status{
		Success: true,
		Message: "Klasör izlemeden çıkarıldı",
		Code:    200,
	}, nil
}

// ListWatchedFolders izlenen klasörleri listeler
func (h *WatcherHandler) ListWatchedFolders(ctx context.Context, req *pb.ListWatchedFoldersRequest) (*pb.ListWatchedFoldersResponse, error) {
	folderIDs := h.container.FileWatcher().GetWatchedFolders()
	
	return &pb.ListWatchedFoldersResponse{
		FolderIds: folderIDs,
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("%d klasör izleniyor", len(folderIDs)),
			Code:    200,
		},
	}, nil
}

// GetWatchStatus watch durumunu döner
func (h *WatcherHandler) GetWatchStatus(ctx context.Context, req *pb.GetWatchStatusRequest) (*pb.WatchStatusResponse, error) {
	// İzlenen klasörleri kontrol et
	watchedFolders := h.container.FileWatcher().GetWatchedFolders()
	
	isWatching := false
	for _, folderID := range watchedFolders {
		if folderID == req.FolderId {
			isWatching = true
			break
		}
	}
	
	// Folder bilgisini al
	folder, err := h.container.FolderRepository().GetByID(ctx, req.FolderId)
	if err != nil {
		return &pb.WatchStatusResponse{
			IsWatching: false,
			FolderId:   req.FolderId,
			FolderPath: "",
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}
	
	return &pb.WatchStatusResponse{
		IsWatching: isWatching,
		FolderId:   req.FolderId,
		FolderPath: folder.LocalPath,
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("Watch durumu: %v", isWatching),
			Code:    200,
		},
	}, nil
}

