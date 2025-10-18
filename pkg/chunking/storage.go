package chunking

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
)

// ChunkStorage chunk'ları disk'e yazma/okuma interface'i
// Interface Segregation: Sadece storage işlemleri
// Dependency Inversion: Implementation detayları gizli
type ChunkStorage interface {
	// Store chunk'ı disk'e kaydeder
	Store(hash string, data []byte) error
	
	// Load chunk'ı disk'ten okur
	Load(hash string) ([]byte, error)
	
	// Exists chunk'ın disk'te olup olmadığını kontrol eder
	Exists(hash string) bool
	
	// Delete chunk'ı disk'ten siler
	Delete(hash string) error
	
	// GetPath chunk'ın disk yolunu döndürür
	GetPath(hash string) string
}

// FileSystemChunkStorage chunk'ları dosya sisteminde saklar
// Single Responsibility: Sadece file system operations
type FileSystemChunkStorage struct {
	baseDir string // Chunk'ların saklandığı ana dizin
}

// NewFileSystemChunkStorage yeni bir FileSystemChunkStorage oluşturur
func NewFileSystemChunkStorage(baseDir string) (*FileSystemChunkStorage, error) {
	// Base directory oluştur
	if err := os.MkdirAll(baseDir, 0755); err != nil {
		return nil, fmt.Errorf("chunk dizini oluşturulamadı: %w", err)
	}

	return &FileSystemChunkStorage{
		baseDir: baseDir,
	}, nil
}

// Store chunk'ı disk'e kaydeder
// Content-addressable storage: Hash = filename
func (s *FileSystemChunkStorage) Store(hash string, data []byte) error {
	if hash == "" {
		return fmt.Errorf("hash boş olamaz")
	}

	// Chunk zaten varsa skip et (deduplication)
	if s.Exists(hash) {
		return nil
	}

	// Subdirectory oluştur (ilk 2 karakter)
	// Örnek: hash = "abc123..." -> chunks/ab/abc123...
	// Bu yaklaşım çok sayıda dosyayı daha iyi organize eder
	subDir := s.getSubDirectory(hash)
	if err := os.MkdirAll(subDir, 0755); err != nil {
		return fmt.Errorf("alt dizin oluşturulamadı: %w", err)
	}

	// Chunk dosyasını oluştur
	filePath := s.GetPath(hash)
	file, err := os.Create(filePath)
	if err != nil {
		return fmt.Errorf("chunk dosyası oluşturulamadı: %w", err)
	}
	defer file.Close()

	// Veriyi yaz
	if _, err := file.Write(data); err != nil {
		// Hata durumunda dosyayı sil
		os.Remove(filePath)
		return fmt.Errorf("chunk yazılamadı: %w", err)
	}

	// Sync (disk'e flush)
	if err := file.Sync(); err != nil {
		return fmt.Errorf("chunk sync başarısız: %w", err)
	}

	return nil
}

// Load chunk'ı disk'ten okur
func (s *FileSystemChunkStorage) Load(hash string) ([]byte, error) {
	if hash == "" {
		return nil, fmt.Errorf("hash boş olamaz")
	}

	// Dosya var mı kontrol et
	if !s.Exists(hash) {
		return nil, fmt.Errorf("chunk bulunamadı: %s", hash)
	}

	// Dosyayı aç
	filePath := s.GetPath(hash)
	file, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("chunk dosyası açılamadı: %w", err)
	}
	defer file.Close()

	// Tüm veriyi oku
	data, err := io.ReadAll(file)
	if err != nil {
		return nil, fmt.Errorf("chunk okunamadı: %w", err)
	}

	return data, nil
}

// Exists chunk'ın disk'te olup olmadığını kontrol eder
func (s *FileSystemChunkStorage) Exists(hash string) bool {
	if hash == "" {
		return false
	}

	filePath := s.GetPath(hash)
	_, err := os.Stat(filePath)
	return err == nil
}

// Delete chunk'ı disk'ten siler
func (s *FileSystemChunkStorage) Delete(hash string) error {
	if hash == "" {
		return fmt.Errorf("hash boş olamaz")
	}

	if !s.Exists(hash) {
		return nil // Zaten yok
	}

	filePath := s.GetPath(hash)
	if err := os.Remove(filePath); err != nil {
		return fmt.Errorf("chunk silinemedi: %w", err)
	}

	return nil
}

// GetPath chunk'ın disk yolunu döndürür
// Content-addressable: chunks/ab/abcdef123...
func (s *FileSystemChunkStorage) GetPath(hash string) string {
	if len(hash) < 2 {
		return filepath.Join(s.baseDir, hash)
	}

	// İlk 2 karakter subdirectory
	subDir := hash[:2]
	return filepath.Join(s.baseDir, subDir, hash)
}

// getSubDirectory subdirectory yolunu döndürür
func (s *FileSystemChunkStorage) getSubDirectory(hash string) string {
	if len(hash) < 2 {
		return s.baseDir
	}

	subDir := hash[:2]
	return filepath.Join(s.baseDir, subDir)
}

