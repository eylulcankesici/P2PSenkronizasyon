package impl

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"time"
	
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/usecase"
	"github.com/aether/sync/pkg/hashing"
)

const (
	// VersionsDir versiyon yedeklerinin saklandığı dizin adı
	VersionsDir = ".aether_versions"
)

// VersionUseCaseImpl version use case implementasyonu
type VersionUseCaseImpl struct {
	versionRepo repository.VersionRepository
	fileRepo    repository.FileRepository
	folderRepo  repository.FolderRepository
	hasher      *hashing.Hasher
}

// NewVersionUseCase yeni bir VersionUseCase oluşturur
func NewVersionUseCase(
	versionRepo repository.VersionRepository,
	fileRepo repository.FileRepository,
	folderRepo repository.FolderRepository,
) usecase.VersionUseCase {
	return &VersionUseCaseImpl{
		versionRepo: versionRepo,
		fileRepo:    fileRepo,
		folderRepo:  folderRepo,
		hasher:      hashing.NewHasher(),
	}
}

// CreateVersion dosya için yeni bir versiyon oluşturur
func (uc *VersionUseCaseImpl) CreateVersion(ctx context.Context, fileID, originalPath string) (*entity.FileVersion, error) {
	// Dosyayı al
	file, err := uc.fileRepo.GetByID(ctx, fileID)
	if err != nil {
		return nil, fmt.Errorf("dosya bulunamadı: %w", err)
	}
	
	// Klasörü al
	folder, err := uc.folderRepo.GetByID(ctx, file.FolderID)
	if err != nil {
		return nil, fmt.Errorf("klasör bulunamadı: %w", err)
	}
	
	// Versiyon dizinini oluştur
	versionsDir := filepath.Join(folder.LocalPath, VersionsDir)
	if err := os.MkdirAll(versionsDir, 0755); err != nil {
		return nil, fmt.Errorf("versiyon dizini oluşturulamadı: %w", err)
	}
	
	// Mevcut versiyon sayısını al
	versionCount, err := uc.versionRepo.GetTotalVersionCount(ctx, fileID)
	if err != nil {
		versionCount = 0
	}
	
	// Yeni versiyon numarası
	newVersionNumber := versionCount + 1
	
	// Yedek dosya yolu
	timestamp := time.Now().Format("20060102_150405")
	backupFileName := fmt.Sprintf("%s_v%d_%s", file.ID, newVersionNumber, timestamp)
	backupPath := filepath.Join(versionsDir, backupFileName)
	
	// Orijinal dosyayı yedekle
	if err := uc.copyFile(originalPath, backupPath); err != nil {
		return nil, fmt.Errorf("dosya yedeklenemedi: %w", err)
	}
	
	// Dosya hash'ini hesapla
	fileHash, err := uc.hasher.HashFile(backupPath)
	if err != nil {
		return nil, fmt.Errorf("hash hesaplanamadı: %w", err)
	}
	
	// Dosya boyutunu al
	fileInfo, err := os.Stat(backupPath)
	if err != nil {
		return nil, fmt.Errorf("dosya bilgisi alınamadı: %w", err)
	}
	
	// Versiyon entity'si oluştur
	version := entity.NewFileVersion(
		fileID,
		backupPath,
		originalPath,
		newVersionNumber,
		fileInfo.Size(),
		fileHash,
		"", // Peer ID burada ayarlanabilir
	)
	
	if err := version.Validate(); err != nil {
		// Yedek dosyayı temizle
		os.Remove(backupPath)
		return nil, err
	}
	
	// Veritabanına kaydet
	if err := uc.versionRepo.Create(ctx, version); err != nil {
		// Yedek dosyayı temizle
		os.Remove(backupPath)
		return nil, fmt.Errorf("versiyon kaydedilemedi: %w", err)
	}
	
	return version, nil
}

// GetVersions dosyanın tüm versiyonlarını getirir
func (uc *VersionUseCaseImpl) GetVersions(ctx context.Context, fileID string) ([]*entity.FileVersion, error) {
	versions, err := uc.versionRepo.GetByFileID(ctx, fileID)
	if err != nil {
		return nil, fmt.Errorf("versiyonlar alınamadı: %w", err)
	}
	
	return versions, nil
}

