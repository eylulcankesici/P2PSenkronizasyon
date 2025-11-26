package sqlite

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
)

// FilePeerSyncRepository SQLite implementasyonu
type FilePeerSyncRepository struct {
	conn *Connection
}

// NewFilePeerSyncRepository yeni bir FilePeerSyncRepository oluşturur
func NewFilePeerSyncRepository(conn *Connection) repository.FilePeerSyncRepository {
	return &FilePeerSyncRepository{
		conn: conn,
	}
}

// CreateOrUpdate dosya-peer sync kaydı oluşturur veya günceller
func (r *FilePeerSyncRepository) CreateOrUpdate(ctx context.Context, sync *entity.FilePeerSync) error {
	query := `
		INSERT INTO file_peer_sync (file_id, peer_id, sender_device_id, synced_at)
		VALUES (?, ?, ?, ?)
		ON CONFLICT(file_id, peer_id) DO UPDATE SET
			sender_device_id = excluded.sender_device_id,
			synced_at = excluded.synced_at
	`

	_, err := r.conn.DB().ExecContext(ctx, query,
		sync.FileID,
		sync.PeerID,
		sync.SenderDeviceID,
		sync.SyncedAt.Unix(),
	)

	if err != nil {
		return fmt.Errorf("file-peer sync kaydı oluşturulamadı/güncellenemedi: %w", err)
	}

	return nil
}

// GetByFileID dosyanın hangi peer'larla senkronize edildiğini getirir
func (r *FilePeerSyncRepository) GetByFileID(ctx context.Context, fileID string) ([]*entity.FilePeerSync, error) {
	query := `
		SELECT file_id, peer_id, sender_device_id, synced_at
		FROM file_peer_sync
		WHERE file_id = ?
		ORDER BY synced_at DESC
	`

	rows, err := r.conn.DB().QueryContext(ctx, query, fileID)
	if err != nil {
		return nil, fmt.Errorf("file-peer sync kayıtları getirilemedi: %w", err)
	}
	defer rows.Close()

	syncs := make([]*entity.FilePeerSync, 0)
	for rows.Next() {
		sync := &entity.FilePeerSync{}
		var syncedAt sql.NullInt64

		err := rows.Scan(
			&sync.FileID,
			&sync.PeerID,
			&sync.SenderDeviceID,
			&syncedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("file-peer sync kaydı okunamadı: %w", err)
		}

		if syncedAt.Valid && syncedAt.Int64 > 0 {
			sync.SyncedAt = time.Unix(syncedAt.Int64, 0)
		}

		syncs = append(syncs, sync)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("rows iteration hatası: %w", err)
	}

	return syncs, nil
}

// GetByFileAndPeerID belirli bir dosya-peer çifti için sync kaydını getirir
func (r *FilePeerSyncRepository) GetByFileAndPeerID(ctx context.Context, fileID, peerID string) (*entity.FilePeerSync, error) {
	query := `
		SELECT file_id, peer_id, sender_device_id, synced_at
		FROM file_peer_sync
		WHERE file_id = ? AND peer_id = ?
	`

	sync := &entity.FilePeerSync{}
	var syncedAt sql.NullInt64

	err := r.conn.DB().QueryRowContext(ctx, query, fileID, peerID).Scan(
		&sync.FileID,
		&sync.PeerID,
		&sync.SenderDeviceID,
		&syncedAt,
	)

	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("file-peer sync kaydı getirilemedi: %w", err)
	}

	if syncedAt.Valid && syncedAt.Int64 > 0 {
		sync.SyncedAt = time.Unix(syncedAt.Int64, 0)
	}

	return sync, nil
}

// IsFileSyncedWithPeer dosyanın belirli bir peer ile senkronize edilip edilmediğini kontrol eder
func (r *FilePeerSyncRepository) IsFileSyncedWithPeer(ctx context.Context, fileID, peerID string) (bool, error) {
	query := `
		SELECT COUNT(*)
		FROM file_peer_sync
		WHERE file_id = ? AND peer_id = ?
	`

	var count int
	err := r.conn.DB().QueryRowContext(ctx, query, fileID, peerID).Scan(&count)
	if err != nil {
		return false, fmt.Errorf("file-peer sync kontrolü yapılamadı: %w", err)
	}

	return count > 0, nil
}

// Delete dosya-peer sync kaydını siler
func (r *FilePeerSyncRepository) Delete(ctx context.Context, fileID, peerID string) error {
	query := `
		DELETE FROM file_peer_sync
		WHERE file_id = ? AND peer_id = ?
	`

	_, err := r.conn.DB().ExecContext(ctx, query, fileID, peerID)
	if err != nil {
		return fmt.Errorf("file-peer sync kaydı silinemedi: %w", err)
	}

	return nil
}

// DeleteByFileID dosyanın tüm sync kayıtlarını siler
func (r *FilePeerSyncRepository) DeleteByFileID(ctx context.Context, fileID string) error {
	query := `
		DELETE FROM file_peer_sync
		WHERE file_id = ?
	`

	_, err := r.conn.DB().ExecContext(ctx, query, fileID)
	if err != nil {
		return fmt.Errorf("file-peer sync kayıtları silinemedi: %w", err)
	}

	return nil
}

// GetPeerIDsByFolderID belirli bir folder'daki dosyaların sync edildiği tüm peer ID'lerini getirir (DISTINCT)
func (r *FilePeerSyncRepository) GetPeerIDsByFolderID(ctx context.Context, folderID string) ([]string, error) {
	query := `
		SELECT DISTINCT fps.peer_id
		FROM file_peer_sync fps
		INNER JOIN files f ON fps.file_id = f.id
		WHERE f.folder_id = ? AND f.is_deleted = 0
	`

	rows, err := r.conn.DB().QueryContext(ctx, query, folderID)
	if err != nil {
		return nil, fmt.Errorf("peer ID'leri getirilemedi: %w", err)
	}
	defer rows.Close()

	peerIDs := make([]string, 0)
	for rows.Next() {
		var peerID string
		if err := rows.Scan(&peerID); err != nil {
			return nil, fmt.Errorf("peer ID okunamadı: %w", err)
		}
		peerIDs = append(peerIDs, peerID)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("rows iteration hatası: %w", err)
	}

	return peerIDs, nil
}

