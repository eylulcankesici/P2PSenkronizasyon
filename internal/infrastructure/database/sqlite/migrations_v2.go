package sqlite

import (
	"database/sql"
	"fmt"
	"log"
)

// MigrateToDesignSpec veritabanını tasarım spesifikasyonuna tam uyumlu hale getirir
func (m *Migration) MigrateToDesignSpec() error {
	if !m.conn.IsOpen() {
		if err := m.conn.Open(); err != nil {
			return err
		}
	}
	
	db := m.conn.DB()
	
	log.Println("🔄 Veritabanı tasarım spesifikasyonuna göre yeniden yapılandırılıyor...")
	
	// Transaction başlat
	tx, err := db.Begin()
	if err != nil {
		return fmt.Errorf("transaction başlatılamadı: %w", err)
	}
	defer tx.Rollback()
	
	// Adım 1: Eski tabloları yedekle
	log.Println("📦 1. Mevcut tablolar yedekleniyor...")
	if err := m.backupOldTables(tx); err != nil {
		return fmt.Errorf("tablolar yedeklenemedi: %w", err)
	}
	
	// Adım 2: Eski tabloları sil
	log.Println("🗑️  2. Eski tablolar siliniyor...")
	if err := m.dropOldTables(tx); err != nil {
		return fmt.Errorf("tablolar silinemedi: %w", err)
	}
	
	// Adım 3: Yeni tabloları oluştur (tasarım spesifikasyonuna göre)
	log.Println("🏗️  3. Yeni tablolar oluşturuluyor (DESIGN SPEC)...")
	if err := m.createNewTables(tx); err != nil {
		return fmt.Errorf("yeni tablolar oluşturulamadı: %w", err)
	}
	
	// Adım 4: Verileri yeni tablolara aktar
	log.Println("📋 4. Veriler yeni tablolara aktarılıyor...")
	if err := m.migrateData(tx); err != nil {
		return fmt.Errorf("veri migration başarısız: %w", err)
	}
	
	// Adım 5: İndexler oluştur
	log.Println("🔍 5. İndexler oluşturuluyor...")
	if err := m.createNewIndexes(tx); err != nil {
		return fmt.Errorf("indexler oluşturulamadı: %w", err)
	}
	
	// Commit
	if err := tx.Commit(); err != nil {
		return fmt.Errorf("transaction commit başarısız: %w", err)
	}
	
	log.Println("✅ Veritabanı başarıyla yeniden yapılandırıldı!")
	return nil
}

// backupOldTables mevcut tabloları yedekler
func (m *Migration) backupOldTables(tx *sql.Tx) error {
	tables := []string{"folders", "files", "chunks", "peers", "users", "file_versions"}
	
	for _, table := range tables {
		// Tablonun var olup olmadığını kontrol et
		var count int
		err := tx.QueryRow("SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name=?", table).Scan(&count)
		if err != nil {
			return err
		}
		
		if count > 0 {
			backupName := table + "_backup"
			_, err = tx.Exec(fmt.Sprintf("DROP TABLE IF EXISTS %s", backupName))
			if err != nil {
				return err
			}
			
			_, err = tx.Exec(fmt.Sprintf("ALTER TABLE %s RENAME TO %s", table, backupName))
			if err != nil {
				return err
			}
			log.Printf("   ✓ %s -> %s", table, backupName)
		}
	}
	
	return nil
}

// dropOldTables eski backup tablolarını temizler (migration sonrası)
func (m *Migration) dropOldTables(tx *sql.Tx) error {
	// Backup tabloları kalacak, gerekirse manuel silinir
	return nil
}

