package sqlite

import (
	"database/sql"
	"fmt"
)

// Migration veritabanı migration'larını yönetir
type Migration struct {
	conn *Connection
}

// NewMigration yeni bir Migration oluşturur
func NewMigration(conn *Connection) *Migration {
	return &Migration{
		conn: conn,
	}
}

// RunMigrations tüm migration'ları çalıştırır
func (m *Migration) RunMigrations() error {
	if !m.conn.IsOpen() {
		if err := m.conn.Open(); err != nil {
			return err
		}
	}
	
	db := m.conn.DB()
	
	// Migration version tablosu oluştur
	if err := m.createVersionTable(db); err != nil {
		return err
	}
	
	// Tüm migration'ları sırayla çalıştır
	migrations := []struct {
		version int
		name    string
		up      func(*sql.DB) error
	}{
		{1, "create_folders_table", m.createFoldersTable},
		{2, "create_files_table", m.createFilesTable},
		{3, "create_chunks_table", m.createChunksTable},
		{4, "create_file_chunks_table", m.createFileChunksTable},
		{5, "create_peers_table", m.createPeersTable},
		{6, "create_peer_folder_status_table", m.createPeerFolderStatusTable},
		{7, "create_users_table", m.createUsersTable},
		{8, "create_versions_table", m.createVersionsTable},
		{9, "create_indexes", m.createIndexes},
		{10, "fix_cascade_delete", m.fixCascadeDelete},
		{11, "add_folder_source", m.addFolderSource},
	}
	
	for _, migration := range migrations {
		if err := m.runMigration(db, migration.version, migration.name, migration.up); err != nil {
			return fmt.Errorf("migration %d (%s) başarısız: %w", migration.version, migration.name, err)
		}
	}
	
	return nil
}

// createVersionTable migration version tablosu oluşturur
func (m *Migration) createVersionTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS schema_migrations (
		version INTEGER PRIMARY KEY,
		name TEXT NOT NULL,
		applied_at DATETIME DEFAULT CURRENT_TIMESTAMP
	)`
	
	_, err := db.Exec(query)
	return err
}

// runMigration bir migration'ı çalıştırır
func (m *Migration) runMigration(db *sql.DB, version int, name string, up func(*sql.DB) error) error {
	// Bu migration daha önce çalıştırıldı mı kontrol et
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM schema_migrations WHERE version = ?", version).Scan(&count)
	if err != nil {
		return err
	}
	
	if count > 0 {
		return nil // Zaten çalıştırılmış
	}
	
	// Transaction başlat
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()
	
	// Migration'ı çalıştır
	if err := up(db); err != nil {
		return err
	}
	
	// Version'ı kaydet
	_, err = tx.Exec("INSERT INTO schema_migrations (version, name) VALUES (?, ?)", version, name)
	if err != nil {
		return err
	}
	
	return tx.Commit()
}

// createFoldersTable folders tablosunu oluşturur
func (m *Migration) createFoldersTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS folders (
		id TEXT PRIMARY KEY,
		name TEXT NOT NULL,
		local_path TEXT NOT NULL UNIQUE,
		sync_mode TEXT NOT NULL,
		last_scan_time INTEGER NOT NULL,
		device_id TEXT NOT NULL,
		is_active BOOLEAN NOT NULL DEFAULT 1
	)`
	
	_, err := db.Exec(query)
	return err
}

// createFilesTable files tablosunu oluşturur
func (m *Migration) createFilesTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS files (
		id TEXT PRIMARY KEY,
		folder_id TEXT NOT NULL,
		relative_path TEXT NOT NULL,
		size INTEGER NOT NULL,
		mod_time INTEGER NOT NULL,
		global_hash TEXT NOT NULL,
		is_deleted BOOLEAN NOT NULL,
		FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE
	)`
	
	_, err := db.Exec(query)
	return err
}

// createChunksTable chunks tablosunu oluşturur
func (m *Migration) createChunksTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS chunks (
		hash TEXT PRIMARY KEY,
		size INTEGER NOT NULL,
		creation_time INTEGER NOT NULL,
		is_local BOOLEAN NOT NULL
	)`
	
	_, err := db.Exec(query)
	return err
}

