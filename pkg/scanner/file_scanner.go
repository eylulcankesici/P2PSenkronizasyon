package scanner

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// FileScanner dosya sistemi tarama için yardımcı
type FileScanner struct {
	ignorePatterns []string
}

// NewFileScanner yeni bir FileScanner oluşturur
func NewFileScanner() *FileScanner {
	return &FileScanner{
		ignorePatterns: []string{
			".aether_versions",
			".git",
			".DS_Store",
			"Thumbs.db",
			"desktop.ini",
		},
	}
}

// ScanResult tarama sonucu
type ScanResult struct {
	Path    string
	Size    int64
	ModTime int64
	IsDir   bool
}

// ScanDirectory dizini tarar ve dosya listesi döner
func (s *FileScanner) ScanDirectory(rootPath string) ([]*ScanResult, error) {
	results := make([]*ScanResult, 0)
	
	err := filepath.Walk(rootPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		
		// Görmezden gelinecek dosyaları atla
		if s.shouldIgnore(path) {
			if info.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}
		
		// Sadece dosyaları ekle (dizinleri değil)
		if !info.IsDir() {
			relativePath, err := filepath.Rel(rootPath, path)
			if err != nil {
				return err
			}
			
			result := &ScanResult{
				Path:    relativePath,
				Size:    info.Size(),
				ModTime: info.ModTime().Unix(),
				IsDir:   false,
			}
			
			results = append(results, result)
		}
		
		return nil
	})
	
	if err != nil {
		return nil, fmt.Errorf("dizin taranamadı: %w", err)
	}
	
	return results, nil
}

// shouldIgnore dosyanın görmezden gelinip gelinmeyeceğini kontrol eder
func (s *FileScanner) shouldIgnore(path string) bool {
	baseName := filepath.Base(path)
	
	for _, pattern := range s.ignorePatterns {
		if strings.Contains(baseName, pattern) {
			return true
		}
	}
	
	return false
}

// AddIgnorePattern görmezden gelinecek pattern ekler
func (s *FileScanner) AddIgnorePattern(pattern string) {
	s.ignorePatterns = append(s.ignorePatterns, pattern)
}





