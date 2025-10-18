package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"os"
	"path/filepath"

	_ "github.com/mattn/go-sqlite3"
)

func main() {
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║          AETHER CHUNK DEPOSU İNCELEMESİ                   ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()

	// Veritabanı yolu
	homeDir, _ := os.UserHomeDir()
	dbPath := filepath.Join(homeDir, ".aether", "aether.db")
	chunksPath := filepath.Join(homeDir, ".aether", "chunks")

	fmt.Printf("📂 Veritabanı: %s\n", dbPath)
	fmt.Printf("📦 Chunks klasörü: %s\n\n", chunksPath)

	// Veritabanına bağlan
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		log.Fatal("❌ Veritabanı açılamadı:", err)
	}
	defer db.Close()

	ctx := context.Background()

	// 1. Chunks tablosunu incele
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("1. CHUNKS TABLOSU (Meta Veri)")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	rows, err := db.QueryContext(ctx, `
		SELECT hash, size, is_local, creation_time
		FROM chunks
		ORDER BY creation_time DESC
		LIMIT 10
	`)
	if err != nil {
		log.Fatal("❌ Chunks sorgusu başarısız:", err)
	}
	defer rows.Close()

	fmt.Printf("%-70s %10s %8s\n", "HASH", "SIZE", "LOCAL")
	fmt.Println(string(make([]byte, 90)))

	chunkCount := 0
	var totalSize int64
	for rows.Next() {
		var hash string
		var size int64
		var isLocal bool
		var creationTime int64

		rows.Scan(&hash, &size, &isLocal, &creationTime)
		
		localStr := "❌"
		if isLocal {
			localStr = "✅"
		}
		
		fmt.Printf("%-70s %8d KB %5s\n", hash[:64]+"...", size/1024, localStr)
		chunkCount++
		totalSize += size
	}

	fmt.Println()
	fmt.Printf("📊 Toplam: %d chunk, %d KB (%d MB)\n\n", chunkCount, totalSize/1024, totalSize/(1024*1024))

	// 2. File-Chunks ilişkilerini incele
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("2. FILE_CHUNKS TABLOSU (Dosya-Chunk İlişkileri)")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	rows2, err := db.QueryContext(ctx, `
		SELECT fc.file_id, fc.chunk_hash, fc.chunk_index, f.relative_path
		FROM file_chunks fc
		LEFT JOIN files f ON fc.file_id = f.id
		ORDER BY fc.file_id, fc.chunk_index
	`)
	if err != nil {
		log.Fatal("❌ File chunks sorgusu başarısız:", err)
	}
	defer rows2.Close()

	fmt.Printf("%-40s %-25s %5s %s\n", "FILE_ID", "DOSYA ADI", "INDEX", "CHUNK_HASH")
	fmt.Println(string(make([]byte, 120)))

	currentFileID := ""
	for rows2.Next() {
		var fileID, chunkHash string
		var chunkIndex int
		var relativePath sql.NullString

		rows2.Scan(&fileID, &chunkHash, &chunkIndex, &relativePath)

		if fileID != currentFileID {
			if currentFileID != "" {
				fmt.Println()
			}
			currentFileID = fileID
		}

		fileName := "?"
		if relativePath.Valid {
			fileName = relativePath.String
		}

		fmt.Printf("%-40s %-25s %3d    %s...\n", fileID[:min(40, len(fileID))], fileName[:min(25, len(fileName))], chunkIndex, chunkHash[:48])
	}

	fmt.Println()

	// 3. Deduplication istatistikleri
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("3. DEDUPLICATION İSTATİSTİKLERİ")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	var totalRefs, uniqueChunks int64
	db.QueryRowContext(ctx, `SELECT COUNT(*) FROM file_chunks`).Scan(&totalRefs)
	db.QueryRowContext(ctx, `SELECT COUNT(*) FROM chunks`).Scan(&uniqueChunks)

	var totalBytes, uniqueBytes int64
	db.QueryRowContext(ctx, `
		SELECT COALESCE(SUM(c.size), 0)
		FROM file_chunks fc
		JOIN chunks c ON fc.chunk_hash = c.hash
	`).Scan(&totalBytes)

	db.QueryRowContext(ctx, `SELECT COALESCE(SUM(size), 0) FROM chunks`).Scan(&uniqueBytes)

	deduplicationRatio := 0.0
	if totalRefs > 0 {
		deduplicationRatio = float64(uniqueChunks) / float64(totalRefs) * 100
	}

	savings := totalBytes - uniqueBytes

	fmt.Printf("📊 Toplam chunk referansı: %d\n", totalRefs)
	fmt.Printf("🔑 Benzersiz chunk: %d\n", uniqueChunks)
	fmt.Printf("📈 Deduplication oranı: %.1f%%\n", deduplicationRatio)
	fmt.Printf("💾 Disk'te gerçek boyut: %d MB\n", uniqueBytes/(1024*1024))
	fmt.Printf("📦 Toplam referans boyutu: %d MB\n", totalBytes/(1024*1024))
	fmt.Printf("💰 Tasarruf edilen alan: %d MB\n", savings/(1024*1024))
	fmt.Println()

	// 4. Disk üzerindeki chunk dosyalarını kontrol et
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("4. DİSK ÜZERİNDE CHUNK DOSYALARI")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	diskChunkCount := 0
	var diskTotalSize int64

	err = filepath.Walk(chunksPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil // Skip hataları
		}
		if !info.IsDir() {
			diskChunkCount++
			diskTotalSize += info.Size()
			
			// İlk 5 chunk'ı göster
			if diskChunkCount <= 5 {
				relPath, _ := filepath.Rel(chunksPath, path)
				fmt.Printf("  📄 %s (%d KB)\n", relPath, info.Size()/1024)
			}
		}
		return nil
	})

	if diskChunkCount > 5 {
		fmt.Printf("  ... ve %d chunk daha\n", diskChunkCount-5)
	}

	fmt.Println()
	fmt.Printf("📊 Disk'te toplam: %d chunk dosyası, %d MB\n", diskChunkCount, diskTotalSize/(1024*1024))
	fmt.Println()

	// 5. Tutarlılık kontrolü
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("5. TUTARLILIK KONTROLÜ")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	if int64(diskChunkCount) == uniqueChunks {
		fmt.Println("✅ Veritabanı ve disk senkron (chunk sayıları eşleşiyor)")
	} else {
		fmt.Printf("⚠️ Uyumsuzluk: DB'de %d chunk, disk'te %d dosya\n", uniqueChunks, diskChunkCount)
	}

	if diskTotalSize == uniqueBytes {
		fmt.Println("✅ Boyutlar eşleşiyor")
	} else {
		fmt.Printf("⚠️ Boyut farkı: DB=%d MB, Disk=%d MB\n", uniqueBytes/(1024*1024), diskTotalSize/(1024*1024))
	}

	fmt.Println()
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

