package grpc

import (
	"context"
	"fmt"

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

// DeleteFile dosya siler (placeholder)
func (h *FileHandler) DeleteFile(ctx context.Context, req *pb.DeleteFileRequest) (*pb.Status, error) {
	return &pb.Status{
		Success: true,
		Message: "FileHandler - yakında implement edilecek",
		Code:    501,
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

