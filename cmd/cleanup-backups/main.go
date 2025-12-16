package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/infrastructure/database/sqlite"
)

func main() {
	fmt.Println("🗑️  Aether - Backup Tablolarını Temizleme")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	// Uyarı
	fmt.Println("⚠️  Bu işlem aşağıdaki backup tablolarını SİLECEK:")
	fmt.Println("  • chunks_backup")
	fmt.Println("  • file_versions_backup")
	fmt.Println("  • files_backup")
	fmt.Println("  • folders_backup")
	fmt.Println("  • peers_backup")
	fmt.Println("  • users_backup")
	fmt.Println()
	fmt.Print("Devam etmek istiyor musunuz? (y/N): ")

	var response string
	fmt.Scanln(&response)

	if response != "y" && response != "Y" {
		fmt.Println("❌ İşlem iptal edildi.")
		return
	}

	fmt.Println()

	// Config yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatal("❌ Config yüklenemedi:", err)
	}

	// SQLite bağlantısı
	dbPath := filepath.Join(cfg.App.DataDir, "aether.db")
	conn, err := sqlite.NewConnection(dbPath)
	if err != nil {
		log.Fatal("❌ SQLite connection oluşturulamadı:", err)
	}

	if err := conn.Open(); err != nil {
		log.Fatal("❌ Veritabanı açılamadı:", err)
	}
	defer conn.Close()

	db := conn.DB()

	// Backup tablolarını sil
	backupTables := []string{
		"chunks_backup",
		"file_versions_backup",
		"files_backup",
		"folders_backup",
		"peers_backup",
		"users_backup",
	}

	deletedCount := 0
	for _, table := range backupTables {
		_, err := db.Exec(fmt.Sprintf("DROP TABLE IF EXISTS %s", table))
		if err != nil {
			fmt.Printf("⚠️  %s silinemedi: %v\n", table, err)
		} else {
			fmt.Printf("✓ %s silindi\n", table)
			deletedCount++
		}
	}

	fmt.Println()
	fmt.Printf("✅ %d backup tablosu başarıyla temizlendi!\n", deletedCount)

	// Veritabanı boyutu optimizasyonu
	fmt.Println()
	fmt.Println("🔧 Veritabanı optimizasyonu yapılıyor (VACUUM)...")
	_, err = db.Exec("VACUUM")
	if err != nil {
		fmt.Printf("⚠️  VACUUM başarısız: %v\n", err)
	} else {
		fmt.Println("✅ Veritabanı optimize edildi!")
	}

	// Veritabanı istatistikleri
	fmt.Println()
	fmt.Println("📊 Veritabanı İstatistikleri:")

	var pageCount, pageSize int64
	db.QueryRow("PRAGMA page_count").Scan(&pageCount)
	db.QueryRow("PRAGMA page_size").Scan(&pageSize)

	dbSize := pageCount * pageSize / 1024 // KB
	fmt.Printf("  • Veritabanı Boyutu: %d KB\n", dbSize)

	// Tablo sayısı
	var tableCount int
	db.QueryRow("SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'").Scan(&tableCount)
	fmt.Printf("  • Toplam Tablo: %d\n", tableCount)

	// Dosya boyutu
	fileInfo, err := os.Stat(dbPath)
	if err == nil {
		fmt.Printf("  • Disk Boyutu: %d KB\n", fileInfo.Size()/1024)
	}

	fmt.Println()
	fmt.Println("✅ Temizleme tamamlandı!")
}
