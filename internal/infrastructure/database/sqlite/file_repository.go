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

// FileRepository SQLite implementasyonu
type FileRepository struct {
	conn *Connection
}

// NewFileRepository yeni bir FileRepository oluşturur
func NewFileRepository(conn *Connection) repository.FileRepository {
	return &FileRepository{
		conn: conn,
	}
}

// Create yeni bir dosya kaydı oluşturur
func (r *FileRepository) Create(ctx context.Context, file *entity.File) error {
	if file.ID == "" {
		file.ID = uuid.New().String()
	}
	
	query := `
		INSERT INTO files (id, folder_id, relative_path, size, mod_time, global_hash, is_deleted)
		VALUES (?, ?, ?, ?, ?, ?, ?)
	`
	
	_, err := r.conn.DB().ExecContext(ctx, query,
		file.ID,
		file.FolderID,
		file.RelativePath,
		file.Size,
		file.ModTime.Unix(),
		file.GlobalHash,
		file.IsDeleted,
	)
	
	if err != nil {
		return fmt.Errorf("dosya oluşturulamadı: %w", err)
	}
	
	return nil
}

// GetByID ID'ye göre dosya getirir
func (r *FileRepository) GetByID(ctx context.Context, id string) (*entity.File, error) {
	query := `
		SELECT id, folder_id, relative_path, size, mod_time, global_hash, is_deleted
		FROM files
		WHERE id = ?
	`
	
	file := &entity.File{}
	var modTime sql.NullInt64
	
	err := r.conn.DB().QueryRowContext(ctx, query, id).Scan(
		&file.ID,
		&file.FolderID,
		&file.RelativePath,
		&file.Size,
		&modTime,
		&file.GlobalHash,
		&file.IsDeleted,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("dosya getirilemedi: %w", err)
	}
	
	// Unix timestamp'i time.Time'a çevir
	if modTime.Valid && modTime.Int64 > 0 {
		file.ModTime = time.Unix(modTime.Int64, 0)
	}
	
	// Default değerler
	file.CreatedAt = time.Now()
	file.UpdatedAt = time.Now()
	
	return file, nil
}

// GetByPath klasör ID ve relative path'e göre dosya getirir
func (r *FileRepository) GetByPath(ctx context.Context, folderID, relativePath string) (*entity.File, error) {
	query := `
		SELECT id, folder_id, relative_path, size, mod_time, global_hash, is_deleted
		FROM files
		WHERE folder_id = ? AND relative_path = ?
	`
	
	file := &entity.File{}
	var modTime sql.NullInt64
	
	err := r.conn.DB().QueryRowContext(ctx, query, folderID, relativePath).Scan(
		&file.ID,
		&file.FolderID,
		&file.RelativePath,
		&file.Size,
		&modTime,
		&file.GlobalHash,
		&file.IsDeleted,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("dosya getirilemedi: %w", err)
	}
	
	// Unix timestamp'i time.Time'a çevir
	if modTime.Valid && modTime.Int64 > 0 {
		file.ModTime = time.Unix(modTime.Int64, 0)
	}
	
	// Default değerler
	file.CreatedAt = time.Now()
	file.UpdatedAt = time.Now()
	
	return file, nil
}

