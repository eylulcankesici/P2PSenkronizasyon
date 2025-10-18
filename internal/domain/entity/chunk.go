package entity

import (
	"time"
)

const (
	// DefaultChunkSize varsayılan chunk boyutu (256KB - optimal P2P transfer)
	DefaultChunkSize = 256 * 1024
	
	// MinChunkSize minimum chunk boyutu (64KB)
	MinChunkSize = 64 * 1024
	
	// MaxChunkSize maksimum chunk boyutu (4MB)
	MaxChunkSize = 4 * 1024 * 1024
)

// Chunk dosyanın bir parçasını temsil eder
// DESIGN SPEC: Hash-based deduplication
// Single Responsibility: Sadece chunk meta verisini tutar
type Chunk struct {
	Hash         string    // SHA-256 hash (PRIMARY KEY)
	Size         int64     // Chunk boyutu (bytes)
	CreationTime time.Time // İlk oluşturulma zamanı
	IsLocal      bool      // Bu cihazda fiziksel olarak var mı?
}

// FileChunk bir dosyanın bir chunk ile ilişkisini temsil eder
// DESIGN SPEC: file_chunks junction table
type FileChunk struct {
	FileID     string // files.id FK
	ChunkHash  string // chunks.hash FK
	ChunkIndex int    // Dosya içindeki sıra (0, 1, 2...)
}

// NewChunk yeni bir Chunk oluşturur (Factory Pattern)
func NewChunk(hash string, size int64) *Chunk {
	return &Chunk{
		Hash:         hash,
		Size:         size,
		CreationTime: time.Now(),
		IsLocal:      true, // Yeni oluşturulan chunk her zaman local
	}
}

// NewFileChunk yeni bir FileChunk ilişkisi oluşturur
func NewFileChunk(fileID, chunkHash string, index int) *FileChunk {
	return &FileChunk{
		FileID:     fileID,
		ChunkHash:  chunkHash,
		ChunkIndex: index,
	}
}

// Validate chunk'ın geçerliliğini kontrol eder
func (c *Chunk) Validate() error {
	if c.Hash == "" {
		return ErrInvalidChunkHash
	}
	
	if len(c.Hash) != 64 { // SHA-256 = 64 hex characters
		return ErrInvalidChunkHash
	}
	
	if c.Size <= 0 || c.Size > MaxChunkSize {
		return ErrInvalidChunkSize
	}
	
	return nil
}

// MarkAsLocal chunk'ı bu cihazda var olarak işaretler
func (c *Chunk) MarkAsLocal() {
	c.IsLocal = true
}

// MarkAsRemote chunk'ı bu cihazda yok olarak işaretler
func (c *Chunk) MarkAsRemote() {
	c.IsLocal = false
}




