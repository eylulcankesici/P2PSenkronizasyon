package repository

import (
	"context"

	"github.com/aether/sync/internal/domain/entity"
)

// ChunkRepository chunk veritabanı işlemleri için interface
// Interface Segregation: Sadece chunk işlemleri
// Dependency Inversion: Concrete implementation'a bağımlı değil
type ChunkRepository interface {
	// Create yeni bir chunk kaydı oluşturur
	Create(ctx context.Context, chunk *entity.Chunk) error

	// GetByHash hash'e göre chunk getirir
	GetByHash(ctx context.Context, hash string) (*entity.Chunk, error)

	// ExistsByHash chunk'ın var olup olmadığını kontrol eder
	ExistsByHash(ctx context.Context, hash string) (bool, error)

	// UpdateLocalStatus chunk'ın local durumunu günceller
	UpdateLocalStatus(ctx context.Context, hash string, isLocal bool) error

	// Delete chunk'ı siler
	Delete(ctx context.Context, hash string) error

	// GetLocalChunks local chunk'ları getirir
	GetLocalChunks(ctx context.Context) ([]*entity.Chunk, error)

	// === FILE_CHUNKS İLİŞKİ YÖNETİMİ ===

	// CreateFileChunk file-chunk ilişkisi oluşturur
	CreateFileChunk(ctx context.Context, fileChunk *entity.FileChunk) error

	// GetFileChunks bir dosyanın tüm chunk'larını getirir
	GetFileChunks(ctx context.Context, fileID string) ([]*entity.FileChunk, error)

	// GetChunksByFileID bir dosyanın chunk detaylarını getirir
	GetChunksByFileID(ctx context.Context, fileID string) ([]*entity.Chunk, error)

	// DeleteFileChunks bir dosyanın tüm chunk ilişkilerini siler
	DeleteFileChunks(ctx context.Context, fileID string) error

	// CountChunkReferences bir chunk'ın kaç dosyada kullanıldığını sayar
	CountChunkReferences(ctx context.Context, hash string) (int, error)
	
	// DeleteOrphanedChunks hiçbir dosyaya referans vermeyen chunk'ları siler
	DeleteOrphanedChunks(ctx context.Context) (int, error)
	
	// GetDeduplicationStats deduplication istatistiklerini döndürür
	GetDeduplicationStats(ctx context.Context) (totalChunks, uniqueChunks int64, savingsBytes int64, err error)
}
