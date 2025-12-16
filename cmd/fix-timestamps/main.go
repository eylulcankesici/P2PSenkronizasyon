package main

import (
	"context"
	"log"

	"path/filepath"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/infrastructure/database/sqlite"
)

func main() {
	log.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	log.Println("       AETHER - Timestamp Fix Utility")
	log.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	log.Println()

	// Config yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatal("❌ Config yüklenemedi:", err)
	}

	// SQLite bağlantısı
	dbPath := filepath.Join(cfg.App.DataDir, "aether.db")
	conn, err := sqlite.NewConnection(dbPath)
	if err != nil {
		log.Fatal("❌ SQLite bağlantısı oluşturulamadı:", err)
	}
	if err := conn.Open(); err != nil {
		log.Fatal("❌ SQLite bağlantısı açılamadı:", err)
	}
	defer conn.Close()

	ctx := context.Background()

	// files tablosundaki string timestamp'leri Unix timestamp'e çevir
	log.Println("🔧 files tablosu timestamp'leri düzeltiliyor...")

	query := `
		UPDATE files 
		SET mod_time = CAST(strftime('%s', mod_time) AS INTEGER),
		    created_at = CAST(strftime('%s', created_at) AS INTEGER),
		    updated_at = CAST(strftime('%s', updated_at) AS INTEGER)
		WHERE typeof(mod_time) = 'text'
	`

	result, err := conn.DB().ExecContext(ctx, query)
	if err != nil {
		log.Fatal("❌ Update hatası:", err)
	}

	rowsAffected, _ := result.RowsAffected()
	log.Printf("✅ %d dosya güncellendi\n", rowsAffected)

	// folders tablosu
	log.Println("🔧 folders tablosu timestamp'leri düzeltiliyor...")

	query = `
		UPDATE folders
		SET last_scan_time = CAST(strftime('%s', last_scan_time) AS INTEGER),
		    created_at = CAST(strftime('%s', created_at) AS INTEGER),
		    updated_at = CAST(strftime('%s', updated_at) AS INTEGER)
		WHERE typeof(last_scan_time) = 'text'
	`

	result, err = conn.DB().ExecContext(ctx, query)
	if err != nil {
		log.Fatal("❌ Update hatası:", err)
	}

	rowsAffected, _ = result.RowsAffected()
	log.Printf("✅ %d klasör güncellendi\n", rowsAffected)

	log.Println()
	log.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	log.Println("       ✅ Timestamp fix tamamlandı!")
	log.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
}