// createFileChunksTable file_chunks tablosunu oluşturur
func (m *Migration) createFileChunksTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS file_chunks (
		file_id TEXT NOT NULL,
		chunk_hash TEXT NOT NULL,
		chunk_index INTEGER NOT NULL,
		PRIMARY KEY(file_id, chunk_index),
		FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
		FOREIGN KEY (chunk_hash) REFERENCES chunks(hash)
	)`
	
	_, err := db.Exec(query)
	return err
}

// createPeersTable peers tablosunu oluşturur
func (m *Migration) createPeersTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS peers (
		device_id TEXT PRIMARY KEY,
		name TEXT NOT NULL,
		addresses TEXT,
		is_trusted BOOLEAN NOT NULL,
		last_seen INTEGER
	)`
	
	_, err := db.Exec(query)
	return err
}

// createPeerFolderStatusTable peer_folder_status tablosunu oluşturur
func (m *Migration) createPeerFolderStatusTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS peer_folder_status (
		folder_id TEXT NOT NULL,
		peer_id TEXT NOT NULL,
		global_version INTEGER NOT NULL,
		sync_state TEXT,
		PRIMARY KEY(folder_id, peer_id),
		FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE,
		FOREIGN KEY (peer_id) REFERENCES peers(device_id) ON DELETE CASCADE
	)`
	
	_, err := db.Exec(query)
	return err
}

// createUsersTable users tablosunu oluşturur
func (m *Migration) createUsersTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS users (
		id TEXT PRIMARY KEY,
		profile_name TEXT NOT NULL UNIQUE,
		role TEXT NOT NULL,
		password_hash TEXT NOT NULL,
		is_active BOOLEAN NOT NULL DEFAULT 1,
		created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
	)`
	
	_, err := db.Exec(query)
	return err
}

