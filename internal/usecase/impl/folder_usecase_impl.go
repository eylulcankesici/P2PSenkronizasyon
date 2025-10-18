package impl

import (
	"context"
	"fmt"
	"os"
	
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/usecase"
)

// FolderUseCaseImpl folder use case implementasyonu
type FolderUseCaseImpl struct {
	folderRepo repository.FolderRepository
}

// NewFolderUseCase yeni bir FolderUseCase oluşturur
func NewFolderUseCase(folderRepo repository.FolderRepository) usecase.FolderUseCase {
	return &FolderUseCaseImpl{
		folderRepo: folderRepo,
	}
}

// CreateFolder yeni bir senkronize klasör oluşturur
func (uc *FolderUseCaseImpl) CreateFolder(ctx context.Context, localPath string, syncMode entity.SyncMode) (*entity.Folder, error) {
	// Klasör yolunu doğrula
	if err := uc.ValidateFolderPath(ctx, localPath); err != nil {
		return nil, err
	}
	
	// Aynı path ile klasör var mı kontrol et
	existingFolder, err := uc.folderRepo.GetByPath(ctx, localPath)
	if err == nil && existingFolder != nil {
		return nil, entity.ErrAlreadyExists
	}
	
	// Yeni klasör oluştur
	folder := entity.NewFolder(localPath, syncMode)
	if err := folder.Validate(); err != nil {
		return nil, err
	}
	
	if err := uc.folderRepo.Create(ctx, folder); err != nil {
		return nil, fmt.Errorf("klasör oluşturulamadı: %w", err)
	}
	
	return folder, nil
}

// GetFolder ID'ye göre klasör getirir
func (uc *FolderUseCaseImpl) GetFolder(ctx context.Context, id string) (*entity.Folder, error) {
	folder, err := uc.folderRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	
	return folder, nil
}

// GetAllFolders tüm klasörleri getirir
func (uc *FolderUseCaseImpl) GetAllFolders(ctx context.Context) ([]*entity.Folder, error) {
	folders, err := uc.folderRepo.GetAll(ctx)
	if err != nil {
		return nil, err
	}
	
	return folders, nil
}

// UpdateFolder klasör bilgilerini günceller
func (uc *FolderUseCaseImpl) UpdateFolder(ctx context.Context, folder *entity.Folder) error {
	// Klasörün var olduğunu kontrol et
	existing, err := uc.folderRepo.GetByID(ctx, folder.ID)
	if err != nil {
		return err
	}
	if existing == nil {
		return entity.ErrNotFound
	}
	
	// Doğrula
	if err := folder.Validate(); err != nil {
		return err
	}
	
	// Güncelle
	if err := uc.folderRepo.Update(ctx, folder); err != nil {
		return fmt.Errorf("klasör güncellenemedi: %w", err)
	}
	
	return nil
}

// DeleteFolder klasörü siler
func (uc *FolderUseCaseImpl) DeleteFolder(ctx context.Context, id string) error {
	// Klasörün var olduğunu kontrol et
	folder, err := uc.folderRepo.GetByID(ctx, id)
	if err != nil {
		return err
	}
	if folder == nil {
		return entity.ErrNotFound
	}
	
	// Sil
	if err := uc.folderRepo.Delete(ctx, id); err != nil {
		return fmt.Errorf("klasör silinemedi: %w", err)
	}
	
	return nil
}

// ActivateFolder klasörü aktif hale getirir
func (uc *FolderUseCaseImpl) ActivateFolder(ctx context.Context, id string) error {
	folder, err := uc.folderRepo.GetByID(ctx, id)
	if err != nil {
		return err
	}
	
	folder.Activate()
	
	if err := uc.folderRepo.Update(ctx, folder); err != nil {
		return fmt.Errorf("klasör aktif edilemedi: %w", err)
	}
	
	return nil
}

// DeactivateFolder klasörü pasif hale getirir
func (uc *FolderUseCaseImpl) DeactivateFolder(ctx context.Context, id string) error {
	folder, err := uc.folderRepo.GetByID(ctx, id)
	if err != nil {
		return err
	}
	
	folder.Deactivate()
	
	if err := uc.folderRepo.Update(ctx, folder); err != nil {
		return fmt.Errorf("klasör pasif edilemedi: %w", err)
	}
	
	return nil
}

// ValidateFolderPath klasör yolunun geçerliliğini kontrol eder
func (uc *FolderUseCaseImpl) ValidateFolderPath(ctx context.Context, path string) error {
	if path == "" {
		return entity.ErrInvalidPath
	}
	
	// Klasörün var olduğunu kontrol et
	info, err := os.Stat(path)
	if err != nil {
		if os.IsNotExist(err) {
			return fmt.Errorf("klasör mevcut değil: %s", path)
		}
		return fmt.Errorf("klasör bilgisi alınamadı: %w", err)
	}
	
	// Dizin olduğunu kontrol et
	if !info.IsDir() {
		return fmt.Errorf("yol bir dizin değil: %s", path)
	}
	
	// Yazılabilir olduğunu kontrol et
	testFile := fmt.Sprintf("%s/.aether_test", path)
	f, err := os.Create(testFile)
	if err != nil {
		return fmt.Errorf("klasör yazılabilir değil: %w", err)
	}
	f.Close()
	os.Remove(testFile)
	
	return nil
}