// GetByFolderID bir klasördeki tüm dosyaları getirir
func (r *FileRepository) GetByFolderID(ctx context.Context, folderID string) ([]*entity.File, error) {
	query := `
		SELECT id, folder_id, relative_path, size, mod_time, global_hash, is_deleted
		FROM files
		WHERE folder_id = ? AND is_deleted = 0
		ORDER BY relative_path
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query, folderID)
	if err != nil {
		return nil, fmt.Errorf("dosyalar getirilemedi: %w", err)
	}
	defer rows.Close()
	
	files := make([]*entity.File, 0)
	
	for rows.Next() {
		file := &entity.File{}
		var modTime sql.NullInt64
		
		err := rows.Scan(
			&file.ID,
			&file.FolderID,
			&file.RelativePath,
			&file.Size,
			&modTime,
			&file.GlobalHash,
			&file.IsDeleted,
		)
		if err != nil {
			return nil, fmt.Errorf("dosya taranamadı: %w", err)
		}
		
		// Unix timestamp'i time.Time'a çevir
		if modTime.Valid && modTime.Int64 > 0 {
			file.ModTime = time.Unix(modTime.Int64, 0)
		}
		
		// Default değerler
		file.CreatedAt = time.Now()
		file.UpdatedAt = time.Now()
		
		files = append(files, file)
	}
	
	return files, nil
}

// GetByHash hash değerine göre dosyaları getirir
func (r *FileRepository) GetByHash(ctx context.Context, hash string) ([]*entity.File, error) {
	query := `
		SELECT id, folder_id, relative_path, size, mod_time, global_hash, is_deleted
		FROM files
		WHERE global_hash = ? AND is_deleted = 0
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query, hash)
	if err != nil {
		return nil, fmt.Errorf("dosyalar getirilemedi: %w", err)
	}
	defer rows.Close()
	
	files := make([]*entity.File, 0)
	
	for rows.Next() {
		file := &entity.File{}
		var modTime sql.NullInt64
		
		err := rows.Scan(
			&file.ID,
			&file.FolderID,
			&file.RelativePath,
			&file.Size,
			&modTime,
			&file.GlobalHash,
			&file.IsDeleted,
		)
		if err != nil {
			return nil, fmt.Errorf("dosya taranamadı: %w", err)
		}
		
		// Unix timestamp'i time.Time'a çevir
		if modTime.Valid && modTime.Int64 > 0 {
			file.ModTime = time.Unix(modTime.Int64, 0)
		}
		
		// Default değerler
		file.CreatedAt = time.Now()
		file.UpdatedAt = time.Now()
		
		files = append(files, file)
	}
	
	return files, nil
}

// Update dosya bilgilerini günceller
func (r *FileRepository) Update(ctx context.Context, file *entity.File) error {
	file.UpdatedAt = time.Now()
	
	query := `
		UPDATE files
		SET folder_id = ?, relative_path = ?, size = ?, mod_time = ?, global_hash = ?, is_deleted = ?
		WHERE id = ?
	`
	
	result, err := r.conn.DB().ExecContext(ctx, query,
		file.FolderID,
		file.RelativePath,
		file.Size,
		file.ModTime.Unix(),
		file.GlobalHash,
		file.IsDeleted,
		file.ID,
	)
	
	if err != nil {
		return fmt.Errorf("dosya güncellenemedi: %w", err)
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

// Delete dosyayı siler (soft delete)
func (r *FileRepository) Delete(ctx context.Context, id string) error {
	query := `
		UPDATE files
		SET is_deleted = 1
		WHERE id = ?
	`
	
	result, err := r.conn.DB().ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("dosya silinemedi: %w", err)
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

// HardDelete dosyayı veritabanından tamamen siler
func (r *FileRepository) HardDelete(ctx context.Context, id string) error {
	query := `DELETE FROM files WHERE id = ?`
	
	result, err := r.conn.DB().ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("dosya silinemedi: %w", err)
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

// GetModifiedSince belirli bir tarihten sonra değişen dosyaları getirir
func (r *FileRepository) GetModifiedSince(ctx context.Context, folderID string, since int64) ([]*entity.File, error) {
	query := `
		SELECT id, folder_id, relative_path, size, mod_time, global_hash, is_deleted
		FROM files
		WHERE folder_id = ? AND mod_time > ?
		ORDER BY mod_time DESC
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query, folderID, since)
	if err != nil {
		return nil, fmt.Errorf("dosyalar getirilemedi: %w", err)
	}
	defer rows.Close()
	
	files := make([]*entity.File, 0)
	
	for rows.Next() {
		file := &entity.File{}
		var modTime sql.NullInt64
		
		err := rows.Scan(
			&file.ID,
			&file.FolderID,
			&file.RelativePath,
			&file.Size,
			&modTime,
			&file.GlobalHash,
			&file.IsDeleted,
		)
		if err != nil {
			return nil, fmt.Errorf("dosya taranamadı: %w", err)
		}
		
		// Unix timestamp'i time.Time'a çevir
		if modTime.Valid && modTime.Int64 > 0 {
			file.ModTime = time.Unix(modTime.Int64, 0)
		}
		
		// Default değerler
		file.CreatedAt = time.Now()
		file.UpdatedAt = time.Now()
		
		files = append(files, file)
	}
	
	return files, nil
}





