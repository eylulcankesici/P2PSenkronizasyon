package entity

import (
	"time"
)

// FileVersion dosyanın bir önceki versiyonunu temsil eder
// Rollback mekanizması için kullanılır
type FileVersion struct {
	ID               string
	FileID           string
	VersionNumber    int       // Versiyon numarası (1, 2, 3...)
	BackupPath       string    // .aether_versions/ içindeki yedek dosyanın yolu
	OriginalPath     string    // Orijinal dosya yolu
	Size             int64
	Hash             string
	CreatedAt        time.Time // Yedekleme zamanı
	CreatedByPeerID  string    // Hangi peer tarafından oluşturuldu
}

// NewFileVersion yeni bir FileVersion oluşturur
func NewFileVersion(fileID, backupPath, originalPath string, versionNumber int, size int64, hash string, peerID string) *FileVersion {
	return &FileVersion{
		FileID:          fileID,
		VersionNumber:   versionNumber,
		BackupPath:      backupPath,
		OriginalPath:    originalPath,
		Size:            size,
		Hash:            hash,
		CreatedAt:       time.Now(),
		CreatedByPeerID: peerID,
	}
}

// Validate versiyonun geçerliliğini kontrol eder
func (v *FileVersion) Validate() error {
	if v.FileID == "" {
		return ErrInvalidFileID
	}
	
	if v.BackupPath == "" || v.OriginalPath == "" {
		return ErrInvalidPath
	}
	
	if v.VersionNumber <= 0 {
		return ErrInvalidVersionNumber
	}
	
	return nil
}





