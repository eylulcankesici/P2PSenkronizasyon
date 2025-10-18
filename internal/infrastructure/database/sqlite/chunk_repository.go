package sqlite

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
)

// ChunkRepository SQLite implementasyonu
// DESIGN SPEC uyumlu: hash PRIMARY KEY, is_local flag
type ChunkRepository struct {
	conn *Connection
}

// NewChunkRepository yeni bir ChunkRepository oluşturur
func NewChunkRepository(conn *Connection) repository.ChunkRepository {
	return &ChunkRepository{
		conn: conn,
	}
}

// Create yeni bir chunk kaydı oluşturur
// Deduplication: Hash zaten varsa skip et
func (r *ChunkRepository) Create(ctx context.Context, chunk *entity.Chunk) error {
	// Chunk zaten var mı kontrol et
	exists, err := r.ExistsByHash(ctx, chunk.Hash)
	if err != nil {
		return fmt.Errorf("chunk kontrolü başarısız: %w", err)
	}

	if exists {
		// Chunk zaten var, sadece is_local'i güncelle
		return r.UpdateLocalStatus(ctx, chunk.Hash, chunk.IsLocal)
	}

	query := `
		INSERT INTO chunks (hash, size, creation_time, is_local)
		VALUES (?, ?, ?, ?)
	`

	_, err = r.conn.DB().ExecContext(ctx, query,
		chunk.Hash,
		chunk.Size,
		chunk.CreationTime.Unix(),
		chunk.IsLocal,
	)

	if err != nil {
		return fmt.Errorf("chunk oluşturulamadı: %w", err)
	}

	return nil
}

// GetByHash hash'e göre chunk getirir
func (r *ChunkRepository) GetByHash(ctx context.Context, hash string) (*entity.Chunk, error) {
	query := `
		SELECT hash, size, creation_time, is_local
		FROM chunks
		WHERE hash = ?
	`

	chunk := &entity.Chunk{}
	var creationTime sql.NullInt64

	err := r.conn.DB().QueryRowContext(ctx, query, hash).Scan(
		&chunk.Hash,
		&chunk.Size,
		&creationTime,
		&chunk.IsLocal,
	)

	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("chunk getirilemedi: %w", err)
	}

	// Unix timestamp → time.Time
	if creationTime.Valid && creationTime.Int64 > 0 {
		chunk.CreationTime = time.Unix(creationTime.Int64, 0)
	}

	return chunk, nil
}

// ExistsByHash chunk'ın var olup olmadığını kontrol eder
func (r *ChunkRepository) ExistsByHash(ctx context.Context, hash string) (bool, error) {
	query := `SELECT COUNT(*) FROM chunks WHERE hash = ?`

	var count int
	err := r.conn.DB().QueryRowContext(ctx, query, hash).Scan(&count)
	if err != nil {
		return false, fmt.Errorf("chunk kontrolü başarısız: %w", err)
	}

	return count > 0, nil
}

// UpdateLocalStatus chunk'ın local durumunu günceller
func (r *ChunkRepository) UpdateLocalStatus(ctx context.Context, hash string, isLocal bool) error {
	query := `
		UPDATE chunks
		SET is_local = ?
		WHERE hash = ?
	`

	result, err := r.conn.DB().ExecContext(ctx, query, isLocal, hash)
	if err != nil {
		return fmt.Errorf("chunk güncellenemedi: %w", err)
	}

	rows, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rows == 0 {
		return entity.ErrNotFound
	}

	return nil
}

// Delete chunk'ı siler
func (r *ChunkRepository) Delete(ctx context.Context, hash string) error {
	query := `DELETE FROM chunks WHERE hash = ?`

	result, err := r.conn.DB().ExecContext(ctx, query, hash)
	if err != nil {
		return fmt.Errorf("chunk silinemedi: %w", err)
	}

	rows, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rows == 0 {
		return entity.ErrNotFound
	}

	return nil
}

// GetLocalChunks local chunk'ları getirir
func (r *ChunkRepository) GetLocalChunks(ctx context.Context) ([]*entity.Chunk, error) {
	query := `
		SELECT hash, size, creation_time, is_local
		FROM chunks
		WHERE is_local = 1
		ORDER BY creation_time DESC
	`

	rows, err := r.conn.DB().QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("chunk'lar getirilemedi: %w", err)
	}
	defer rows.Close()

	chunks := make([]*entity.Chunk, 0)

	for rows.Next() {
		chunk := &entity.Chunk{}
		var creationTime sql.NullInt64

		err := rows.Scan(
			&chunk.Hash,
			&chunk.Size,
			&creationTime,
			&chunk.IsLocal,
		)
		if err != nil {
			return nil, fmt.Errorf("chunk taranamadı: %w", err)
		}

		if creationTime.Valid && creationTime.Int64 > 0 {
			chunk.CreationTime = time.Unix(creationTime.Int64, 0)
		}

		chunks = append(chunks, chunk)
	}

	return chunks, nil
}

// === FILE_CHUNKS İLİŞKİ YÖNETİMİ ===

// CreateFileChunk file-chunk ilişkisi oluşturur
func (r *ChunkRepository) CreateFileChunk(ctx context.Context, fileChunk *entity.FileChunk) error {
	query := `
		INSERT INTO file_chunks (file_id, chunk_hash, chunk_index)
		VALUES (?, ?, ?)
	`

	_, err := r.conn.DB().ExecContext(ctx, query,
		fileChunk.FileID,
		fileChunk.ChunkHash,
		fileChunk.ChunkIndex,
	)

	if err != nil {
		return fmt.Errorf("file-chunk ilişkisi oluşturulamadı: %w", err)
	}

	return nil
}

