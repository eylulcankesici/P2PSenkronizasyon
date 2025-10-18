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

// UserRepository SQLite implementasyonu
type UserRepository struct {
	conn *Connection
}

// NewUserRepository yeni bir UserRepository oluşturur
func NewUserRepository(conn *Connection) repository.UserRepository {
	return &UserRepository{
		conn: conn,
	}
}

// Create yeni bir kullanıcı oluşturur
func (r *UserRepository) Create(ctx context.Context, user *entity.User) error {
	if user.ID == "" {
		user.ID = uuid.New().String()
	}
	
	query := `
		INSERT INTO users (id, profile_name, role, password_hash, is_active, created_at, updated_at)
		VALUES (?, ?, ?, ?, ?, ?, ?)
	`
	
	_, err := r.conn.DB().ExecContext(ctx, query,
		user.ID,
		user.ProfileName,
		user.Role,
		user.PasswordHash,
		user.IsActive,
		user.CreatedAt,
		user.UpdatedAt,
	)
	
	if err != nil {
		return fmt.Errorf("kullanıcı oluşturulamadı: %w", err)
	}
	
	return nil
}

// GetByID ID'ye göre kullanıcı getirir
func (r *UserRepository) GetByID(ctx context.Context, id string) (*entity.User, error) {
	query := `
		SELECT id, profile_name, role, password_hash, is_active, created_at, updated_at
		FROM users
		WHERE id = ?
	`
	
	user := &entity.User{}
	
	err := r.conn.DB().QueryRowContext(ctx, query, id).Scan(
		&user.ID,
		&user.ProfileName,
		&user.Role,
		&user.PasswordHash,
		&user.IsActive,
		&user.CreatedAt,
		&user.UpdatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("kullanıcı getirilemedi: %w", err)
	}
	
	return user, nil
}

// GetByProfileName profil adına göre kullanıcı getirir
func (r *UserRepository) GetByProfileName(ctx context.Context, profileName string) (*entity.User, error) {
	query := `
		SELECT id, profile_name, role, password_hash, is_active, created_at, updated_at
		FROM users
		WHERE profile_name = ?
	`
	
	user := &entity.User{}
	
	err := r.conn.DB().QueryRowContext(ctx, query, profileName).Scan(
		&user.ID,
		&user.ProfileName,
		&user.Role,
		&user.PasswordHash,
		&user.IsActive,
		&user.CreatedAt,
		&user.UpdatedAt,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("kullanıcı getirilemedi: %w", err)
	}
	
	return user, nil
}

// GetAll tüm kullanıcıları getirir
func (r *UserRepository) GetAll(ctx context.Context) ([]*entity.User, error) {
	query := `
		SELECT id, profile_name, role, password_hash, is_active, created_at, updated_at
		FROM users
		ORDER BY created_at DESC
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("kullanıcılar getirilemedi: %w", err)
	}
	defer rows.Close()
	
	users := make([]*entity.User, 0)
	
	for rows.Next() {
		user := &entity.User{}
		
		err := rows.Scan(
			&user.ID,
			&user.ProfileName,
			&user.Role,
			&user.PasswordHash,
			&user.IsActive,
			&user.CreatedAt,
			&user.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("kullanıcı taranamadı: %w", err)
		}
		
		users = append(users, user)
	}
	
	return users, nil
}

// GetAdmins sadece admin kullanıcıları getirir
func (r *UserRepository) GetAdmins(ctx context.Context) ([]*entity.User, error) {
	query := `
		SELECT id, profile_name, role, password_hash, is_active, created_at, updated_at
		FROM users
		WHERE role = ?
		ORDER BY created_at DESC
	`
	
	rows, err := r.conn.DB().QueryContext(ctx, query, entity.UserRoleAdmin)
	if err != nil {
		return nil, fmt.Errorf("admin kullanıcılar getirilemedi: %w", err)
	}
	defer rows.Close()
	
	users := make([]*entity.User, 0)
	
	for rows.Next() {
		user := &entity.User{}
		
		err := rows.Scan(
			&user.ID,
			&user.ProfileName,
			&user.Role,
			&user.PasswordHash,
			&user.IsActive,
			&user.CreatedAt,
			&user.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("kullanıcı taranamadı: %w", err)
		}
		
		users = append(users, user)
	}
	
	return users, nil
}

// Update kullanıcı bilgilerini günceller
func (r *UserRepository) Update(ctx context.Context, user *entity.User) error {
	user.UpdatedAt = time.Now()
	
	query := `
		UPDATE users
		SET profile_name = ?, role = ?, password_hash = ?, is_active = ?, updated_at = ?
		WHERE id = ?
	`
	
	result, err := r.conn.DB().ExecContext(ctx, query,
		user.ProfileName,
		user.Role,
		user.PasswordHash,
		user.IsActive,
		user.UpdatedAt,
		user.ID,
	)
	
	if err != nil {
		return fmt.Errorf("kullanıcı güncellenemedi: %w", err)
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

// Delete kullanıcıyı siler
func (r *UserRepository) Delete(ctx context.Context, id string) error {
	query := `DELETE FROM users WHERE id = ?`
	
	result, err := r.conn.DB().ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("kullanıcı silinemedi: %w", err)
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

// UpdatePassword kullanıcı şifresini günceller
func (r *UserRepository) UpdatePassword(ctx context.Context, id string, passwordHash string) error {
	query := `
		UPDATE users
		SET password_hash = ?, updated_at = ?
		WHERE id = ?
	`
	
	result, err := r.conn.DB().ExecContext(ctx, query, passwordHash, time.Now(), id)
	if err != nil {
		return fmt.Errorf("şifre güncellenemedi: %w", err)
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