// RestoreVersion dosyayı belirli bir versiyona geri yükler
func (uc *VersionUseCaseImpl) RestoreVersion(ctx context.Context, versionID string) error {
	// Versiyonu al
	version, err := uc.versionRepo.GetByID(ctx, versionID)
	if err != nil {
		return fmt.Errorf("versiyon bulunamadı: %w", err)
	}
	
	// Dosyayı al
	file, err := uc.fileRepo.GetByID(ctx, version.FileID)
	if err != nil {
		return fmt.Errorf("dosya bulunamadı: %w", err)
	}
	
	// Klasörü al
	folder, err := uc.folderRepo.GetByID(ctx, file.FolderID)
	if err != nil {
		return fmt.Errorf("klasör bulunamadı: %w", err)
	}
	
	// Orijinal dosya yolu
	originalPath := filepath.Join(folder.LocalPath, file.RelativePath)
	
	// Mevcut dosyayı yedekle (restore öncesi)
	if _, err := os.Stat(originalPath); err == nil {
		if _, err := uc.CreateVersion(ctx, file.ID, originalPath); err != nil {
			return fmt.Errorf("mevcut dosya yedeklenemedi: %w", err)
		}
	}
	
	// Yedek dosyayı orijinal konuma kopyala
	if err := uc.copyFile(version.BackupPath, originalPath); err != nil {
		return fmt.Errorf("dosya geri yüklenemedi: %w", err)
	}
	
	// Dosya bilgilerini güncelle
	fileInfo, err := os.Stat(originalPath)
	if err != nil {
		return fmt.Errorf("dosya bilgisi alınamadı: %w", err)
	}
	
	file.Size = fileInfo.Size()
	file.ModTime = fileInfo.ModTime()
	file.GlobalHash = version.Hash
	
	if err := uc.fileRepo.Update(ctx, file); err != nil {
		return fmt.Errorf("dosya bilgisi güncellenemedi: %w", err)
	}
	
	return nil
}

// DeleteVersion belirli bir versiyonu siler
func (uc *VersionUseCaseImpl) DeleteVersion(ctx context.Context, versionID string) error {
	// Versiyonu al
	version, err := uc.versionRepo.GetByID(ctx, versionID)
	if err != nil {
		return fmt.Errorf("versiyon bulunamadı: %w", err)
	}
	
	// Yedek dosyayı sil
	if err := os.Remove(version.BackupPath); err != nil && !os.IsNotExist(err) {
		return fmt.Errorf("yedek dosya silinemedi: %w", err)
	}
	
	// Veritabanından sil
	if err := uc.versionRepo.Delete(ctx, versionID); err != nil {
		return fmt.Errorf("versiyon kaydı silinemedi: %w", err)
	}
	
	return nil
}

// CleanupOldVersions eski versiyonları temizler
func (uc *VersionUseCaseImpl) CleanupOldVersions(ctx context.Context, fileID string, keepCount int) error {
	// Silinecek versiyonları bul
	versions, err := uc.versionRepo.GetByFileID(ctx, fileID)
	if err != nil {
		return fmt.Errorf("versiyonlar alınamadı: %w", err)
	}
	
	if len(versions) <= keepCount {
		return nil // Silinecek versiyon yok
	}
	
	// Eski versiyonları sil (en yeniler başta gelir)
	for i := keepCount; i < len(versions); i++ {
		if err := uc.DeleteVersion(ctx, versions[i].ID); err != nil {
			return fmt.Errorf("versiyon silinemedi: %w", err)
		}
	}
	
	return nil
}

// GetVersionInfo versiyon detay bilgisini getirir
func (uc *VersionUseCaseImpl) GetVersionInfo(ctx context.Context, versionID string) (*usecase.VersionInfo, error) {
	version, err := uc.versionRepo.GetByID(ctx, versionID)
	if err != nil {
		return nil, fmt.Errorf("versiyon bulunamadı: %w", err)
	}
	
	// Yedek dosyanın var olup olmadığını kontrol et
	backupExists := false
	sizeOnDisk := int64(0)
	
	if info, err := os.Stat(version.BackupPath); err == nil {
		backupExists = true
		sizeOnDisk = info.Size()
	}
	
	versionInfo := &usecase.VersionInfo{
		Version:      version,
		CanRestore:   backupExists,
		BackupExists: backupExists,
		SizeOnDisk:   sizeOnDisk,
	}
	
	return versionInfo, nil
}

// copyFile dosyayı kopyalar
func (uc *VersionUseCaseImpl) copyFile(src, dst string) error {
	sourceFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer sourceFile.Close()
	
	destFile, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer destFile.Close()
	
	if _, err := destFile.ReadFrom(sourceFile); err != nil {
		return err
	}
	
	// Dosya izinlerini kopyala
	sourceInfo, err := os.Stat(src)
	if err != nil {
		return err
	}
	
	return os.Chmod(dst, sourceInfo.Mode())
}





