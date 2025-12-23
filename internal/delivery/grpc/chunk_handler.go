package grpc

import (
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"

	"google.golang.org/protobuf/types/known/timestamppb"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
)

// ChunkHandler ChunkService implementasyonu
type ChunkHandler struct {
	pb.UnimplementedChunkServiceServer
	container *container.Container
}

// NewChunkHandler yeni ChunkHandler oluşturur
func NewChunkHandler(cont *container.Container) *ChunkHandler {
	return &ChunkHandler{container: cont}
}

// ChunkFile dosyayı chunk'lar ve kaydeder
func (h *ChunkHandler) ChunkFile(ctx context.Context, req *pb.ChunkFileRequest) (*pb.ChunkFileResponse, error) {
	// Dosya kaydının var olup olmadığını kontrol et
	file, err := h.container.FileRepository().GetByID(ctx, req.FileId)
	if err != nil || file == nil {
		// Dosya kaydı yoksa oluştur
		fileInfo, err := os.Stat(req.FilePath)
		if err != nil {
			return &pb.ChunkFileResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Dosya bulunamadı: %v", err),
					Code:    404,
				},
			}, nil
		}

		// Yeni dosya kaydı oluştur
		folderID := req.FolderId
		if folderID == "" {
			folderID = "temp-folder-id"
		}
		newFile := entity.NewFile(folderID, "", filepath.Base(req.FilePath), fileInfo.Size(), fileInfo.ModTime(), false)
		newFile.ID = req.FileId

		if err := h.container.FileRepository().Create(ctx, newFile); err != nil {
			return &pb.ChunkFileResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Dosya kaydı oluşturulamadı: %v", err),
					Code:    500,
				},
			}, nil
		}
	}

	// Chunking use case'i çağır
	chunks, globalHash, err := h.container.ChunkingUseCase().ChunkAndStoreFile(ctx, req.FileId, req.FilePath)
	if err != nil {
		return &pb.ChunkFileResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Dosya chunk'lanamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// Chunk'ları proto'ya dönüştür
	protoChunks := make([]*pb.ChunkInfo, len(chunks))
	var totalSize int64
	for i, chunk := range chunks {
		protoChunks[i] = convertChunkToProto(chunk)
		totalSize += chunk.Size
	}

	log.Printf("✅ Dosya chunk'landı: %s (%d chunks, global_hash: %s...)", req.FileId, len(chunks), globalHash[:16])

	return &pb.ChunkFileResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Dosya başarıyla chunk'landı",
			Code:    200,
		},
		GlobalHash: globalHash,
		ChunkCount: int32(len(chunks)),
		TotalSize:  totalSize,
		Chunks:     protoChunks,
	}, nil
}

// GetFileChunks dosyanın chunk'larını getirir
func (h *ChunkHandler) GetFileChunks(ctx context.Context, req *pb.GetFileChunksRequest) (*pb.GetFileChunksResponse, error) {
	// Chunk'ları yükle
	chunks, err := h.container.ChunkingUseCase().LoadFileChunks(ctx, req.FileId)
	if err != nil {
		return &pb.GetFileChunksResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Chunk'lar yüklenemedi: %v", err),
				Code:    500,
			},
		}, nil
	}

	// File-chunk ilişkilerini al
	fileChunks, err := h.container.ChunkRepository().GetFileChunks(ctx, req.FileId)
	if err != nil {
		return &pb.GetFileChunksResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("File-chunk ilişkileri alınamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// Proto'ya dönüştür
	protoChunks := make([]*pb.ChunkInfo, len(chunks))
	for i, chunk := range chunks {
		protoChunks[i] = convertChunkToProto(chunk)
	}

	protoFileChunks := make([]*pb.FileChunkInfo, len(fileChunks))
	for i, fc := range fileChunks {
		protoFileChunks[i] = &pb.FileChunkInfo{
			FileId:     fc.FileID,
			ChunkHash:  fc.ChunkHash,
			ChunkIndex: int32(fc.ChunkIndex),
		}
	}

	return &pb.GetFileChunksResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Chunk'lar başarıyla getirildi",
			Code:    200,
		},
		Chunks:     protoChunks,
		FileChunks: protoFileChunks,
	}, nil
}

// DownloadChunk chunk verisini stream olarak indirir
func (h *ChunkHandler) DownloadChunk(req *pb.DownloadChunkRequest, stream pb.ChunkService_DownloadChunkServer) error {
	ctx := stream.Context()

	// Chunk verisini oku
	chunkData, err := h.container.ChunkingUseCase().GetChunkData(ctx, req.ChunkHash)
	if err != nil {
		return fmt.Errorf("chunk verisi okunamadı: %w", err)
	}

	// 64 KB paketler halinde stream et
	bufferSize := 64 * 1024
	totalSize := len(chunkData)
	offset := 0

	for offset < totalSize {
		end := offset + bufferSize
		if end > totalSize {
			end = totalSize
		}

		packet := &pb.ChunkDataResponse{
			Data:      chunkData[offset:end],
			Offset:    int32(offset),
			TotalSize: int32(totalSize),
		}

		if err := stream.Send(packet); err != nil {
			return fmt.Errorf("chunk paketi gönderilemedi: %w", err)
		}

		offset = end
	}

	log.Printf("✓ Chunk indirildi: %s (%d bytes)", req.ChunkHash[:16]+"...", totalSize)
	return nil
}

