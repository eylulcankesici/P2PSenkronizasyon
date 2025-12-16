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
			Code:    501, // Not Implemented
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

	// Dosya bilgilerini sakla (silme işleminden sonra kullanmak için)
	folderID := file.FolderID
	relativePath := file.RelativePath

	// ÖNEMLİ: Dosya silinmeden ÖNCE peer'lara silme bildirimi gönder
	// (dosya silindikten sonra file_peer_sync kayıtları CASCADE ile silinir)
	// Bu, hem gönderici hem de alıcı tarafında çift yönlü senkronizasyon için gereklidir
	if folder != nil {
		log.Printf("🔄 Dosya silinmeden önce peer'lara silme bildirimi gönderiliyor: %s", req.FileId[:8])
		if err := h.container.DeleteFileFromAllPeers(req.FileId, file.FolderID); err != nil {
			log.Printf("⚠️ Peer'lara silme bildirimi gönderilemedi: %v (devam ediliyor)", err)
			// Hata olsa bile silme işlemine devam et
		}
	}

	// FİZİKSEL dosyayı SİL mi yoksa KORU mu?
	// KURAL: Kullanıcı seçimine göre karar ver (req.DeletePhysically)
	//   - delete_physically = true → Bilgisayardan tamamen kaldır (hem fiziksel dosya hem veritabanından tamamen sil)
	//   - delete_physically = false → Sadece uygulamadan kaldır (veritabanından tamamen sil, fiziksel dosya korunur)

	if req.DeletePhysically {
		// Fiziksel dosyayı sil
		if folder != nil && folder.LocalPath != "" && file.RelativePath != "" {
			filePath := filepath.Join(folder.LocalPath, file.RelativePath)
			log.Printf("🗑️ Kullanıcı seçimi: Dosya bilgisayardan tamamen kaldırılıyor: %s", filePath)
			if err := os.Remove(filePath); err != nil {
				log.Printf("⚠️ Fiziksel dosya silinemedi (%s): %v", filePath, err)
				// Devam et, veritabanından silmeye çalış
			} else {
				log.Printf("✅ Fiziksel dosya silindi: %s", filePath)
			}
		}

		// Veritabanından tamamen sil (HARD DELETE) - CASCADE olduğu için file_chunks ve file_peer_sync de silinir
		if err := h.container.FileRepository().HardDelete(ctx, req.FileId); err != nil {
			return &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Dosya veritabanından silinemedi: %v", err),
				Code:    500,
			}, nil
		}
		log.Printf("✅ Dosya veritabanından tamamen silindi (hard delete): %s", req.FileId[:8])

		// Fiziksel dosya zaten silindi (req.DeletePhysically = true), ignore listesine eklemeye gerek yok
		// Çünkü fiziksel dosya yok, file watcher CREATE event'i tetiklenmez

		// Yetim chunk'ları temizle (hiçbir dosya tarafından kullanılmayan chunk'lar) - hem disk hem DB'den
		if deletedCount, err := h.container.ChunkingUseCase().DeleteOrphanedChunks(ctx); err != nil {
			log.Printf("⚠️ Yetim chunk'lar temizlenemedi: %v", err)
			// Hata olsa bile devam et, dosya silme işlemi başarılı
		} else if deletedCount > 0 {
			log.Printf("🧹 %d yetim chunk temizlendi (disk + DB)", deletedCount)
		}

		return &pb.Status{
			Success: true,
			Message: "Dosya başarıyla silindi (veritabanı + fiziksel dosya)",
			Code:    200,
		}, nil
	} else {
		// Kullanıcı sadece uygulamadan kaldırmayı seçti → Veritabanından tamamen sil, fiziksel dosya korunur
		// Veritabanından tamamen sil (HARD DELETE) - CASCADE olduğu için file_chunks ve file_peer_sync de silinir
		// FİZİKSEL dosya korunur (silmeyiz)
		if err := h.container.FileRepository().HardDelete(ctx, req.FileId); err != nil {
			return &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Dosya veritabanından silinemedi: %v", err),
				Code:    500,
			}, nil
		}
		log.Printf("✅ Dosya veritabanından tamamen silindi (fiziksel dosya korundu): %s", req.FileId[:8])

		// Fiziksel dosya hala disk'te olduğu için, file watcher'ın onu tekrar eklememesi için ignore listesine ekle
		// (Dosya silindikten sonra file değişkeni kullanılamaz, bu yüzden önceden saklanan değerleri kullan)
		if relativePath != "" {
			if eventHandler := h.container.EventHandler(); eventHandler != nil {
				eventHandler.IgnoreFile(folderID, relativePath)
			} else {
				log.Printf("⚠️ EventHandler nil, ignore listesine eklenemedi: %s", relativePath)
			}
		}

		// Yetim chunk'ları temizle (hiçbir dosya tarafından kullanılmayan chunk'lar) - hem disk hem DB'den
		if deletedCount, err := h.container.ChunkingUseCase().DeleteOrphanedChunks(ctx); err != nil {
			log.Printf("⚠️ Yetim chunk'lar temizlenemedi: %v", err)
			// Hata olsa bile devam et, dosya silme işlemi başarılı
		} else if deletedCount > 0 {
			log.Printf("🧹 %d yetim chunk temizlendi (disk + DB)", deletedCount)
		}

		return &pb.Status{
			Success: true,
			Message: "Dosya uygulamadan kaldırıldı (fiziksel dosya korundu)",
			Code:    200,
		}, nil
	}
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

