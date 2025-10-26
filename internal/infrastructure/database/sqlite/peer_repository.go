package sqlite

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"time"
	
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
)

// PeerRepository SQLite implementasyonu
type PeerRepository struct {
	conn *Connection
}

// NewPeerRepository yeni bir PeerRepository oluşturur
func NewPeerRepository(conn *Connection) repository.PeerRepository {
	return &PeerRepository{
		conn: conn,
	}
}

// Create yeni bir peer kaydı oluşturur
func (r *PeerRepository) Create(ctx context.Context, peer *entity.Peer) error {
	addressesJSON, err := json.Marshal(peer.KnownAddresses)
	if err != nil {
		return fmt.Errorf("known addresses serialize edilemedi: %w", err)
	}
	
	query := `
		INSERT INTO peers (device_id, name, addresses, is_trusted, last_seen)
		VALUES (?, ?, ?, ?, ?)
	`
	
	_, err = r.conn.DB().ExecContext(ctx, query,
		peer.DeviceID,
		peer.Name,
		string(addressesJSON),
		peer.IsTrusted,
		peer.LastSeen.Unix(),
	)
	
	if err != nil {
		return fmt.Errorf("peer oluşturulamadı: %w", err)
	}
	
	return nil
}

// GetByID device ID'sine göre peer getirir
func (r *PeerRepository) GetByID(ctx context.Context, deviceID string) (*entity.Peer, error) {
	query := `
		SELECT device_id, name, addresses, is_trusted, last_seen
		FROM peers
		WHERE device_id = ?
	`
	
	peer := &entity.Peer{}
	var addressesJSON string
	var lastSeenUnix sql.NullInt64
	
	err := r.conn.DB().QueryRowContext(ctx, query, deviceID).Scan(
		&peer.DeviceID,
		&peer.Name,
		&addressesJSON,
		&peer.IsTrusted,
		&lastSeenUnix,
	)
	
	if err == sql.ErrNoRows {
		return nil, entity.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("peer getirilemedi: %w", err)
	}
	
	if err := json.Unmarshal([]byte(addressesJSON), &peer.KnownAddresses); err != nil {
		peer.KnownAddresses = make([]string, 0)
	}
	
	// Unix timestamp'i time.Time'a çevir
	if lastSeenUnix.Valid && lastSeenUnix.Int64 > 0 {
		peer.LastSeen = time.Unix(lastSeenUnix.Int64, 0)
	}
	
	// Default değerler (veritabanında yok)
	peer.Status = entity.PeerStatusUnknown
	peer.PublicKey = ""
	peer.CreatedAt = time.Now()
	peer.UpdatedAt = time.Now()
	
	return peer, nil
}

// GetAll tüm peer'ları getirir
func (r *PeerRepository) GetAll(ctx context.Context) ([]*entity.Peer, error) {
	query := `
		SELECT device_id, name, addresses, is_trusted, last_seen
		FROM peers
		ORDER BY last_seen DESC
	`
	
	return r.queryPeers(ctx, query)
}

// GetTrusted sadece güvenilir peer'ları getirir
func (r *PeerRepository) GetTrusted(ctx context.Context) ([]*entity.Peer, error) {
	query := `
		SELECT device_id, name, addresses, is_trusted, last_seen
		FROM peers
		WHERE is_trusted = 1
		ORDER BY last_seen DESC
	`
	
	return r.queryPeers(ctx, query)
}

// GetOnline online olan peer'ları getirir
func (r *PeerRepository) GetOnline(ctx context.Context) ([]*entity.Peer, error) {
	// Not: Veritabanında status kolonu yok, bu yüzden tüm peer'ları döndürüyoruz
	// Gerçek durumu bağlantılardan kontrol etmek gerekiyor
	return r.GetAll(ctx)
}