// UploadChunk chunk verisini stream olarak yükler
func (h *ChunkHandler) UploadChunk(stream pb.ChunkService_UploadChunkServer) error {
	ctx := stream.Context()

	var chunkHash string
	var totalSize int64
	var receivedData []byte

	// Stream'den paketleri al
	for {
		req, err := stream.Recv()
		if err == io.EOF {
			break
		}
		if err != nil {
			return fmt.Errorf("chunk paketi alınamadı: %w", err)
		}

		// İlk paketten metadata al
		if chunkHash == "" {
			chunkHash = req.ChunkHash
			totalSize = req.TotalSize
			receivedData = make([]byte, 0, totalSize)
		}

		receivedData = append(receivedData, req.Data...)
	}

	// Chunk'ı kaydet
	chunk := entity.NewChunk(chunkHash, int64(len(receivedData)))

	// Chunk zaten var mı kontrol et
	existingChunk, _ := h.container.ChunkRepository().GetByHash(ctx, chunkHash)
	wasDuplicate := existingChunk != nil

	if !wasDuplicate {
		// Repository'ye kaydet
		if err := h.container.ChunkRepository().Create(ctx, chunk); err != nil {
			return stream.SendAndClose(&pb.UploadChunkResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Chunk kaydedilemedi: %v", err),
					Code:    500,
				},
			})
		}
	}

	log.Printf("✓ Chunk yüklendi: %s (%d bytes, duplicate=%v)", chunkHash[:16]+"...", len(receivedData), wasDuplicate)

	return stream.SendAndClose(&pb.UploadChunkResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Chunk başarıyla yüklendi",
			Code:    200,
		},
		ChunkHash:    chunkHash,
		WasDuplicate: wasDuplicate,
	})
}

// VerifyFileIntegrity dosya bütünlüğünü doğrular
func (h *ChunkHandler) VerifyFileIntegrity(ctx context.Context, req *pb.VerifyFileIntegrityRequest) (*pb.VerifyFileIntegrityResponse, error) {
	// Bütünlük kontrolü yap
	err := h.container.ChunkingUseCase().VerifyFileIntegrity(ctx, req.FileId, req.ExpectedGlobalHash)
	if err != nil {
		return &pb.VerifyFileIntegrityResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Bütünlük kontrolü başarısız: %v", err),
				Code:    500,
			},
			IsValid: false,
		}, nil
	}

	return &pb.VerifyFileIntegrityResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Dosya bütünlüğü doğrulandı",
			Code:    200,
		},
		IsValid:          true,
		ActualGlobalHash: req.ExpectedGlobalHash,
	}, nil
}

// GetDeduplicationStats deduplication istatistiklerini getirir
func (h *ChunkHandler) GetDeduplicationStats(ctx context.Context, req *pb.GetDeduplicationStatsRequest) (*pb.GetDeduplicationStatsResponse, error) {
	totalChunks, uniqueChunks, savings, err := h.container.ChunkingUseCase().GetDeduplicationStats(ctx)
	if err != nil {
		return &pb.GetDeduplicationStatsResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("İstatistikler alınamadı: %v", err),
				Code:    500,
			},
		}, nil
	}

	// Deduplication ratio hesapla
	deduplicationRatio := float32(0)
	if totalChunks > 0 {
		deduplicationRatio = float32(uniqueChunks) / float32(totalChunks) * 100
	}

	// Disk kullanımını hesapla
	var diskUsage int64
	localChunks, _ := h.container.ChunkRepository().GetLocalChunks(ctx)
	for _, chunk := range localChunks {
		diskUsage += chunk.Size
	}

	return &pb.GetDeduplicationStatsResponse{
		Status: &pb.Status{
			Success: true,
			Message: "İstatistikler başarıyla alındı",
			Code:    200,
		},
		TotalChunkReferences: totalChunks,
		UniqueChunks:         uniqueChunks,
		SavingsBytes:         savings,
		DeduplicationRatio:   deduplicationRatio,
		DiskUsageBytes:       diskUsage,
	}, nil
}

// CleanOrphanChunks orphan chunk'ları temizler
func (h *ChunkHandler) CleanOrphanChunks(ctx context.Context, req *pb.CleanOrphanChunksRequest) (*pb.CleanOrphanChunksResponse, error) {
	// Önce silinecek chunk'ların boyutunu al
	var freedBytes int64

	deletedCount, err := h.container.ChunkRepository().DeleteOrphanedChunks(ctx)
	if err != nil {
		return &pb.CleanOrphanChunksResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Orphan chunk'lar temizlenemedi: %v", err),
				Code:    500,
			},
		}, nil
	}

	freedBytes = int64(deletedCount) * 256 * 1024 // Yaklaşık

	log.Printf("🧹 %d orphan chunk temizlendi (%d MB boşaltıldı)", deletedCount, freedBytes/(1024*1024))

	return &pb.CleanOrphanChunksResponse{
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("%d orphan chunk temizlendi", deletedCount),
			Code:    200,
		},
		DeletedChunks: int32(deletedCount),
		FreedBytes:    freedBytes,
	}, nil
}

// Helper fonksiyonlar

func convertChunkToProto(c *entity.Chunk) *pb.ChunkInfo {
	if c == nil {
		return nil
	}

	return &pb.ChunkInfo{
		Hash:         c.Hash,
		Size:         c.Size,
		CreationTime: timestamppb.New(c.CreationTime),
		IsLocal:      c.IsLocal,
	}
}
