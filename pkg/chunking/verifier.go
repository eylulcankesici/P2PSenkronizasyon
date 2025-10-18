package chunking

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
)

// ChunkVerifier chunk bütünlüğünü doğrular
// Single Responsibility: Sadece verification işlemi
type ChunkVerifier interface {
	// Verify chunk'ın hash'inin doğru olup olmadığını kontrol eder
	Verify(data []byte, expectedHash string) error
	
	// VerifyChunk ChunkResult'ın bütünlüğünü kontrol eder
	VerifyChunk(chunk *ChunkResult) error
}

// SHA256Verifier SHA-256 hash ile doğrulama yapar
type SHA256Verifier struct{}

// NewSHA256Verifier yeni bir SHA256Verifier oluşturur
func NewSHA256Verifier() *SHA256Verifier {
	return &SHA256Verifier{}
}

// Verify chunk'ın hash'inin doğru olup olmadığını kontrol eder
func (v *SHA256Verifier) Verify(data []byte, expectedHash string) error {
	if len(data) == 0 {
		return fmt.Errorf("veri boş")
	}

	if expectedHash == "" {
		return fmt.Errorf("beklenen hash boş")
	}

	// Gerçek hash'i hesapla
	hash := sha256.Sum256(data)
	actualHash := hex.EncodeToString(hash[:])

	// Karşılaştır
	if actualHash != expectedHash {
		return fmt.Errorf("chunk bütünlük hatası: beklenen=%s, gerçek=%s", 
			expectedHash, actualHash)
	}

	return nil
}

// VerifyChunk ChunkResult'ın bütünlüğünü kontrol eder
func (v *SHA256Verifier) VerifyChunk(chunk *ChunkResult) error {
	if chunk == nil {
		return fmt.Errorf("chunk nil")
	}

	if chunk.Data == nil || len(chunk.Data) == 0 {
		return fmt.Errorf("chunk verisi boş")
	}

	if int64(len(chunk.Data)) != chunk.Size {
		return fmt.Errorf("chunk boyutu uyumsuz: beklenen=%d, gerçek=%d", 
			chunk.Size, len(chunk.Data))
	}

	return v.Verify(chunk.Data, chunk.Hash)
}

// VerifyFile tüm chunk'ların bütünlüğünü ve global hash'i doğrular
func VerifyFile(chunks []*ChunkResult, expectedGlobalHash string) error {
	if len(chunks) == 0 {
		return fmt.Errorf("chunk listesi boş")
	}

	verifier := NewSHA256Verifier()

	// Her chunk'ı doğrula
	for i, chunk := range chunks {
		if err := verifier.VerifyChunk(chunk); err != nil {
			return fmt.Errorf("chunk %d doğrulanamadı: %w", i, err)
		}

		// Index kontrolü
		if chunk.Index != i {
			return fmt.Errorf("chunk %d index uyumsuz: beklenen=%d, gerçek=%d", 
				i, i, chunk.Index)
		}
	}

	// Global hash doğrula
	if expectedGlobalHash != "" {
		actualGlobalHash := CalculateFileHash(chunks)
		if actualGlobalHash != expectedGlobalHash {
			return fmt.Errorf("global hash uyumsuz: beklenen=%s, gerçek=%s", 
				expectedGlobalHash, actualGlobalHash)
		}
	}

	return nil
}

// ReconstructFile chunk'lardan dosyayı yeniden oluşturur
// Kullanım: P2P transfer sonrası dosya birleştirme
func ReconstructFile(chunks []*ChunkResult) ([]byte, error) {
	if len(chunks) == 0 {
		return []byte{}, nil
	}

	// Chunk'ları sıraya göre sırala (güvenlik için)
	// Index'ler sıralı mı kontrol et
	for i, chunk := range chunks {
		if chunk.Index != i {
			return nil, fmt.Errorf("chunk sıralaması bozuk: beklenen=%d, gerçek=%d", 
				i, chunk.Index)
		}
	}

	// Toplam boyutu hesapla
	totalSize := int64(0)
	for _, chunk := range chunks {
		totalSize += chunk.Size
	}

	// Buffer oluştur
	result := make([]byte, 0, totalSize)

	// Chunk'ları birleştir
	for _, chunk := range chunks {
		result = append(result, chunk.Data...)
	}

	return result, nil
}