// Update peer bilgilerini günceller
func (r *PeerRepository) Update(ctx context.Context, peer *entity.Peer) error {
	peer.UpdatedAt = time.Now()
	
	addressesJSON, err := json.Marshal(peer.KnownAddresses)
	if err != nil {
		return fmt.Errorf("known addresses serialize edilemedi: %w", err)
	}
	
	query := `
		UPDATE peers
		SET name = ?, addresses = ?, is_trusted = ?, last_seen = ?
		WHERE device_id = ?
	`
	
	result, err := r.conn.DB().ExecContext(ctx, query,
		peer.Name,
		string(addressesJSON),
		peer.IsTrusted,
		peer.LastSeen.Unix(),
		peer.DeviceID,
	)
	
	if err != nil {
		return fmt.Errorf("peer güncellenemedi: %w", err)
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

// UpdateLastSeen peer'in son görülme zamanını günceller
func (r *PeerRepository) UpdateLastSeen(ctx context.Context, deviceID string) error {
	query := `
		UPDATE peers
		SET last_seen = ?
		WHERE device_id = ?
	`
	
	now := time.Now()
	result, err := r.conn.DB().ExecContext(ctx, query, now.Unix(), deviceID)
	if err != nil {
		return fmt.Errorf("last seen güncellenemedi: %w", err)
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

// UpdateStatus peer'in durumunu günceller
// Not: Veritabanında status kolonu yok, bu metod hiçbir şey yapmıyor
func (r *PeerRepository) UpdateStatus(ctx context.Context, deviceID string, status entity.PeerStatus) error {
	// Veritabanında status kolonu yok, bu yüzden sadece last_seen'i güncelliyoruz
	// Gerçek status bilgisini bağlantı durumundan almak gerekiyor
	return nil
}

// Delete peer'ı siler
func (r *PeerRepository) Delete(ctx context.Context, deviceID string) error {
	query := `DELETE FROM peers WHERE device_id = ?`
	
	result, err := r.conn.DB().ExecContext(ctx, query, deviceID)
	if err != nil {
		return fmt.Errorf("peer silinemedi: %w", err)
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

// GetRecentlySeen belirli bir süre içinde görülen peer'ları getirir
func (r *PeerRepository) GetRecentlySeen(ctx context.Context, threshold time.Duration) ([]*entity.Peer, error) {
	cutoffTime := time.Now().Add(-threshold)
	
	query := `
		SELECT device_id, name, addresses, is_trusted, last_seen
		FROM peers
		WHERE last_seen >= ?
		ORDER BY last_seen DESC
	`
	
	return r.queryPeers(ctx, query, cutoffTime.Unix())
}

// queryPeers ortak peer sorgu metodu
func (r *PeerRepository) queryPeers(ctx context.Context, query string, args ...interface{}) ([]*entity.Peer, error) {
	rows, err := r.conn.DB().QueryContext(ctx, query, args...)
	if err != nil {
		return nil, fmt.Errorf("peer'lar getirilemedi: %w", err)
	}
	defer rows.Close()
	
	peers := make([]*entity.Peer, 0)
	
	for rows.Next() {
		peer := &entity.Peer{}
		var addressesJSON string
		var lastSeenUnix sql.NullInt64
		
		err := rows.Scan(
			&peer.DeviceID,
			&peer.Name,
			&addressesJSON,
			&peer.IsTrusted,
			&lastSeenUnix,
		)
		if err != nil {
			return nil, fmt.Errorf("peer taranamadı: %w", err)
		}
		
		if err := json.Unmarshal([]byte(addressesJSON), &peer.KnownAddresses); err != nil {
			peer.KnownAddresses = make([]string, 0)
		}
		
		// Unix timestamp'i time.Time'a çevir
		if lastSeenUnix.Valid && lastSeenUnix.Int64 > 0 {
			peer.LastSeen = time.Unix(lastSeenUnix.Int64, 0)
		}
		
		// Default değerler (veritabanında yok)
		peer.Status = entity.PeerStatusUnknown
		peer.PublicKey = ""
		peer.CreatedAt = time.Now()
		peer.UpdatedAt = time.Now()
		
		peers = append(peers, peer)
	}
	
	return peers, nil
}