// createVersionsTable file_versions tablosunu oluşturur
func (m *Migration) createVersionsTable(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS file_versions (
		id TEXT PRIMARY KEY,
		file_id TEXT NOT NULL,
		version_number INTEGER NOT NULL,
		backup_path TEXT NOT NULL,
		original_path TEXT NOT NULL,
		size INTEGER NOT NULL,
		hash TEXT NOT NULL,
		created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		created_by_peer_id TEXT,
		FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
		UNIQUE(file_id, version_number)
	)`
	
	_, err := db.Exec(query)
	return err
}

// createIndexes performans için index'ler oluşturur
func (m *Migration) createIndexes(db *sql.DB) error {
	indexes := []string{
		"CREATE INDEX IF NOT EXISTS idx_files_folder_id ON files(folder_id)",
		"CREATE INDEX IF NOT EXISTS idx_files_global_hash ON files(global_hash)",
		"CREATE INDEX IF NOT EXISTS idx_files_is_deleted ON files(is_deleted)",
		"CREATE INDEX IF NOT EXISTS idx_file_chunks_file_id ON file_chunks(file_id)",
		"CREATE INDEX IF NOT EXISTS idx_file_chunks_chunk_hash ON file_chunks(chunk_hash)",
		"CREATE INDEX IF NOT EXISTS idx_chunks_is_local ON chunks(is_local)",
		"CREATE INDEX IF NOT EXISTS idx_peer_folder_status_folder_id ON peer_folder_status(folder_id)",
		"CREATE INDEX IF NOT EXISTS idx_peer_folder_status_peer_id ON peer_folder_status(peer_id)",
		"CREATE INDEX IF NOT EXISTS idx_peers_is_trusted ON peers(is_trusted)",
		"CREATE INDEX IF NOT EXISTS idx_file_versions_file_id ON file_versions(file_id)",
	}
	
	for _, indexQuery := range indexes {
		if _, err := db.Exec(indexQuery); err != nil {
			return err
		}
	}
	
	return nil
}

// fixCascadeDelete mevcut tablolara ON DELETE CASCADE constraint'ini ekler
func (m *Migration) fixCascadeDelete(db *sql.DB) error {
	// SQLite'da mevcut tabloya foreign key constraint eklemek için tabloları yeniden oluşturmak gerekiyor
	
	// 1. files tablosunu yeniden oluştur (ON DELETE CASCADE ile)
	if err := m.recreateFilesTable(db); err != nil {
		return fmt.Errorf("files tablosu yeniden oluşturulamadı: %w", err)
	}
	
	// 2. file_chunks tablosunu yeniden oluştur (ON DELETE CASCADE ile)
	if err := m.recreateFileChunksTable(db); err != nil {
		return fmt.Errorf("file_chunks tablosu yeniden oluşturulamadı: %w", err)
	}
	
	// 3. file_versions tablosunu yeniden oluştur (ON DELETE CASCADE ile)
	if err := m.recreateFileVersionsTable(db); err != nil {
		return fmt.Errorf("file_versions tablosu yeniden oluşturulamadı: %w", err)
	}
	
	// 4. peer_folder_status tablosunu yeniden oluştur (ON DELETE CASCADE ile)
	if err := m.recreatePeerFolderStatusTable(db); err != nil {
		return fmt.Errorf("peer_folder_status tablosu yeniden oluşturulamadı: %w", err)
	}
	
	return nil
}

// recreateFilesTable files tablosunu ON DELETE CASCADE ile yeniden oluşturur
func (m *Migration) recreateFilesTable(db *sql.DB) error {
	// Yeni tablo oluştur
	_, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS files_new (
			id TEXT PRIMARY KEY,
			folder_id TEXT NOT NULL,
			relative_path TEXT NOT NULL,
			size INTEGER NOT NULL,
			mod_time INTEGER NOT NULL,
			global_hash TEXT NOT NULL,
			is_deleted BOOLEAN NOT NULL,
			FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE
		)
	`)
	if err != nil {
		return err
	}
	
	// Eski tablodan verileri kopyala
	_, err = db.Exec(`
		INSERT INTO files_new (id, folder_id, relative_path, size, mod_time, global_hash, is_deleted)
		SELECT id, folder_id, relative_path, size, mod_time, global_hash, is_deleted
		FROM files
	`)
	if err != nil {
		return err
	}
	
	// Eski tabloyu sil
	_, err = db.Exec(`DROP TABLE files`)
	if err != nil {
		return err
	}
	
	// Yeni tabloyu eski adla rename et
	_, err = db.Exec(`ALTER TABLE files_new RENAME TO files`)
	if err != nil {
		return err
	}
	
	return nil
}

