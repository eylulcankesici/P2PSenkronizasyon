package sqlite

import (
	"context"
	"database/sql"
	"fmt"
	
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/google/uuid"
)

// VersionRepository SQLite implementasyonu
type VersionRepository struct {
	conn *Connection
}

// NewVersionRepository yeni bir VersionRepository oluşturur
func NewVersionRepository(conn *Connection) repository.VersionRepository {
	return &VersionRepository{
		conn: conn,
	}
}

// Create yeni bir versiyon kaydı oluşturur
func (r *VersionRepository) Create(ctx context.Context, version *entity.FileVersion) error {
	if version.ID == "" {
		version.ID = uuid.New().String()
	}
	
	query := `
		INSERT INTO file_versions (id, file_id, version_number, backup_path, original_path, size, hash, created_at, created_by_peer_id)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
	`
	
	_, err := r.conn.DB().ExecContext(ctx, query,
		version.ID,
		version.FileID,
		version.VersionNumber,
		version.BackupPath,
		version.OriginalPath,
		version.Size,
		version.Hash,
		version.CreatedAt,
		version.CreatedByPeerID,
	)
	
	if err != nil {
		return fmt.Errorf("versiyon oluşturulamadı: %w", err)
	}
	
	return nil
}

// GetByID ID'ye göre versiyon getirir
func (r *VersionRepository) GetByID(ctx context.Context, id string) (*entity.FileVersion, error) {
	query := `
		SELECT id, file_id, version_number, backup_path, original_path, size, hash, created_at, created_by_peer_id
		FROM file_versions
		WHERE id = ?
	`
	
	version := &entity.FileVersion{}
	
	err := r.conn.DB().QueryRowContext(ctx, query, id).Scan(
		&version.ID,
		&version.FileID,
		&version.VersionNumber,
		&version.BackupPath,
		&version.OriginalPath,
		&version.Size,
		&version.Hash,
		&version.CreatedAt,
		&version.CreatedByPeerID,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("versiyon getirilemedi: %w", err)
	}
	
	return version, nil
}

// GetByFileID dosya ID'sine göre tüm versiyonları getirir (en yeniden eskiye)
func (r *VersionRepository) GetByFileID(ctx context.Context, fileID string) ([]*entity.FileVersion, error) {
	query := `
		SELECT id, file_id, version_number, backup_path, original_path, size, hash, created_at, created_by_peer_id
		FROM file_versions
		WHERE file_id = ?
		ORDER BY version_number DESC
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query, fileID)
	if err != nil {
		return nil, fmt.Errorf("versiyonlar getirilemedi: %w", err)
	}
	defer rows.Close()
	
	versions := make([]*entity.FileVersion, 0)
	
	for rows.Next() {
		version := &entity.FileVersion{}
		
		err := rows.Scan(
			&version.ID,
			&version.FileID,
			&version.VersionNumber,
			&version.BackupPath,
			&version.OriginalPath,
			&version.Size,
			&version.Hash,
			&version.CreatedAt,
			&version.CreatedByPeerID,
		)
		if err != nil {
			return nil, fmt.Errorf("versiyon taranamadı: %w", err)
		}
		
		versions = append(versions, version)
	}
	
	return versions, nil
}

// GetLatestVersion dosyanın en son versiyonunu getirir
func (r *VersionRepository) GetLatestVersion(ctx context.Context, fileID string) (*entity.FileVersion, error) {
	query := `
		SELECT id, file_id, version_number, backup_path, original_path, size, hash, created_at, created_by_peer_id
		FROM file_versions
		WHERE file_id = ?
		ORDER BY version_number DESC
		LIMIT 1
	`
	
	version := &entity.FileVersion{}
	
	err := r.conn.DB().QueryRowContext(ctx, query, fileID).Scan(
		&version.ID,
		&version.FileID,
		&version.VersionNumber,
		&version.BackupPath,
		&version.OriginalPath,
		&version.Size,
		&version.Hash,
		&version.CreatedAt,
		&version.CreatedByPeerID,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("versiyon getirilemedi: %w", err)
	}
	
	return version, nil
}

// GetByVersionNumber dosyanın belirli versiyon numarasını getirir
func (r *VersionRepository) GetByVersionNumber(ctx context.Context, fileID string, versionNumber int) (*entity.FileVersion, error) {
	query := `
		SELECT id, file_id, version_number, backup_path, original_path, size, hash, created_at, created_by_peer_id
		FROM file_versions
		WHERE file_id = ? AND version_number = ?
	`
	
	version := &entity.FileVersion{}
	
	err := r.conn.DB().QueryRowContext(ctx, query, fileID, versionNumber).Scan(
		&version.ID,
		&version.FileID,
		&version.VersionNumber,
		&version.BackupPath,
		&version.OriginalPath,
		&version.Size,
		&version.Hash,
		&version.CreatedAt,
		&version.CreatedByPeerID,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("versiyon getirilemedi: %w", err)
	}
	
	return version, nil
}

// Delete versiyon kaydını siler
func (r *VersionRepository) Delete(ctx context.Context, id string) error {
	query := `DELETE FROM file_versions WHERE id = ?`
	
	result, err := r.conn.DB().ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("versiyon silinemedi: %w", err)
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

// DeleteOldVersions belirli sayıdan eski versiyonları siler
func (r *VersionRepository) DeleteOldVersions(ctx context.Context, fileID string, keepCount int) error {
	// Silinecek version ID'lerini bul
	query := `
		SELECT id
		FROM file_versions
		WHERE file_id = ?
		ORDER BY version_number DESC
		LIMIT -1 OFFSET ?
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query, fileID, keepCount)
	if err != nil {
		return fmt.Errorf("silinecek versiyonlar bulunamadı: %w", err)
	}
	defer rows.Close()
	
	idsToDelete := make([]string, 0)
	for rows.Next() {
		var id string
		if err := rows.Scan(&id); err != nil {
			return fmt.Errorf("versiyon ID taranamadı: %w", err)
	}
		idsToDelete = append(idsToDelete, id)
	}
	
	// Versiyonları sil
	for _, id := range idsToDelete {
		if err := r.Delete(ctx, id); err != nil {
			return err
		}
	}
	
	return nil
}

// GetTotalVersionCount toplam versiyon sayısını getirir
func (r *VersionRepository) GetTotalVersionCount(ctx context.Context, fileID string) (int, error) {
	query := `
		SELECT COUNT(*)
		FROM file_versions
		WHERE file_id = ?
	`
	
	var count int
	err := r.conn.DB().QueryRowContext(ctx, query, fileID).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("versiyon sayısı alınamadı: %w", err)
	}
	
	return count, nil
}





