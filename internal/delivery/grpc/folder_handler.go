package grpc

import (
	"context"
	"fmt"
	"log"
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/pkg/scanner"
)

// FolderHandler FolderService implementasyonu
type FolderHandler struct {
	pb.UnimplementedFolderServiceServer
	container *container.Container
}

// NewFolderHandler yeni FolderHandler oluşturur
func NewFolderHandler(cont *container.Container) *FolderHandler {
	return &FolderHandler{container: cont}
}

// CreateFolder yeni klasör oluşturur
func (h *FolderHandler) CreateFolder(ctx context.Context, req *pb.CreateFolderRequest) (*pb.FolderResponse, error) {
	// Sync mode'u dönüştür
	syncMode := convertSyncMode(req.SyncMode)

	// Yeni folder entity oluştur
	folder := entity.NewFolder(req.LocalPath, syncMode)

	// Repository kullanarak kaydet
	if err := h.container.FolderRepository().Create(ctx, folder); err != nil {
		return &pb.FolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör oluşturulamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// 🔍 Klasörü tara ve dosyaları kaydet
	fileCount, err := h.scanAndSaveFiles(ctx, folder)
	if err != nil {
		log.Printf("⚠️ Klasör taranamadı (klasör oluşturuldu ama dosyalar kaydedilmedi): %v", err)
		// Hata döndürmüyoruz, çünkü klasör başarıyla oluşturuldu
	} else {
		log.Printf("✅ %d dosya tarandı ve kaydedildi", fileCount)
	}

	// Oluşturulan klasörü getir
	folder, err = h.container.FolderRepository().GetByID(ctx, folder.ID)
	if err != nil {
		return &pb.FolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör bilgisi alınamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	return &pb.FolderResponse{
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("Klasör başarıyla oluşturuldu (%d dosya tarandı)", fileCount),
			Code:    200,
		},
		Folder: convertFolderToProto(folder),
	}, nil
}

// GetFolder klasör bilgisi getirir
func (h *FolderHandler) GetFolder(ctx context.Context, req *pb.GetFolderRequest) (*pb.FolderResponse, error) {
	folder, err := h.container.FolderRepository().GetByID(ctx, req.Id)
	if err != nil {
		return &pb.FolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}

	return &pb.FolderResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Klasör bulundu",
			Code:    200,
		},
		Folder: convertFolderToProto(folder),
	}, nil
}

// ListFolders tüm klasörleri listeler
func (h *FolderHandler) ListFolders(ctx context.Context, req *pb.ListFoldersRequest) (*pb.ListFoldersResponse, error) {
	// Tüm klasörleri getir
	folders, err := h.container.FolderRepository().GetAll(ctx)
	if err != nil {
		return &pb.ListFoldersResponse{
			Folders: []*pb.Folder{},
			Pagination: &pb.PaginationResponse{
				TotalCount:  0,
				TotalPages:  0,
				CurrentPage: 1,
			},
		}, fmt.Errorf("klasörler listelenemedi: %w", err)
	}

	// Active_only filtresi varsa uygula
	if req.ActiveOnly {
		var activeFolders []*entity.Folder
		for _, f := range folders {
			if f.IsActive {
				activeFolders = append(activeFolders, f)
			}
		}
		folders = activeFolders
	}

	// Proto'ya dönüştür
	protoFolders := make([]*pb.Folder, len(folders))
	for i, folder := range folders {
		protoFolders[i] = convertFolderToProto(folder)
	}

	return &pb.ListFoldersResponse{
		Folders: protoFolders,
		Pagination: &pb.PaginationResponse{
			TotalCount:  int32(len(protoFolders)),
			TotalPages:  1,
			CurrentPage: 1,
		},
	}, nil
}

// UpdateFolder klasör günceller
func (h *FolderHandler) UpdateFolder(ctx context.Context, req *pb.UpdateFolderRequest) (*pb.FolderResponse, error) {
	// Mevcut klasörü getir
	folder, err := h.container.FolderRepository().GetByID(ctx, req.Id)
	if err != nil {
		return &pb.FolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}

	// Güncellemeleri uygula
	if req.LocalPath != "" {
		folder.LocalPath = req.LocalPath
	}
	if req.SyncMode != pb.SyncMode_SYNC_MODE_UNSPECIFIED {
		folder.SyncMode = convertSyncMode(req.SyncMode)
	}

	// Kaydet
	if err := h.container.FolderRepository().Update(ctx, folder); err != nil {
		return &pb.FolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör güncellenemedi: %v", err),
				Code:    500,
			},
		}, nil
	}

	return &pb.FolderResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Klasör başarıyla güncellendi",
			Code:    200,
		},
		Folder: convertFolderToProto(folder),
	}, nil
}