// recreateFileChunksTable file_chunks tablosunu ON DELETE CASCADE ile yeniden oluşturur
func (m *Migration) recreateFileChunksTable(db *sql.DB) error {
	// Yeni tablo oluştur
	_, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS file_chunks_new (
			file_id TEXT NOT NULL,
			chunk_hash TEXT NOT NULL,
			chunk_index INTEGER NOT NULL,
			PRIMARY KEY(file_id, chunk_index),
			FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
			FOREIGN KEY (chunk_hash) REFERENCES chunks(hash)
		)
	`)
	if err != nil {
		return err
	}
	
	// Eski tablodan verileri kopyala
	_, err = db.Exec(`
		INSERT INTO file_chunks_new (file_id, chunk_hash, chunk_index)
		SELECT file_id, chunk_hash, chunk_index
		FROM file_chunks
	`)
	if err != nil {
		return err
	}
	
	// Eski tabloyu sil
	_, err = db.Exec(`DROP TABLE file_chunks`)
	if err != nil {
		return err
	}
	
	// Yeni tabloyu eski adla rename et
	_, err = db.Exec(`ALTER TABLE file_chunks_new RENAME TO file_chunks`)
	if err != nil {
		return err
	}
	
	return nil
}

// recreateFileVersionsTable file_versions tablosunu ON DELETE CASCADE ile yeniden oluşturur
func (m *Migration) recreateFileVersionsTable(db *sql.DB) error {
	// Yeni tablo oluştur
	_, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS file_versions_new (
			id TEXT PRIMARY KEY,
			file_id TEXT NOT NULL,
			version_number INTEGER NOT NULL,
			backup_path TEXT NOT NULL,
			original_path TEXT NOT NULL,
			size INTEGER NOT NULL,
			hash TEXT NOT NULL,
			created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
			created_by_peer_id TEXT,
			FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
			UNIQUE(file_id, version_number)
		)
	`)
	if err != nil {
		return err
	}
	
	// Eski tablodan verileri kopyala
	_, err = db.Exec(`
		INSERT INTO file_versions_new (id, file_id, version_number, backup_path, original_path, size, hash, created_at, created_by_peer_id)
		SELECT id, file_id, version_number, backup_path, original_path, size, hash, created_at, created_by_peer_id
		FROM file_versions
	`)
	if err != nil {
		return err
	}
	
	// Eski tabloyu sil
	_, err = db.Exec(`DROP TABLE file_versions`)
	if err != nil {
		return err
	}
	
	// Yeni tabloyu eski adla rename et
	_, err = db.Exec(`ALTER TABLE file_versions_new RENAME TO file_versions`)
	if err != nil {
		return err
	}
	
	return nil
}

// recreatePeerFolderStatusTable peer_folder_status tablosunu ON DELETE CASCADE ile yeniden oluşturur
func (m *Migration) recreatePeerFolderStatusTable(db *sql.DB) error {
	// Yeni tablo oluştur
	_, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS peer_folder_status_new (
			folder_id TEXT NOT NULL,
			peer_id TEXT NOT NULL,
			global_version INTEGER NOT NULL,
			sync_state TEXT,
			PRIMARY KEY(folder_id, peer_id),
			FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE CASCADE,
			FOREIGN KEY (peer_id) REFERENCES peers(device_id) ON DELETE CASCADE
		)
	`)
	if err != nil {
		return err
	}
	
	// Eski tablodan verileri kopyala
	_, err = db.Exec(`
		INSERT INTO peer_folder_status_new (folder_id, peer_id, global_version, sync_state)
		SELECT folder_id, peer_id, global_version, sync_state
		FROM peer_folder_status
	`)
	if err != nil {
		return err
	}
	
	// Eski tabloyu sil
	_, err = db.Exec(`DROP TABLE peer_folder_status`)
	if err != nil {
		return err
	}
	
	// Yeni tabloyu eski adla rename et
	_, err = db.Exec(`ALTER TABLE peer_folder_status_new RENAME TO peer_folder_status`)
	if err != nil {
		return err
	}
	
	return nil
}

// addFolderSource folders tablosuna source kolonu ekler (migration 11)
func (m *Migration) addFolderSource(db *sql.DB) error {
	// source kolonu ekle (default 'user')
	_, err := db.Exec(`
		ALTER TABLE folders 
		ADD COLUMN source TEXT NOT NULL DEFAULT 'user'
	`)
	if err != nil {
		return fmt.Errorf("source kolonu eklenemedi: %w", err)
	}
	
	// Mevcut tüm folder'ların source'unu belirle
	// synced_folders içindeyse 'received', değilse 'user'
	_, err = db.Exec(`
		UPDATE folders 
		SET source = CASE 
			WHEN local_path LIKE '%synced_folders%' THEN 'received'
			ELSE 'user'
		END
	`)
	if err != nil {
		return fmt.Errorf("source değerleri güncellenemedi: %w", err)
	}
	
	return nil
}