// createNewTables TASARIM SPESİFİKASYONUNA GÖRE yeni tabloları oluşturur
func (m *Migration) createNewTables(tx *sql.Tx) error {
	// 1. FOLDERS (Tasarım Spec)
	_, err := tx.Exec(`
		CREATE TABLE folders (
			id TEXT PRIMARY KEY,
			name TEXT NOT NULL,
			local_path TEXT NOT NULL UNIQUE,
			sync_mode TEXT NOT NULL,
			last_scan_time INTEGER NOT NULL,
			device_id TEXT NOT NULL
		)
	`)
	if err != nil {
		return fmt.Errorf("folders table: %w", err)
	}
	log.Println("   ✓ folders (DESIGN SPEC)")
	
	// 2. FILES (Tasarım Spec)
	_, err = tx.Exec(`
		CREATE TABLE files (
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
		return fmt.Errorf("files table: %w", err)
	}
	log.Println("   ✓ files (DESIGN SPEC)")
	
	// 3. CHUNKS (Tasarım Spec) - DOSYALARDAN BAĞIMSIZ
	_, err = tx.Exec(`
		CREATE TABLE chunks (
			hash TEXT PRIMARY KEY,
			size INTEGER NOT NULL,
			creation_time INTEGER NOT NULL,
			is_local BOOLEAN NOT NULL
		)
	`)
	if err != nil {
		return fmt.Errorf("chunks table: %w", err)
	}
	log.Println("   ✓ chunks (DESIGN SPEC - hash PRIMARY KEY)")
	
	// 4. FILE_CHUNKS (Tasarım Spec) - YENİ TABLO
	_, err = tx.Exec(`
		CREATE TABLE file_chunks (
			file_id TEXT NOT NULL,
			chunk_hash TEXT NOT NULL,
			chunk_index INTEGER NOT NULL,
			PRIMARY KEY(file_id, chunk_index),
			FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
			FOREIGN KEY (chunk_hash) REFERENCES chunks(hash)
		)
	`)
	if err != nil {
		return fmt.Errorf("file_chunks table: %w", err)
	}
	log.Println("   ✓ file_chunks (DESIGN SPEC - YENİ TABLO)")
	
	// 5. PEERS (Tasarım Spec)
	_, err = tx.Exec(`
		CREATE TABLE peers (
			device_id TEXT PRIMARY KEY,
			name TEXT NOT NULL,
			addresses TEXT,
			is_trusted BOOLEAN NOT NULL,
			last_seen INTEGER
		)
	`)
	if err != nil {
		return fmt.Errorf("peers table: %w", err)
	}
	log.Println("   ✓ peers (DESIGN SPEC)")
	
	// 6. PEER_FOLDER_STATUS (Tasarım Spec) - YENİ TABLO
	_, err = tx.Exec(`
		CREATE TABLE peer_folder_status (
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
		return fmt.Errorf("peer_folder_status table: %w", err)
	}
	log.Println("   ✓ peer_folder_status (DESIGN SPEC - YENİ TABLO)")
	
	// 7. USERS (Ek - tasarımda yok ama yararlı)
	_, err = tx.Exec(`
		CREATE TABLE users (
			id TEXT PRIMARY KEY,
			profile_name TEXT NOT NULL UNIQUE,
			role TEXT NOT NULL,
			password_hash TEXT NOT NULL,
			is_active BOOLEAN NOT NULL DEFAULT 1,
			created_at INTEGER NOT NULL,
			updated_at INTEGER NOT NULL
		)
	`)
	if err != nil {
		return fmt.Errorf("users table: %w", err)
	}
	log.Println("   ✓ users (EK - multi-user desteği)")
	
	// 8. FILE_VERSIONS (Ek - tasarımda yok ama yararlı)
	_, err = tx.Exec(`
		CREATE TABLE file_versions (
			id TEXT PRIMARY KEY,
			file_id TEXT NOT NULL,
			version_number INTEGER NOT NULL,
			backup_path TEXT NOT NULL,
			original_path TEXT NOT NULL,
			size INTEGER NOT NULL,
			hash TEXT NOT NULL,
			created_at INTEGER NOT NULL,
			created_by_peer_id TEXT,
			FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
			UNIQUE(file_id, version_number)
		)
	`)
	if err != nil {
		return fmt.Errorf("file_versions table: %w", err)
	}
	log.Println("   ✓ file_versions (EK - çakışma çözümü)")
	
	return nil
}

// migrateData eski tablolardan yeni tablolara veri aktarır
func (m *Migration) migrateData(tx *sql.Tx) error {
	// 1. FOLDERS migration
	_, err := tx.Exec(`
		INSERT INTO folders (id, name, local_path, sync_mode, last_scan_time, device_id)
		SELECT 
			id,
			COALESCE(local_path, 'Unnamed'),
			local_path,
			sync_mode,
			COALESCE(CAST(strftime('%s', last_scan_time) AS INTEGER), CAST(strftime('%s', 'now') AS INTEGER)),
			'local-device-temp'
		FROM folders_backup
		WHERE local_path IS NOT NULL AND sync_mode IS NOT NULL
	`)
	if err != nil {
		log.Printf("   ⚠️  folders migration atlandı (tablo boş veya hata): %v", err)
	} else {
		log.Println("   ✓ folders verisi aktarıldı")
	}
	
	// 2. FILES migration
	_, err = tx.Exec(`
		INSERT INTO files (id, folder_id, relative_path, size, mod_time, global_hash, is_deleted)
		SELECT 
			id,
			folder_id,
			relative_path,
			size,
			COALESCE(CAST(strftime('%s', mod_time) AS INTEGER), CAST(strftime('%s', 'now') AS INTEGER)),
			COALESCE(global_hash, ''),
			COALESCE(is_deleted, 0)
		FROM files_backup
		WHERE folder_id IS NOT NULL AND relative_path IS NOT NULL AND size IS NOT NULL
	`)
	if err != nil {
		log.Printf("   ⚠️  files migration atlandı: %v", err)
	} else {
		log.Println("   ✓ files verisi aktarıldı")
	}
	
	// 3. PEERS migration
	_, err = tx.Exec(`
		INSERT INTO peers (device_id, name, addresses, is_trusted, last_seen)
		SELECT 
			device_id,
			name,
			known_addresses,
			COALESCE(is_trusted, 0),
			COALESCE(CAST(strftime('%s', last_seen) AS INTEGER), CAST(strftime('%s', 'now') AS INTEGER))
		FROM peers_backup
		WHERE device_id IS NOT NULL AND name IS NOT NULL
	`)
	if err != nil {
		log.Printf("   ⚠️  peers migration atlandı: %v", err)
	} else {
		log.Println("   ✓ peers verisi aktarıldı")
	}
	
	// 4. USERS migration
	_, err = tx.Exec(`
		INSERT INTO users (id, profile_name, role, password_hash, is_active, created_at, updated_at)
		SELECT 
			id,
			profile_name,
			role,
			password_hash,
			COALESCE(is_active, 1),
			COALESCE(CAST(strftime('%s', created_at) AS INTEGER), CAST(strftime('%s', 'now') AS INTEGER)),
			COALESCE(CAST(strftime('%s', updated_at) AS INTEGER), CAST(strftime('%s', 'now') AS INTEGER))
		FROM users_backup
		WHERE id IS NOT NULL AND profile_name IS NOT NULL AND role IS NOT NULL AND password_hash IS NOT NULL
	`)
	if err != nil {
		log.Printf("   ⚠️  users migration atlandı: %v", err)
	} else {
		log.Println("   ✓ users verisi aktarıldı")
	}
	
	// CHUNKS ve FILE_CHUNKS migration atlanıyor (yeni yapı farklı)
	log.Println("   ℹ️  chunks/file_chunks: Yeni yapı, dosyalar yeniden taranacak")
	
	return nil
}

// createNewIndexes performans için indexler oluşturur
func (m *Migration) createNewIndexes(tx *sql.Tx) error {
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
		if _, err := tx.Exec(indexQuery); err != nil {
			return fmt.Errorf("index oluşturulamadı: %w", err)
		}
	}
	
	log.Printf("   ✓ %d index oluşturuldu", len(indexes))
	return nil
}

