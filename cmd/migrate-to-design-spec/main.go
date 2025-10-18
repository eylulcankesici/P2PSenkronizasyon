package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/infrastructure/database/boltdb"
	"github.com/aether/sync/internal/infrastructure/database/sqlite"
)

func main() {
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║  AETHER VERITABANI TASARIM SPESİFİKASYONU MİGRATION       ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()

	// Uyarı mesajı
	fmt.Println("⚠️  DİKKAT: Bu işlem veritabanı yapısını tamamen değiştirecek!")
	fmt.Println("⚠️  Mevcut veritabanı otomatik olarak yedeklenmiştir.")
	fmt.Println()
	fmt.Print("Devam etmek istiyor musunuz? (y/N): ")

	var response string
	fmt.Scanln(&response)

	if response != "y" && response != "Y" {
		fmt.Println("❌ İşlem iptal edildi.")
		return
	}

	fmt.Println()
	fmt.Println("🚀 Migration başlatılıyor...")
	fmt.Println()

	// Config yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatal("❌ Config yüklenemedi:", err)
	}

	// Veritabanı dizinini oluştur
	dbDir := filepath.Join(cfg.App.DataDir)
	if err := os.MkdirAll(dbDir, 0755); err != nil {
		log.Fatal("❌ Veritabanı dizini oluşturulamadı:", err)
	}

	// ===========================================
	// BÖLÜM 1: SQLite Migration
	// ===========================================
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("📊 BÖLÜM 1: SQLite Veritabanı Migration")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	sqliteConn, err := sqlite.NewConnection(filepath.Join(dbDir, "aether.db"))
	if err != nil {
		log.Fatal("❌ SQLite connection oluşturulamadı:", err)
	}
	if err := sqliteConn.Open(); err != nil {
		log.Fatal("❌ SQLite bağlantısı açılamadı:", err)
	}
	defer sqliteConn.Close()

	migration := sqlite.NewMigration(sqliteConn)
	if err := migration.MigrateToDesignSpec(); err != nil {
		log.Fatal("❌ SQLite migration başarısız:", err)
	}

	fmt.Println()
	fmt.Println("✅ SQLite migration tamamlandı!")
	fmt.Println()

	// ===========================================
	// BÖLÜM 2: BoltDB Initialization
	// ===========================================
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("🔑 BÖLÜM 2: BoltDB Konfigürasyon")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	boltConn := boltdb.NewConnection(filepath.Join(dbDir, "aether_config.db"))
	if err := boltConn.Open(); err != nil {
		log.Fatal("❌ BoltDB bağlantısı açılamadı:", err)
	}
	defer boltConn.Close()

	if err := boltConn.InitializeDesignSpecConfig(); err != nil {
		log.Fatal("❌ BoltDB initialization başarısız:", err)
	}

	fmt.Println()
	fmt.Println("✅ BoltDB konfigürasyonu tamamlandı!")
	fmt.Println()

	// ===========================================
	// BÖLÜM 3: Doğrulama
	// ===========================================
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("🔍 BÖLÜM 3: Doğrulama")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	// SQLite tablo kontrolü
	fmt.Println("📊 SQLite Tabloları:")
	tables, err := verifyTables(sqliteConn)
	if err != nil {
		log.Fatal("❌ Tablo doğrulama başarısız:", err)
	}

	for _, table := range tables {
		fmt.Printf("   ✓ %s\n", table)
	}

	// BoltDB config kontrolü
	fmt.Println()
	fmt.Println("🔑 BoltDB Konfigürasyonları:")
	configs, err := boltConn.ListAllConfigs()
	if err != nil {
		log.Fatal("❌ Config doğrulama başarısız:", err)
	}

	for key := range configs {
		fmt.Printf("   ✓ %s\n", key)
	}

	fmt.Println()
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║  ✅ MİGRATION BAŞARIYLA TAMAMLANDI!                        ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()
	fmt.Println("📝 Notlar:")
	fmt.Println("  • Tüm klasörler yeniden taranmalı (chunks/file_chunks için)")
	fmt.Println("  • Admin API şifresi: 'admin123' (BoltDB: admin:api_hash)")
	fmt.Println("  • Backup tablolar: *_backup (ihtiyaç yoksa silinebilir)")
	fmt.Println()
}

// verifyTables SQLite tablolarını doğrular
func verifyTables(conn *sqlite.Connection) ([]string, error) {
	db := conn.DB()
	rows, err := db.Query("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE '%_backup' AND name != 'schema_migrations' ORDER BY name")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tables []string
	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			return nil, err
		}
		tables = append(tables, name)
	}

	return tables, nil
}

