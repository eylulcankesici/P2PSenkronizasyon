package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	bolt "go.etcd.io/bbolt"
)

func main() {
	// Kullanıcı dizinini al
	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatal("Kullanıcı dizini alınamadı:", err)
	}

	// BoltDB yolunu oluştur
	dbPath := filepath.Join(homeDir, ".aether", "aether_config.db")

	fmt.Println("🔍 BoltDB Görüntüleyici")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Printf("📂 Veritabanı: %s\n\n", dbPath)

	// Dosyanın var olup olmadığını kontrol et
	if _, err := os.Stat(dbPath); os.IsNotExist(err) {
		log.Fatal("❌ BoltDB dosyası bulunamadı:", dbPath)
	}

	// BoltDB'yi aç (read-only)
	db, err := bolt.Open(dbPath, 0600, &bolt.Options{ReadOnly: true})
	if err != nil {
		log.Fatal("❌ BoltDB açılamadı:", err)
	}
	defer db.Close()

	// Tüm bucket'ları listele
	err = db.View(func(tx *bolt.Tx) error {
		bucketCount := 0
		keyCount := 0

		// Tüm bucket'ları tara
		err := tx.ForEach(func(name []byte, bucket *bolt.Bucket) error {
			bucketCount++
			bucketName := string(name)
			
			fmt.Printf("📦 Bucket: %s\n", bucketName)
			fmt.Println("   ├─ Key-Value Çiftleri:")

			// Bucket'taki tüm key-value çiftlerini listele
			count := 0
			err := bucket.ForEach(func(k, v []byte) error {
				count++
				keyCount++
				
				key := string(k)
				value := string(v)
				
				// Değer çok uzunsa kısalt
				if len(value) > 100 {
					value = value[:100] + "..."
				}
				
				fmt.Printf("   │  • %s: %s\n", key, value)
				return nil
			})
			
			if count == 0 {
				fmt.Println("   │  (Boş)")
			}
			
			fmt.Printf("   └─ Toplam: %d anahtar\n\n", count)
			
			return err
		})

		fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		fmt.Printf("📊 Özet:\n")
		fmt.Printf("   • Toplam Bucket: %d\n", bucketCount)
		fmt.Printf("   • Toplam Anahtar: %d\n", keyCount)
		
		if bucketCount == 0 {
			fmt.Println("\n⚠️  BoltDB boş görünüyor. Henüz hiç ayar kaydedilmemiş olabilir.")
		}

		return err
	})

	if err != nil {
		log.Fatal("❌ Veritabanı okunurken hata:", err)
	}
}

