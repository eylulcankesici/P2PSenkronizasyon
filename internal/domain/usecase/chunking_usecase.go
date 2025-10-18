package usecase

import (
	"context"

	"github.com/aether/sync/internal/domain/entity"
)

// ChunkingUseCase dosya chunking işlemleri için use case interface
// Interface Segregation: Sadece chunking operasyonları
// Dependency Inversion: Implementation details hidden
type ChunkingUseCase interface {
	// ChunkAndStoreFile dosyayı chunk'lara böler, disk'e yazar ve DB'ye kaydeder
	// Returns: chunks, global_hash, error
	ChunkAndStoreFile(ctx context.Context, fileID, filePath string) ([]*entity.Chunk, string, error)

	// LoadFileChunks bir dosyanın chunk'larını yükler
	LoadFileChunks(ctx context.Context, fileID string) ([]*entity.Chunk, error)

	// VerifyFileIntegrity dosyanın bütünlüğünü doğrular
	VerifyFileIntegrity(ctx context.Context, fileID string, expectedGlobalHash string) error

	// DeleteFileChunks bir dosyanın chunk'larını siler (DB + disk)
	// Sadece bu dosyada kullanılan chunk'ları siler (ref count control)
	DeleteFileChunks(ctx context.Context, fileID string) error

	// GetChunkData chunk verisini disk'ten okur
	GetChunkData(ctx context.Context, hash string) ([]byte, error)

	// GetDeduplicationStats deduplication istatistiklerini döndürür
	GetDeduplicationStats(ctx context.Context) (totalChunks, uniqueChunks int64, savingsBytes int64, err error)
}





