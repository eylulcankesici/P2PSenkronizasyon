package sqlite

import (
	"context"
	"database/sql"
	"fmt"
	"time"
	
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/google/uuid"
)

// FolderRepository SQLite implementasyonu
type FolderRepository struct {
	conn *Connection
}

// NewFolderRepository yeni bir FolderRepository oluşturur
func NewFolderRepository(conn *Connection) repository.FolderRepository {
	return &FolderRepository{
		conn: conn,
	}
}

// Create yeni bir klasör oluşturur
func (r *FolderRepository) Create(ctx context.Context, folder *entity.Folder) error {
	if folder.ID == "" {
		folder.ID = uuid.New().String()
	}
	
	query := `
		INSERT INTO folders (id, local_path, sync_mode, last_scan_time, is_active, created_at, updated_at, name, device_id)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
	`
	
	// time.Time'ı Unix timestamp'e çevir
	var lastScanTime int64
	if !folder.LastScanTime.IsZero() {
		lastScanTime = folder.LastScanTime.Unix()
	}
	
	_, err := r.conn.DB().ExecContext(ctx, query,
		folder.ID,
		folder.LocalPath,
		folder.SyncMode,
		lastScanTime,
		folder.IsActive,
		folder.CreatedAt.Unix(),
		folder.UpdatedAt.Unix(),
		folder.LocalPath, // name varsayılan olarak local_path
		"local-device",   // device_id geçici
	)
	
	if err != nil {
		return fmt.Errorf("klasör oluşturulamadı: %w", err)
	}
	
	return nil
}

// GetByID ID'ye göre klasör getirir
func (r *FolderRepository) GetByID(ctx context.Context, id string) (*entity.Folder, error) {
	query := `
		SELECT id, local_path, sync_mode, last_scan_time, is_active, created_at, updated_at
		FROM folders
		WHERE id = ?
	`
	
	folder := &entity.Folder{}
	var lastScanTime, createdAt, updatedAt sql.NullInt64
	
	err := r.conn.DB().QueryRowContext(ctx, query, id).Scan(
		&folder.ID,
		&folder.LocalPath,
		&folder.SyncMode,
		&lastScanTime,
		&folder.IsActive,
		&createdAt,
		&updatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("klasör getirilemedi: %w", err)
	}
	
	// Unix timestamp'i time.Time'a çevir
	if lastScanTime.Valid && lastScanTime.Int64 > 0 {
		folder.LastScanTime = time.Unix(lastScanTime.Int64, 0)
	}
	if createdAt.Valid && createdAt.Int64 > 0 {
		folder.CreatedAt = time.Unix(createdAt.Int64, 0)
	}
	if updatedAt.Valid && updatedAt.Int64 > 0 {
		folder.UpdatedAt = time.Unix(updatedAt.Int64, 0)
	}
	
	return folder, nil
}

// GetByPath dosya yoluna göre klasör getirir
func (r *FolderRepository) GetByPath(ctx context.Context, path string) (*entity.Folder, error) {
	query := `
		SELECT id, local_path, sync_mode, last_scan_time, is_active, created_at, updated_at
		FROM folders
		WHERE local_path = ?
	`
	
	folder := &entity.Folder{}
	var lastScanTime, createdAt, updatedAt sql.NullInt64
	
	err := r.conn.DB().QueryRowContext(ctx, query, path).Scan(
		&folder.ID,
		&folder.LocalPath,
		&folder.SyncMode,
		&lastScanTime,
		&folder.IsActive,
		&createdAt,
		&updatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("klasör getirilemedi: %w", err)
	}
	
	// Unix timestamp'i time.Time'a çevir
	if lastScanTime.Valid && lastScanTime.Int64 > 0 {
		folder.LastScanTime = time.Unix(lastScanTime.Int64, 0)
	}
	if createdAt.Valid && createdAt.Int64 > 0 {
		folder.CreatedAt = time.Unix(createdAt.Int64, 0)
	}
	if updatedAt.Valid && updatedAt.Int64 > 0 {
		folder.UpdatedAt = time.Unix(updatedAt.Int64, 0)
	}
	
	return folder, nil
}