// GetFileInfo dosya detay bilgisi getirir
func (h *FileHandler) GetFileInfo(ctx context.Context, req *pb.GetFileInfoRequest) (*pb.FileInfoResponse, error) {
	// Dosya bilgisini al
	file, err := h.container.FileRepository().GetByID(ctx, req.FileId)
	if err != nil {
		return &pb.FileInfoResponse{
			Status: &pb.Status{
				Success: false,
				Message: fmt.Sprintf("Dosya bulunamadı: %v", err),
				Code:    404,
			},
		}, nil
	}

	// Sync bilgilerini al (hangi peer'larla senkronize edilmiş)
	syncs, err := h.container.FilePeerSyncRepository().GetByFileID(ctx, req.FileId)
	if err != nil {
		log.Printf("⚠️ Sync bilgileri alınamadı: %v", err)
		syncs = []*entity.FilePeerSync{} // Boş liste döndür
	}

	// Kendi device ID'mizi al (gönderen/alıcı belirleme için)
	currentDeviceID, _ := h.container.GetDeviceID()
	currentDeviceName := h.container.GetDeviceName()

	// Sync bilgilerini proto'ya dönüştür
	syncInfos := make([]*pb.FilePeerSyncInfo, 0, len(syncs))
	for _, sync := range syncs {
		// Peer bilgisini al (karşı taraf)
		peer, err := h.container.PeerRepository().GetByID(ctx, sync.PeerID)
		peerName := sync.PeerID[:8] // Fallback
		if err == nil && peer != nil {
			peerName = peer.Name
		}

		// Sender device bilgisini al
		senderDeviceName := sync.SenderDeviceID[:8] // Fallback
		if sync.SenderDeviceID == currentDeviceID {
			senderDeviceName = currentDeviceName
		} else {
			senderPeer, err := h.container.PeerRepository().GetByID(ctx, sync.SenderDeviceID)
			if err == nil && senderPeer != nil {
				senderDeviceName = senderPeer.Name
			}
		}

		// Receiver device bilgisini belirle
		// Eğer biz gönderen isek: receiver = peerID (alıcı)
		// Eğer biz alıcı isek: receiver = currentDeviceID (biz)
		receiverDeviceID := sync.PeerID
		receiverDeviceName := peerName
		if sync.SenderDeviceID == currentDeviceID {
			// Biz göndereniz, receiver = peerID (alıcı)
			receiverDeviceID = sync.PeerID
			receiverDeviceName = peerName
		} else {
			// Biz alıcıyız, receiver = biz
			receiverDeviceID = currentDeviceID
			receiverDeviceName = currentDeviceName
		}

		syncInfos = append(syncInfos, &pb.FilePeerSyncInfo{
			PeerId:             sync.PeerID,
			PeerName:           peerName,
			SenderDeviceId:     sync.SenderDeviceID,
			SenderDeviceName:   senderDeviceName,
			ReceiverDeviceId:   receiverDeviceID,
			ReceiverDeviceName: receiverDeviceName,
			SyncedAt:           timestamppb.New(sync.SyncedAt),
		})
	}

	return &pb.FileInfoResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Dosya bilgileri başarıyla getirildi",
			Code:    200,
		},
		File:     convertFileToProto(file),
		SyncInfo: syncInfos,
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
