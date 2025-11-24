package grpc

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"google.golang.org/protobuf/types/known/timestamppb"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
)

// FileHandler FileService implementasyonu
type FileHandler struct {
	pb.UnimplementedFileServiceServer
	container *container.Container
}

// NewFileHandler yeni FileHandler oluşturur
func NewFileHandler(cont *container.Container) *FileHandler {
	return &FileHandler{container: cont}
}

// GetFile dosya bilgisi getirir (placeholder)
func (h *FileHandler) GetFile(ctx context.Context, req *pb.GetFileRequest) (*pb.FileResponse, error) {
	return &pb.FileResponse{
		Status: &pb.Status{
			Success: true,
			Message: "FileHandler - yakında implement edilecek",
			Code:    501,  // Not Implemented
		},
	}, nil
}

// ListFiles dosyaları listeler
func (h *FileHandler) ListFiles(ctx context.Context, req *pb.ListFilesRequest) (*pb.ListFilesResponse, error) {
	// Klasördeki dosyaları getir
	files, err := h.container.FileRepository().GetByFolderID(ctx, req.FolderId)
	if err != nil {
		return &pb.ListFilesResponse{
			Files: []*pb.File{},
			Pagination: &pb.PaginationResponse{
				TotalCount:  0,
				TotalPages:  0,
				CurrentPage: 1,
			},
		}, fmt.Errorf("dosyalar listelenemedi: %w", err)
	}

	// Proto'ya dönüştür
	protoFiles := make([]*pb.File, len(files))
	for i, file := range files {
		protoFiles[i] = convertFileToProto(file)
	}

	return &pb.ListFilesResponse{
		Files: protoFiles,
		Pagination: &pb.PaginationResponse{
			TotalCount:  int32(len(protoFiles)),
			TotalPages:  1,
			CurrentPage: 1,
		},
	}, nil
}

// DeleteFile dosya siler
func (h *FileHandler) DeleteFile(ctx context.Context, req *pb.DeleteFileRequest) (*pb.Status, error) {
	log.Printf("🗑️ Dosya siliniyor: %s", req.FileId[:8])
	
	// Önce file bilgisini al (fiziksel path için)
	file, err := h.container.FileRepository().GetByID(ctx, req.FileId)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Dosya bulunamadı: %v", err),
			Code:    404,
		}, nil
	}
	
	// Folder bilgisini al (path oluşturmak için)
	folder, err := h.container.FolderRepository().GetByID(ctx, file.FolderID)
	if err != nil {
		log.Printf("⚠️ Folder bilgisi alınamadı: %v", err)
		// Devam et, sadece veritabanından sil
	}
	
	// Veritabanından sil (CASCADE olduğu için file_chunks da silinir)
	if err := h.container.FileRepository().Delete(ctx, req.FileId); err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Dosya veritabanından silinemedi: %v", err),
			Code:    500,
		}, nil
	}
	log.Printf("✅ Dosya veritabanından silindi: %s", req.FileId[:8])
	
	// FİZİKSEL dosyayı SİL mi yoksa KORU mu?
	// KURAL: Source field'ına göre karar ver (path'e bakmaya gerek yok!)
	//   - FolderSourceReceived → Peer'dan alınan → FİZİKSEL OLARAK SİL
	//   - FolderSourceUser → Kullanıcının eklediği → SADECE DB'DEN SİL, FİZİKSEL DOSYAYI KORU
	
	if folder != nil && folder.LocalPath != "" && file.RelativePath != "" {
		filePath := filepath.Join(folder.LocalPath, file.RelativePath)
		
		if folder.Source == entity.FolderSourceReceived {
			// ALICI TARAF: Peer'dan alınan dosya → Fiziksel olarak sil
			log.Printf("📦 Bu alıcı tarafın dosyası (received), fiziksel olarak siliniyor: %s", filePath)
			if err := os.Remove(filePath); err != nil {
				log.Printf("⚠️ Fiziksel dosya silinemedi (%s): %v", filePath, err)
				return &pb.Status{
					Success: true,
					Message: fmt.Sprintf("Dosya veritabanından silindi ama fiziksel dosya silinemedi: %v", err),
					Code:    200,
				}, nil
			}
			log.Printf("✅ Fiziksel dosya silindi: %s", filePath)
			
			return &pb.Status{
				Success: true,
				Message: "Dosya başarıyla silindi (veritabanı + fiziksel dosya)",
				Code:    200,
			}, nil
		} else {
			// GÖNDERİCİ TARAF: Kullanıcının kendi eklediği dosya → Fiziksel olarak SILME
			log.Printf("📁 Bu gönderici tarafın dosyası, fiziksel dosya KORUNUYOR: %s", filePath)
			
			return &pb.Status{
				Success: true,
				Message: "Dosya uygulamadan kaldırıldı (fiziksel dosya korundu)",
				Code:    200,
			}, nil
		}
	}
	
	// Folder bilgisi yoksa (fallback)
	return &pb.Status{
		Success: true,
		Message: "Dosya veritabanından silindi",
		Code:    200,
	}, nil
}

// GetFileVersions dosya versiyonlarını getirir (placeholder)
func (h *FileHandler) GetFileVersions(ctx context.Context, req *pb.GetFileVersionsRequest) (*pb.FileVersionsResponse, error) {
	return &pb.FileVersionsResponse{
		Status: &pb.Status{
			Success: true,
			Message: "FileHandler - yakında implement edilecek",
			Code:    501,
		},
		Versions: []*pb.FileVersion{},
	}, nil
}

// RestoreFile dosyayı geri yükler (placeholder)
func (h *FileHandler) RestoreFile(ctx context.Context, req *pb.RestoreFileRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "FileHandler - yakında implement edilecek",
		Code:    501,
	}, nil
}

// GetFileInfo dosya detay bilgisi getirir (placeholder)
func (h *FileHandler) GetFileInfo(ctx context.Context, req *pb.GetFileInfoRequest) (*pb.FileInfoResponse, error) {
	return &pb.FileInfoResponse{
		Status: &pb.Status{
			Success: true,
			Message: "FileHandler - yakında implement edilecek",
			Code:    501,
		},
	}, nil
}

// Helper fonksiyonlar

func convertFileToProto(f *entity.File) *pb.File {
	if f == nil {
		return nil
	}

	return &pb.File{
		Id:           f.ID,
		FolderId:     f.FolderID,
		RelativePath: f.RelativePath,
		Size:         f.Size,
		ModTime:      timestamppb.New(f.ModTime),
		GlobalHash:   f.GlobalHash,
		ChunkCount:   int32(f.ChunkCount),
		IsDeleted:    f.IsDeleted,
		CreatedAt:    timestamppb.New(f.CreatedAt),
		UpdatedAt:    timestamppb.New(f.UpdatedAt),
	}
}