// GetAll tüm klasörleri getirir
func (r *FolderRepository) GetAll(ctx context.Context) ([]*entity.Folder, error) {
	query := `
		SELECT id, local_path, sync_mode, last_scan_time, is_active, created_at, updated_at
		FROM folders
		ORDER BY created_at DESC
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("klasörler getirilemedi: %w", err)
	}
	defer rows.Close()
	
	folders := make([]*entity.Folder, 0)
	
	for rows.Next() {
		folder := &entity.Folder{}
		var lastScanTime, createdAt, updatedAt sql.NullInt64
		
		err := rows.Scan(
			&folder.ID,
			&folder.LocalPath,
			&folder.SyncMode,
			&lastScanTime,
			&folder.IsActive,
			&createdAt,
			&updatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("klasör taranamadı: %w", err)
		}
		
		// Unix timestamp'i time.Time'a çevir
		if lastScanTime.Valid && lastScanTime.Int64 > 0 {
			folder.LastScanTime = time.Unix(lastScanTime.Int64, 0)
		}
		if createdAt.Valid && createdAt.Int64 > 0 {
			folder.CreatedAt = time.Unix(createdAt.Int64, 0)
		}
		if updatedAt.Valid && updatedAt.Int64 > 0 {
			folder.UpdatedAt = time.Unix(updatedAt.Int64, 0)
		}
		
		folders = append(folders, folder)
	}
	
	return folders, nil
}

// GetActive sadece aktif klasörleri getirir
func (r *FolderRepository) GetActive(ctx context.Context) ([]*entity.Folder, error) {
	query := `
		SELECT id, local_path, sync_mode, last_scan_time, is_active, created_at, updated_at
		FROM folders
		WHERE is_active = 1
		ORDER BY created_at DESC
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("aktif klasörler getirilemedi: %w", err)
	}
	defer rows.Close()
	
	folders := make([]*entity.Folder, 0)
	
	for rows.Next() {
		folder := &entity.Folder{}
		var lastScanTime, createdAt, updatedAt sql.NullInt64
		
		err := rows.Scan(
			&folder.ID,
			&folder.LocalPath,
			&folder.SyncMode,
			&lastScanTime,
			&folder.IsActive,
			&createdAt,
			&updatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("klasör taranamadı: %w", err)
		}
		
		// Unix timestamp'i time.Time'a çevir
		if lastScanTime.Valid && lastScanTime.Int64 > 0 {
			folder.LastScanTime = time.Unix(lastScanTime.Int64, 0)
		}
		if createdAt.Valid && createdAt.Int64 > 0 {
			folder.CreatedAt = time.Unix(createdAt.Int64, 0)
		}
		if updatedAt.Valid && updatedAt.Int64 > 0 {
			folder.UpdatedAt = time.Unix(updatedAt.Int64, 0)
		}
		
		folders = append(folders, folder)
	}
	
	return folders, nil
}

// Update klasör bilgilerini günceller
func (r *FolderRepository) Update(ctx context.Context, folder *entity.Folder) error {
	folder.UpdatedAt = time.Now()
	
	query := `
		UPDATE folders
		SET local_path = ?, sync_mode = ?, last_scan_time = ?, is_active = ?, updated_at = ?
		WHERE id = ?
	`
	
	// time.Time'ı Unix timestamp'e çevir
	var lastScanTime int64
	if !folder.LastScanTime.IsZero() {
		lastScanTime = folder.LastScanTime.Unix()
	}
	
	result, err := r.conn.DB().ExecContext(ctx, query,
		folder.LocalPath,
		folder.SyncMode,
		lastScanTime,
		folder.IsActive,
		folder.UpdatedAt.Unix(),
		folder.ID,
	)
	
	if err != nil {
		return fmt.Errorf("klasör güncellenemedi: %w", err)
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

// Delete klasörü siler
func (r *FolderRepository) Delete(ctx context.Context, id string) error {
	query := `DELETE FROM folders WHERE id = ?`
	
	result, err := r.conn.DB().ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("klasör silinemedi: %w", err)
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

// UpdateScanTime son tarama zamanını günceller
func (r *FolderRepository) UpdateScanTime(ctx context.Context, id string) error {
	query := `
		UPDATE folders
		SET last_scan_time = ?, updated_at = ?
		WHERE id = ?
	`
	
	now := time.Now()
	nowUnix := now.Unix()
	result, err := r.conn.DB().ExecContext(ctx, query, nowUnix, nowUnix, id)
	if err != nil {
		return fmt.Errorf("tarama zamanı güncellenemedi: %w", err)
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