// GetFileChunks bir dosyanın tüm chunk'larını getirir (sıralı)
func (r *ChunkRepository) GetFileChunks(ctx context.Context, fileID string) ([]*entity.FileChunk, error) {
	query := `
		SELECT file_id, chunk_hash, chunk_index
		FROM file_chunks
		WHERE file_id = ?
		ORDER BY chunk_index ASC
	`

	rows, err := r.conn.DB().QueryContext(ctx, query, fileID)
	if err != nil {
		return nil, fmt.Errorf("file chunk'ları getirilemedi: %w", err)
	}
	defer rows.Close()

	fileChunks := make([]*entity.FileChunk, 0)

	for rows.Next() {
		fc := &entity.FileChunk{}
		err := rows.Scan(
			&fc.FileID,
			&fc.ChunkHash,
			&fc.ChunkIndex,
		)
		if err != nil {
			return nil, fmt.Errorf("file chunk taranamadı: %w", err)
		}

		fileChunks = append(fileChunks, fc)
	}

	return fileChunks, nil
}

// GetChunksByFileID bir dosyanın chunk detaylarını getirir
func (r *ChunkRepository) GetChunksByFileID(ctx context.Context, fileID string) ([]*entity.Chunk, error) {
	query := `
		SELECT c.hash, c.size, c.creation_time, c.is_local
		FROM chunks c
		INNER JOIN file_chunks fc ON c.hash = fc.chunk_hash
		WHERE fc.file_id = ?
		ORDER BY fc.chunk_index ASC
	`

	rows, err := r.conn.DB().QueryContext(ctx, query, fileID)
	if err != nil {
		return nil, fmt.Errorf("chunk'lar getirilemedi: %w", err)
	}
	defer rows.Close()

	chunks := make([]*entity.Chunk, 0)

	for rows.Next() {
		chunk := &entity.Chunk{}
		var creationTime sql.NullInt64

		err := rows.Scan(
			&chunk.Hash,
			&chunk.Size,
			&creationTime,
			&chunk.IsLocal,
		)
		if err != nil {
			return nil, fmt.Errorf("chunk taranamadı: %w", err)
		}

		if creationTime.Valid && creationTime.Int64 > 0 {
			chunk.CreationTime = time.Unix(creationTime.Int64, 0)
		}

		chunks = append(chunks, chunk)
	}

	return chunks, nil
}

// DeleteFileChunks bir dosyanın tüm chunk ilişkilerini siler
func (r *ChunkRepository) DeleteFileChunks(ctx context.Context, fileID string) error {
	query := `DELETE FROM file_chunks WHERE file_id = ?`

	_, err := r.conn.DB().ExecContext(ctx, query, fileID)
	if err != nil {
		return fmt.Errorf("file chunk'ları silinemedi: %w", err)
	}

	return nil
}

// CountChunkReferences bir chunk'ın kaç dosyada kullanıldığını sayar
// Deduplication istatistiği için kullanılır
func (r *ChunkRepository) CountChunkReferences(ctx context.Context, hash string) (int, error) {
	query := `SELECT COUNT(DISTINCT file_id) FROM file_chunks WHERE chunk_hash = ?`

	var count int
	err := r.conn.DB().QueryRowContext(ctx, query, hash).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("referans sayımı başarısız: %w", err)
	}

	return count, nil
}

// DeleteOrphanedChunks hiçbir dosyaya referans vermeyen chunk'ları siler
func (r *ChunkRepository) DeleteOrphanedChunks(ctx context.Context) (int, error) {
	query := `
		DELETE FROM chunks
		WHERE hash NOT IN (SELECT DISTINCT chunk_hash FROM file_chunks)
	`
	
	result, err := r.conn.DB().ExecContext(ctx, query)
	if err != nil {
		return 0, fmt.Errorf("yetim chunk'lar silinemedi: %w", err)
	}
	
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return 0, err
	}
	
	return int(rowsAffected), nil
}

// GetDeduplicationStats deduplication istatistiklerini döndürür
func (r *ChunkRepository) GetDeduplicationStats(ctx context.Context) (totalChunks, uniqueChunks int64, savingsBytes int64, err error) {
	// Toplam chunk referansları (file_chunks tablosunda)
	err = r.conn.DB().QueryRowContext(ctx, `
		SELECT COUNT(fc.chunk_hash), COALESCE(SUM(c.size), 0)
		FROM file_chunks fc
		JOIN chunks c ON fc.chunk_hash = c.hash
	`).Scan(&totalChunks, &savingsBytes) // savingsBytes burada aslında toplam boyut
	if err != nil {
		return 0, 0, 0, fmt.Errorf("toplam chunk istatistikleri alınamadı: %w", err)
	}

	// Benzersiz chunk sayısı ve boyutu (chunks tablosundan)
	var uniqueChunksSize int64
	err = r.conn.DB().QueryRowContext(ctx, `
		SELECT COUNT(hash), COALESCE(SUM(size), 0)
		FROM chunks
	`).Scan(&uniqueChunks, &uniqueChunksSize)
	if err != nil {
		return 0, 0, 0, fmt.Errorf("benzersiz chunk istatistikleri alınamadı: %w", err)
	}

	// Tasarruf edilen boyut = (Toplam boyut - Benzersiz boyut)
	savingsBytes = savingsBytes - uniqueChunksSize
	return totalChunks, uniqueChunks, savingsBytes, nil
}
