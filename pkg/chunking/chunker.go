package chunking

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"os"
)

// ChunkSize chunk boyutu (256KB)
const ChunkSize = 256 * 1024

// ChunkResult bir chunk'ın bilgilerini içerir
// Single Responsibility: Sadece chunk metadata
type ChunkResult struct {
	Hash   string // SHA-256 hash
	Index  int    // Dosya içindeki sıra (0-based)
	Size   int64  // Chunk boyutu
	Offset int64  // Dosya içindeki başlangıç pozisyonu
	Data   []byte // Chunk verisi (opsiyonel, storage için)
}

// Chunker dosyaları parçalara böler
// Single Responsibility: Sadece chunking işlemi
// Open/Closed: Yeni chunk algoritmaları için extend edilebilir
type Chunker interface {
	ChunkFile(filePath string) ([]*ChunkResult, error)
	ChunkData(data []byte) ([]*ChunkResult, error)
}

// FixedSizeChunker sabit boyutlu chunking yapar
// Implements: Chunker interface (Dependency Inversion)
type FixedSizeChunker struct {
	chunkSize int64
}

// NewFixedSizeChunker yeni bir FixedSizeChunker oluşturur (Factory)
func NewFixedSizeChunker(chunkSize int64) *FixedSizeChunker {
	if chunkSize <= 0 {
		chunkSize = ChunkSize
	}
	return &FixedSizeChunker{
		chunkSize: chunkSize,
	}
}

// ChunkFile dosyayı parçalara böler ve hash'lerini hesaplar
// Interface Segregation: Chunker interface'inin minimal metodu
func (c *FixedSizeChunker) ChunkFile(filePath string) ([]*ChunkResult, error) {
	// Dosyayı aç
	file, err := os.Open(filePath)
	if err != nil {
		return nil, fmt.Errorf("dosya açılamadı: %w", err)
	}
	defer file.Close()

	// Dosya boyutunu al
	fileInfo, err := file.Stat()
	if err != nil {
		return nil, fmt.Errorf("dosya bilgisi alınamadı: %w", err)
	}

	fileSize := fileInfo.Size()
	if fileSize == 0 {
		return []*ChunkResult{}, nil // Boş dosya
	}

	// Chunk sayısını hesapla
	numChunks := (fileSize + c.chunkSize - 1) / c.chunkSize
	chunks := make([]*ChunkResult, 0, numChunks)

	// Buffer oluştur
	buffer := make([]byte, c.chunkSize)
	index := 0
	offset := int64(0)

	for {
		// Chunk'ı oku
		n, err := file.Read(buffer)
		if err != nil && err != io.EOF {
			return nil, fmt.Errorf("dosya okunamadı: %w", err)
		}

		if n == 0 {
			break // Dosya sonu
		}

		// Okunan veriyi al
		chunkData := buffer[:n]

		// SHA-256 hash hesapla
		hash := sha256.Sum256(chunkData)
		hashStr := hex.EncodeToString(hash[:])

		// ChunkResult oluştur
		chunk := &ChunkResult{
			Hash:   hashStr,
			Index:  index,
			Size:   int64(n),
			Offset: offset,
			Data:   make([]byte, n),
		}
		copy(chunk.Data, chunkData)

		chunks = append(chunks, chunk)

		index++
		offset += int64(n)

		if err == io.EOF {
			break
		}
	}

	return chunks, nil
}

// ChunkData byte array'i parçalara böler
// Liskov Substitution: FixedSizeChunker anywhere Chunker is expected
func (c *FixedSizeChunker) ChunkData(data []byte) ([]*ChunkResult, error) {
	if len(data) == 0 {
		return []*ChunkResult{}, nil
	}

	numChunks := (int64(len(data)) + c.chunkSize - 1) / c.chunkSize
	chunks := make([]*ChunkResult, 0, numChunks)

	index := 0
	offset := int64(0)

	for offset < int64(len(data)) {
		// Chunk boyutunu belirle
		end := offset + c.chunkSize
		if end > int64(len(data)) {
			end = int64(len(data))
		}

		// Chunk verisini al
		chunkData := data[offset:end]

		// SHA-256 hash hesapla
		hash := sha256.Sum256(chunkData)
		hashStr := hex.EncodeToString(hash[:])

		// ChunkResult oluştur
		chunk := &ChunkResult{
			Hash:   hashStr,
			Index:  index,
			Size:   int64(len(chunkData)),
			Offset: offset,
			Data:   make([]byte, len(chunkData)),
		}
		copy(chunk.Data, chunkData)

		chunks = append(chunks, chunk)

		index++
		offset = end
	}

	return chunks, nil
}

// CalculateFileHash dosyanın global hash'ini hesaplar
// Tüm chunk hash'lerinin birleşiminden oluşur
func CalculateFileHash(chunks []*ChunkResult) string {
	if len(chunks) == 0 {
		return ""
	}

	// Tüm chunk hash'lerini birleştir
	hasher := sha256.New()
	for _, chunk := range chunks {
		hasher.Write([]byte(chunk.Hash))
	}

	return hex.EncodeToString(hasher.Sum(nil))
}
