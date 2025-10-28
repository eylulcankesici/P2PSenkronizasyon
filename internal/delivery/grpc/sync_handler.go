package grpc

import (
	"context"
	"fmt"
	"log"
	"path/filepath"

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

// SyncFile dosya senkronize eder
func (h *SyncHandler) SyncFile(ctx context.Context, req *pb.SyncFileRequest) (*pb.SyncFileResponse, error) {
	log.Printf("🔄 Dosya senkronize ediliyor: %s -> %d peer", req.FileId, len(req.TargetPeerIds))
	
	if len(req.TargetPeerIds) == 0 {
		return &pb.SyncFileResponse{
			Status: &pb.Status{
				Success: false,
				Message: "En az bir peer belirtilmelidir",
				Code:    400,
			},
		}, nil
	}
	
	// Dosya bilgisini al
	file, err := h.container.FileRepository().GetByID(ctx, req.FileId)
	if err != nil {
		return &pb.SyncFileResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Dosya bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}
	
	// Dosyanın chunk'ları var mı kontrol et
	fileChunks, err := h.container.ChunkRepository().GetFileChunks(ctx, req.FileId)
	if err != nil || len(fileChunks) == 0 {
		log.Printf("  📦 Dosya henüz chunk'lanmamış, chunk'lama başlatılıyor: %s", file.RelativePath)
		
		// Folder bilgisini al (dosya path'i için)
		folder, err := h.container.FolderRepository().GetByID(ctx, file.FolderID)
		if err != nil {
			return &pb.SyncFileResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Folder bulunamadı: %v", err),
					Code:    404,
				},
			}, nil
		}
		
		// Dosya path'ini oluştur
		filePath := filepath.Join(folder.LocalPath, file.RelativePath)
		
		// Dosyayı chunk'la
		_, _, err = h.container.ChunkingUseCase().ChunkAndStoreFile(ctx, req.FileId, filePath)
		if err != nil {
			return &pb.SyncFileResponse{
				Status: &pb.Status{
					Success: false,
					Message: fmt.Sprintf("Dosya chunk'lanamadı: %v", err),
					Code:    500,
				},
			}, nil
		}
		
		log.Printf("  ✅ Dosya chunk'landı: %d chunk", len(fileChunks))
	}
	
	// Her peer için senkronizasyon başlat
	successCount := 0
	var lastError error
	
	for _, peerID := range req.TargetPeerIds {
		log.Printf("  📤 Peer'a gönderiliyor: %s", peerID[:8])
		
		// P2P transfer use case ile senkronize et
		err := h.container.P2PTransferUseCase().SyncFileWithPeer(ctx, peerID, req.FileId)
		if err != nil {
			log.Printf("  ⚠️ Peer'a gönderim hatası (%s): %v", peerID[:8], err)
			lastError = err
			continue
		}
		
		successCount++
		log.Printf("  ✅ Peer'a gönderildi: %s", peerID[:8])
	}
	
	if successCount == 0 {
		return &pb.SyncFileResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Hiçbir peer'a gönderilemedi: %v", lastError),
				Code:    500,
			},
		}, nil
	}
	
	return &pb.SyncFileResponse{
		Status: &pb.Status{
			Success: true,
			Message: fmt.Sprintf("Dosya %d/%d peer'a gönderildi", successCount, len(req.TargetPeerIds)),
			Code:    200,
		},
		Progress: &pb.SyncProgress{
			BytesTransferred: int64(file.Size),
			TotalBytes:       int64(file.Size),
			Percentage:       100.0,
		},
	}, nil
}

// SyncFolder klasörün tüm dosyalarını senkronize eder
func (h *SyncHandler) SyncFolder(ctx context.Context, req *pb.SyncFolderRequest) (*pb.SyncFolderResponse, error) {
	log.Printf("🔄 Klasör senkronize ediliyor: %s -> %d peer", req.FolderId, len(req.TargetPeerIds))
	
	if len(req.TargetPeerIds) == 0 {
		return &pb.SyncFolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: "En az bir peer belirtilmelidir",
				Code:    400,
			},
		}, nil
	}
	
	// Folder bilgisini al
	folder, err := h.container.FolderRepository().GetByID(ctx, req.FolderId)
	if err != nil {
		return &pb.SyncFolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}
	
	// Klasördeki tüm dosyaları al
	files, err := h.container.FileRepository().GetByFolderID(ctx, req.FolderId)
	if err != nil {
		return &pb.SyncFolderResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Dosyalar alınamadı: %v", err),
				Code:    500,
			},
		}, nil
	}
	
	log.Printf("  📁 %d dosya bulundu", len(files))
	
	if len(files) == 0 {
		return &pb.SyncFolderResponse{
			Status: &pb.Status{
				Success: true,
				Message: "Klasörde senkronize edilecek dosya yok",
				Code:    200,
			},
			TotalFiles:  0,
			SyncedFiles: 0,
		}, nil
	}
	
	// Her dosyayı her peer'a gönder
	totalFiles := len(files)
	syncedFiles := 0
	var totalBytes int64
	var lastError error
	
	for _, file := range files {
		// Dosyanın chunk'ları var mı kontrol et
		fileChunks, err := h.container.ChunkRepository().GetFileChunks(ctx, file.ID)
		if err != nil || len(fileChunks) == 0 {
			log.Printf("  📦 Dosya chunk'lanıyor: %s", file.RelativePath)
			
			// Dosya path'ini oluştur
			filePath := filepath.Join(folder.LocalPath, file.RelativePath)
			
			// Dosyayı chunk'la
			_, _, err = h.container.ChunkingUseCase().ChunkAndStoreFile(ctx, file.ID, filePath)
			if err != nil {
				log.Printf("  ⚠️ Dosya chunk'lanamadı (%s): %v", file.RelativePath, err)
				continue
			}
		}
		
		// Her peer'a gönder
		fileSynced := false
		for _, peerID := range req.TargetPeerIds {
			log.Printf("  📤 Dosya gönderiliyor: %s -> %s", file.RelativePath, peerID[:8])
			
			err := h.container.P2PTransferUseCase().SyncFileWithPeer(ctx, peerID, file.ID)
			if err != nil {
				log.Printf("  ⚠️ Dosya gönderilemedi (%s -> %s): %v", file.RelativePath, peerID[:8], err)
				lastError = err
			} else {
				fileSynced = true
				totalBytes += file.Size
			}
		}
		
		if fileSynced {
			syncedFiles++
			log.Printf("  ✅ Dosya senkronize edildi: %s", file.RelativePath)
		}
	}
	
	var statusMessage string
	if syncedFiles == totalFiles {
		statusMessage = fmt.Sprintf("Tüm dosyalar senkronize edildi (%d/%d)", syncedFiles, totalFiles)
	} else {
		statusMessage = fmt.Sprintf("Kısmen senkronize edildi (%d/%d dosya)", syncedFiles, totalFiles)
		if lastError != nil {
			statusMessage += fmt.Sprintf(": %v", lastError)
		}
	}
	
	return &pb.SyncFolderResponse{
		Status: &pb.Status{
			Success: syncedFiles > 0,
			Message: statusMessage,
			Code:    200,
		},
		Progress: &pb.SyncProgress{
			BytesTransferred: totalBytes,
			TotalBytes:       totalBytes,
			Percentage:       float32(syncedFiles) / float32(totalFiles) * 100.0,
		},
		TotalFiles:  int32(totalFiles),
		SyncedFiles: int32(syncedFiles),
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