// DeleteFolder klasör siler
func (h *FolderHandler) DeleteFolder(ctx context.Context, req *pb.DeleteFolderRequest) (*pb.Status, error) {
	if err := h.container.FolderRepository().Delete(ctx, req.Id); err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Klasör silinemedi: %v", err),
			Code:    500,
		}, nil
	}

	return &pb.Status{
		Success: true,
		Message: "Klasör başarıyla silindi",
		Code:    200,
	}, nil
}

// ToggleFolderActive klasörü aktif/pasif yapar
func (h *FolderHandler) ToggleFolderActive(ctx context.Context, req *pb.ToggleFolderActiveRequest) (*pb.FolderResponse, error) {
	folder, err := h.container.FolderRepository().GetByID(ctx, req.Id)
	if err != nil {
		return &pb.FolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}

	// Mevcut durumun tersini al (TOGGLE)
	folder.IsActive = !folder.IsActive

	if err := h.container.FolderRepository().Update(ctx, folder); err != nil {
		return &pb.FolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör güncellenemedi: %v", err),
				Code:    500,
			},
		}, nil
	}

	return &pb.FolderResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Klasör durumu güncellendi",
			Code:    200,
		},
		Folder: convertFolderToProto(folder),
	}, nil
}

// ScanFolder klasörü tarar ve dosyaları kaydeder
func (h *FolderHandler) ScanFolder(ctx context.Context, req *pb.ScanFolderRequest) (*pb.ScanFolderResponse, error) {
	// Klasörü getir
	folder, err := h.container.FolderRepository().GetByID(ctx, req.FolderId)
	if err != nil {
		return &pb.ScanFolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}

	// Tarama yap
	savedCount, err := h.scanAndSaveFiles(ctx, folder)
	if err != nil {
		return &pb.ScanFolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör taranamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	return &pb.ScanFolderResponse{
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("%d dosya başarıyla tarandı ve kaydedildi", savedCount),
			Code:    200,
		},
		FilesSaved: int32(savedCount),
	}, nil
}

// Helper fonksiyonlar

func convertFolderToProto(f *entity.Folder) *pb.Folder {
	if f == nil {
		return nil
	}

	return &pb.Folder{
		Id:           f.ID,
		LocalPath:    f.LocalPath,
		SyncMode:     convertSyncModeToProto(f.SyncMode),
		LastScanTime: timestamppb.New(f.LastScanTime),
		IsActive:     f.IsActive,
		CreatedAt:    timestamppb.New(f.CreatedAt),
		UpdatedAt:    timestamppb.New(f.UpdatedAt),
	}
}

func convertSyncMode(mode pb.SyncMode) entity.SyncMode {
	switch mode {
	case pb.SyncMode_SYNC_MODE_BIDIRECTIONAL:
		return entity.SyncModeBidirectional
	case pb.SyncMode_SYNC_MODE_SEND_ONLY:
		return entity.SyncModeSendOnly
	case pb.SyncMode_SYNC_MODE_RECEIVE_ONLY:
		return entity.SyncModeReceiveOnly
	default:
		return entity.SyncModeBidirectional
	}
}

func convertSyncModeToProto(mode entity.SyncMode) pb.SyncMode {
	switch mode {
	case entity.SyncModeBidirectional:
		return pb.SyncMode_SYNC_MODE_BIDIRECTIONAL
	case entity.SyncModeSendOnly:
		return pb.SyncMode_SYNC_MODE_SEND_ONLY
	case entity.SyncModeReceiveOnly:
		return pb.SyncMode_SYNC_MODE_RECEIVE_ONLY
	default:
		return pb.SyncMode_SYNC_MODE_BIDIRECTIONAL
	}
}

// scanAndSaveFiles klasörü tarar ve dosyaları veritabanına kaydeder
func (h *FolderHandler) scanAndSaveFiles(ctx context.Context, folder *entity.Folder) (int, error) {
	// FileScanner oluştur
	fileScanner := scanner.NewFileScanner()

	// Klasörü tara
	scanResults, err := fileScanner.ScanDirectory(folder.LocalPath)
	if err != nil {
		return 0, fmt.Errorf("klasör taranamadı: %w", err)
	}

	log.Printf("📂 %s klasöründe %d dosya bulundu", folder.LocalPath, len(scanResults))

	// Her dosyayı veritabanına kaydet
	savedCount := 0
	for _, result := range scanResults {
		// File entity oluştur
		file := entity.NewFile(
			folder.ID,
			result.Path,
			result.Size,
			time.Unix(result.ModTime, 0),
		)

		// Veritabanına kaydet
		if err := h.container.FileRepository().Create(ctx, file); err != nil {
			log.Printf("⚠️ Dosya kaydedilemedi (%s): %v", result.Path, err)
			continue
		}
		savedCount++
	}

	// Folder'ın LastScanTime'ını güncelle
	folder.UpdateScanTime()
	if err := h.container.FolderRepository().Update(ctx, folder); err != nil {
		log.Printf("⚠️ LastScanTime güncellenemedi: %v", err)
	}

	return savedCount, nil
}

