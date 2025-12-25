package grpc

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
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

	// 📂 File watcher'a otomatik ekle (real-time sync için)
	if h.container.FileWatcher() != nil {
		if err := h.container.FileWatcher().AddFolder(folder); err != nil {
			log.Printf("⚠️ Klasör file watcher'a eklenemedi (manuel ekleme gerekebilir): %v", err)
		} else {
			log.Printf("✅ Klasör otomatik olarak file watcher'a eklendi: %s", folder.LocalPath)
		}
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
		protoFolder := convertFolderToProto(folder)
		
		// Dosya sayısını ve boyutunu hesapla
		files, err := h.container.FileRepository().GetByFolderID(ctx, folder.ID)
		if err == nil {
			var totalSize int64
			var fileCount int32
			for _, file := range files {
				totalSize += file.Size
				fileCount++
			}
			protoFolder.SizeBytes = totalSize
			protoFolder.FileCount = fileCount
		}
		
		protoFolders[i] = protoFolder
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
	log.Printf("🗑️ Klasör siliniyor: %s", req.Id[:8])

	// Önce folder bilgisini al (fiziksel path için)
	folder, err := h.container.FolderRepository().GetByID(ctx, req.Id)
	if err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Klasör bulunamadı: %v", err),
			Code:    404,
		}, nil
	}

	// File watcher'dan kaldır (folder silinmeden önce)
	if h.container.FileWatcher() != nil {
		if err := h.container.FileWatcher().RemoveFolder(req.Id); err != nil {
			log.Printf("⚠️ Klasör file watcher'dan kaldırılamadı: %v", err)
		} else {
			log.Printf("✅ Klasör file watcher'dan kaldırıldı: %s", req.Id[:8])
		}
	}

	// ÖNEMLİ: Klasör silinmeden ÖNCE içindeki tüm dosyaları manuel olarak sil
	// (CASCADE DELETE güvenilir değil, manuel silme daha güvenli)
	files, err := h.container.FileRepository().GetByFolderID(ctx, req.Id)
	if err != nil {
		log.Printf("⚠️ Klasördeki dosyalar alınamadı: %v (devam ediliyor)", err)
		files = []*entity.File{}
	}

	if len(files) > 0 {
		log.Printf("🗑️ Klasördeki %d dosya siliniyor: %s", len(files), req.Id[:8])

		for _, file := range files {
			// Peer'lara silme bildirimi gönder (dosya silinmeden önce)
			if err := h.container.DeleteFileFromAllPeers(file.ID, file.FolderID); err != nil {
				log.Printf("⚠️ Dosya için peer'lara silme bildirimi gönderilemedi (%s): %v (devam ediliyor)", file.ID[:8], err)
			}

			// Dosyayı veritabanından tamamen sil (HARD DELETE)
			if err := h.container.FileRepository().HardDelete(ctx, file.ID); err != nil {
				log.Printf("⚠️ Dosya silinemedi (%s): %v (devam ediliyor)", file.ID[:8], err)
				continue
			}

			// Eğer fiziksel dosya korunacaksa (deletePhysically = false), ignore listesine ekle
			if !req.DeletePhysically && file.RelativePath != "" {
				if eventHandler := h.container.EventHandler(); eventHandler != nil {
					eventHandler.IgnoreFile(file.FolderID, file.RelativePath)
				}
			}
		}

		// Yetim chunk'ları temizle (hiçbir dosya tarafından kullanılmayan chunk'lar)
		if deletedCount, err := h.container.ChunkingUseCase().DeleteOrphanedChunks(ctx); err != nil {
			log.Printf("⚠️ Yetim chunk'lar temizlenemedi: %v", err)
		} else if deletedCount > 0 {
			log.Printf("🧹 %d yetim chunk temizlendi (disk + DB)", deletedCount)
		}

		log.Printf("✅ %d dosya silindi: %s", len(files), req.Id[:8])
	}

	// FİZİKSEL klasörü SİL mi yoksa KORU mu?
	// KURAL: Kullanıcı seçimine göre karar ver (req.DeletePhysically)
	//   - delete_physically = true → Bilgisayardan tamamen kaldır (hem fiziksel klasör hem veritabanından tamamen sil)
	//   - delete_physically = false → Sadece uygulamadan kaldır (veritabanından tamamen sil, fiziksel klasör korunur)

	// Veritabanından tamamen sil (HARD DELETE) - Dosyalar zaten silindi
	if err := h.container.FolderRepository().Delete(ctx, req.Id); err != nil {
		return &pb.Status{
			Success: false,
			Message: fmt.Sprintf("Klasör veritabanından silinemedi: %v", err),
			Code:    500,
		}, nil
	}
	log.Printf("✅ Klasör veritabanından tamamen silindi (hard delete): %s", req.Id[:8])

	if req.DeletePhysically {
		// Kullanıcı bilgisayardan tamamen kaldırmayı seçti
		log.Printf("🗑️ Kullanıcı seçimi: Klasör bilgisayardan tamamen kaldırılıyor: %s", folder.LocalPath)

		// Desktop symlink'ini sil (varsa - sadece received folder'lar için)
		if h.container.SymlinkManager() != nil && folder.Source == entity.FolderSourceReceived {
			folderName := filepath.Base(folder.LocalPath)
			if err := h.container.SymlinkManager().RemoveDesktopSymlink(folderName); err != nil {
				log.Printf("⚠️ Desktop symlink silinemedi: %v", err)
			} else {
				log.Printf("🔗 Desktop symlink silindi: %s", folderName)
			}
		}

		// Fiziksel klasörü sil
		if err := os.RemoveAll(folder.LocalPath); err != nil {
			log.Printf("⚠️ Fiziksel klasör silinemedi (%s): %v", folder.LocalPath, err)
			return &pb.Status{
				Success: true,
				Message: fmt.Sprintf("Klasör veritabanından silindi ama fiziksel klasör silinemedi: %v", err),
				Code:    200,
			}, nil
		}
		log.Printf("✅ Fiziksel klasör silindi: %s", folder.LocalPath)

		return &pb.Status{
			Success: true,
			Message: "Klasör başarıyla silindi (veritabanı + fiziksel dosyalar)",
			Code:    200,
		}, nil
	} else {
		// Kullanıcı sadece uygulamadan kaldırmayı seçti → Fiziksel dosyalar korunur
		log.Printf("📁 Kullanıcı seçimi: Klasör sadece uygulamadan kaldırıldı (fiziksel dosyalar korundu): %s", folder.LocalPath)

		return &pb.Status{
			Success: true,
			Message: "Klasör uygulamadan kaldırıldı (fiziksel dosyalar korundu)",
			Code:    200,
		}, nil
	}
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
	case pb.SyncMode_SYNC_MODE_UNSPECIFIED:
		return entity.SyncModeUnspecified
	default:
		// Bilinmeyen değer için UNSPECIFIED döndür (varsayılan olarak belirlenmemiş)
		return entity.SyncModeUnspecified
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
	case entity.SyncModeUnspecified:
		return pb.SyncMode_SYNC_MODE_UNSPECIFIED
	default:
		// Boş veya bilinmeyen değer için UNSPECIFIED döndür
		return pb.SyncMode_SYNC_MODE_UNSPECIFIED
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
		// Parent ID çözümle
		parentID := ""
		parentPath := filepath.Dir(result.Path)
		if parentPath != "." && parentPath != string(filepath.Separator) {
			parentPath = filepath.ToSlash(parentPath)
			if parentFile, err := h.container.FileRepository().GetByPath(ctx, folder.ID, parentPath); err == nil {
				parentID = parentFile.ID
			}
		}

		// File entity oluştur
		file := entity.NewFile(
			folder.ID,
			parentID,
			result.Path,
			result.Size,
			time.Unix(result.ModTime, 0),
			result.IsDir, // isDirectory
		)

		// Veritabanına kaydet
		if err := h.container.FileRepository().Create(ctx, file); err != nil {
			log.Printf("⚠️ Dosya kaydedilemedi (%s): %v", result.Path, err)
			continue
		}
		savedCount++

		// 🔍 Dosyayı/Klasörü bağlı peer'lara senkronize et (Async)
		// Bunu arka planda yapıyoruz ki klasör oluşturma işlemi peer bağlantısından bağımsız hızlı bitsin
		go func(fID, folID string) {
			if err := h.container.SyncFileToAllPeers(fID, folID); err != nil {
				log.Printf("⚠️ Initial sync hatası (file: %s): %v", fID, err)
			}
		}(file.ID, folder.ID)
	}

	// Folder'ın LastScanTime'ını güncelle
	folder.UpdateScanTime()
	if err := h.container.FolderRepository().Update(ctx, folder); err != nil {
		log.Printf("⚠️ LastScanTime güncellenemedi: %v", err)
	}

	return savedCount, nil
}
