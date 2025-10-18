package reassembly

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"sync"

	"github.com/aether/sync/internal/domain/entity"
)

// ChunkData chunk verisi ve index bilgisi
type ChunkData struct {
	Index int
	Hash  string
	Data  []byte
}

// FileReassembler chunk'lardan dosya oluşturur
// Single Responsibility: Sadece dosya birleştirme
type FileReassembler struct {
	// fileID -> chunks map
	pendingFiles map[string]*PendingFile
	mu           sync.RWMutex
}

// PendingFile henüz tamamlanmamış dosya
type PendingFile struct {
	FileID         string
	TotalChunks    int
	ReceivedChunks map[int]*ChunkData // index -> chunk data
	GlobalHash     string              // Beklenen global hash
	mu             sync.Mutex
}

// NewFileReassembler yeni reassembler oluşturur
func NewFileReassembler() *FileReassembler {
	return &FileReassembler{
		pendingFiles: make(map[string]*PendingFile),
	}
}

// InitializeFile dosya birleştirme başlat
func (r *FileReassembler) InitializeFile(fileID string, totalChunks int, globalHash string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	
	if _, exists := r.pendingFiles[fileID]; exists {
		return fmt.Errorf("dosya zaten initialize edilmiş: %s", fileID)
	}
	
	r.pendingFiles[fileID] = &PendingFile{
		FileID:         fileID,
		TotalChunks:    totalChunks,
		ReceivedChunks: make(map[int]*ChunkData),
		GlobalHash:     globalHash,
	}
	
	return nil
}

// AddChunk dosyaya chunk ekle
func (r *FileReassembler) AddChunk(fileID string, chunkIndex int, chunkHash string, data []byte) error {
	r.mu.RLock()
	pendingFile, exists := r.pendingFiles[fileID]
	r.mu.RUnlock()
	
	if !exists {
		return fmt.Errorf("dosya initialize edilmemiş: %s", fileID)
	}
	
	pendingFile.mu.Lock()
	defer pendingFile.mu.Unlock()
	
	// Chunk hash'ini doğrula
	actualHash := sha256.Sum256(data)
	actualHashStr := hex.EncodeToString(actualHash[:])
	
	if actualHashStr != chunkHash {
		return fmt.Errorf("chunk hash uyuşmuyor: expected=%s, got=%s", chunkHash, actualHashStr)
	}
	
	// Chunk'ı ekle
	pendingFile.ReceivedChunks[chunkIndex] = &ChunkData{
		Index: chunkIndex,
		Hash:  chunkHash,
		Data:  data,
	}
	
	return nil
}

// IsFileComplete dosya tamamlandı mı?
func (r *FileReassembler) IsFileComplete(fileID string) bool {
	r.mu.RLock()
	pendingFile, exists := r.pendingFiles[fileID]
	r.mu.RUnlock()
	
	if !exists {
		return false
	}
	
	pendingFile.mu.Lock()
	defer pendingFile.mu.Unlock()
	
	return len(pendingFile.ReceivedChunks) == pendingFile.TotalChunks
}

// GetProgress dosya indirme progress'ini döner (0-100)
func (r *FileReassembler) GetProgress(fileID string) float64 {
	r.mu.RLock()
	pendingFile, exists := r.pendingFiles[fileID]
	r.mu.RUnlock()
	
	if !exists {
		return 0
	}
	
	pendingFile.mu.Lock()
	defer pendingFile.mu.Unlock()
	
	if pendingFile.TotalChunks == 0 {
		return 0
	}
	
	return float64(len(pendingFile.ReceivedChunks)) / float64(pendingFile.TotalChunks) * 100
}

// WriteToFile chunk'ları birleştirip dosyaya yaz
func (r *FileReassembler) WriteToFile(fileID, outputPath string) error {
	r.mu.RLock()
	pendingFile, exists := r.pendingFiles[fileID]
	r.mu.RUnlock()
	
	if !exists {
		return fmt.Errorf("dosya bulunamadı: %s", fileID)
	}
	
	pendingFile.mu.Lock()
	defer pendingFile.mu.Unlock()
	
	// Tüm chunk'lar var mı kontrol et
	if len(pendingFile.ReceivedChunks) != pendingFile.TotalChunks {
		return fmt.Errorf("dosya tamamlanmamış: %d/%d chunks", 
			len(pendingFile.ReceivedChunks), pendingFile.TotalChunks)
	}
	
	// Chunk'ları sıralı şekilde topla
	indices := make([]int, 0, len(pendingFile.ReceivedChunks))
	for index := range pendingFile.ReceivedChunks {
		indices = append(indices, index)
	}
	sort.Ints(indices)
	
	// Dosya dizinini oluştur
	dir := filepath.Dir(outputPath)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return fmt.Errorf("dizin oluşturulamadı: %w", err)
	}
	
	// Dosyayı oluştur
	file, err := os.Create(outputPath)
	if err != nil {
		return fmt.Errorf("dosya oluşturulamadı: %w", err)
	}
	defer file.Close()
	
	// Chunk'ları sırayla yaz
	globalHashBuilder := sha256.New()
	for _, index := range indices {
		chunkData := pendingFile.ReceivedChunks[index]
		
		// Dosyaya yaz
		if _, err := file.Write(chunkData.Data); err != nil {
			return fmt.Errorf("chunk yazılamadı [%d]: %w", index, err)
		}
		
		// Global hash hesapla
		globalHashBuilder.Write([]byte(chunkData.Hash))
	}
	
	// Global hash'i doğrula
	actualGlobalHash := hex.EncodeToString(globalHashBuilder.Sum(nil))
	if pendingFile.GlobalHash != "" && actualGlobalHash != pendingFile.GlobalHash {
		// Dosyayı sil (corrupt)
		file.Close()
		os.Remove(outputPath)
		return fmt.Errorf("global hash uyuşmuyor: expected=%s, got=%s", 
			pendingFile.GlobalHash, actualGlobalHash)
	}
	
	return nil
}

// CleanupFile dosyayı pending listesinden kaldır
func (r *FileReassembler) CleanupFile(fileID string) {
	r.mu.Lock()
	defer r.mu.Unlock()
	
	delete(r.pendingFiles, fileID)
}

// GetPendingFiles tüm pending dosyaları döner
func (r *FileReassembler) GetPendingFiles() []string {
	r.mu.RLock()
	defer r.mu.RUnlock()
	
	fileIDs := make([]string, 0, len(r.pendingFiles))
	for fileID := range r.pendingFiles {
		fileIDs = append(fileIDs, fileID)
	}
	
	return fileIDs
}

// GetMissingChunks eksik chunk index'lerini döner
func (r *FileReassembler) GetMissingChunks(fileID string) ([]int, error) {
	r.mu.RLock()
	pendingFile, exists := r.pendingFiles[fileID]
	r.mu.RUnlock()
	
	if !exists {
		return nil, fmt.Errorf("dosya bulunamadı: %s", fileID)
	}
	
	pendingFile.mu.Lock()
	defer pendingFile.mu.Unlock()
	
	missing := make([]int, 0)
	for i := 0; i < pendingFile.TotalChunks; i++ {
		if _, exists := pendingFile.ReceivedChunks[i]; !exists {
			missing = append(missing, i)
		}
	}
	
	return missing, nil
}

