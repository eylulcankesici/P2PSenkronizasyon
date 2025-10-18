package entity

import (
	"time"
)

// File senkronize edilen bir dosyayı temsil eder
type File struct {
	ID           string
	FolderID     string
	RelativePath string    // Klasör içindeki relative path
	Size         int64     // Dosya boyutu (bytes)
	ModTime      time.Time // Son değişiklik zamanı
	GlobalHash   string    // Tüm dosyanın SHA-256 hash'i
	ChunkCount   int       // Dosyanın kaç chunk'a bölündüğü
	IsDeleted    bool      // Soft delete için
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// NewFile yeni bir File oluşturur
func NewFile(folderID, relativePath string, size int64, modTime time.Time) *File {
	now := time.Now()
	return &File{
		FolderID:     folderID,
		RelativePath: relativePath,
		Size:         size,
		ModTime:      modTime,
		IsDeleted:    false,
		CreatedAt:    now,
		UpdatedAt:    now,
	}
}

// Validate dosyanın geçerliliğini kontrol eder
func (f *File) Validate() error {
	if f.FolderID == "" {
		return ErrInvalidFolderID
	}
	
	if f.RelativePath == "" {
		return ErrInvalidPath
	}
	
	if f.Size < 0 {
		return ErrInvalidFileSize
	}
	
	return nil
}

// UpdateHash dosyanın global hash'ini günceller
func (f *File) UpdateHash(hash string, chunkCount int) {
	f.GlobalHash = hash
	f.ChunkCount = chunkCount
	f.UpdatedAt = time.Now()
}

// MarkAsDeleted dosyayı silinmiş olarak işaretler
func (f *File) MarkAsDeleted() {
	f.IsDeleted = true
	f.UpdatedAt = time.Now()
}

// IsModified dosyanın değiştirilip değiştirilmediğini kontrol eder
func (f *File) IsModified(modTime time.Time, size int64) bool {
	return !f.ModTime.Equal(modTime) || f.Size != size
}




