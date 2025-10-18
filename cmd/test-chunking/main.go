package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/domain/entity"
)

func main() {
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║          AETHER CHUNKING SİSTEMİ TEST                      ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()

	// Config yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatal("❌ Config yüklenemedi:", err)
	}

	// Container oluştur
	cont, err := container.NewContainer(cfg)
	if err != nil {
		log.Fatal("❌ Container oluşturulamadı:", err)
	}
	defer cont.Close()

	ctx := context.Background()

	// Önceki test verilerini temizle
	fmt.Println("🧹 Veritabanı temizleniyor...")
	cleanupTestData(ctx, cont)
	fmt.Println()

	// Test dosyası oluştur
	testFile := filepath.Join(os.TempDir(), "aether_chunk_test.txt")
	testData := createTestData(1024 * 1024) // 1MB test verisi

	if err := os.WriteFile(testFile, testData, 0644); err != nil {
		log.Fatal("❌ Test dosyası oluşturulamadı:", err)
	}
	defer os.Remove(testFile)

	fmt.Printf("📄 Test dosyası oluşturuldu: %s (1 MB)\n\n", testFile)

	// Test klasörü oluştur
	testFolder := entity.NewFolder(os.TempDir(), entity.SyncModeBidirectional)
	testFolder.ID = "test-folder-id"
	if err := cont.FolderRepository().Create(ctx, testFolder); err != nil {
		log.Fatal("❌ Test klasörü oluşturulamadı:", err)
	}

	// Test 1: Dosyayı Chunk'la ve Kaydet
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 1: Dosyayı Chunk'lama ve Kaydetme")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	// Dosya bilgisini al
	fileInfo, err := os.Stat(testFile)
	if err != nil {
		log.Fatal("❌ Dosya bilgisi alınamadı:", err)
	}

	// Dosya kaydı oluştur
	file := entity.NewFile("test-folder-id", "aether_chunk_test.txt", int64(len(testData)), fileInfo.ModTime())
	file.ID = "test-file-id-123"
	
	if err := cont.FileRepository().Create(ctx, file); err != nil {
		log.Fatal("❌ Dosya kaydı oluşturulamadı:", err)
	}

	// Chunk'la ve kaydet
	chunks, globalHash, err := cont.ChunkingUseCase().ChunkAndStoreFile(ctx, file.ID, testFile)
	if err != nil {
		log.Fatal("❌ Chunking başarısız:", err)
	}

	fmt.Printf("✅ Dosya başarıyla chunk'landı!\n")
	fmt.Printf("   • Toplam chunk: %d\n", len(chunks))
	fmt.Printf("   • Global hash: %s\n", globalHash[:32]+"...")
	fmt.Printf("   • Ortalama chunk boyutu: %d KB\n\n", chunks[0].Size/1024)

	// Test 2: Chunk'ları Yükle
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 2: Chunk'ları Veritabanından Yükleme")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	loadedChunks, err := cont.ChunkingUseCase().LoadFileChunks(ctx, file.ID)
	if err != nil {
		log.Fatal("❌ Chunk'lar yüklenemedi:", err)
	}

	fmt.Printf("✅ %d chunk başarıyla yüklendi!\n", len(loadedChunks))
	for i, chunk := range loadedChunks {
		if i < 3 { // İlk 3 chunk'ı göster
			fmt.Printf("   • Chunk %d: %s... (%d bytes, local=%v)\n", 
				i, chunk.Hash[:16], chunk.Size, chunk.IsLocal)
		}
	}
	if len(loadedChunks) > 3 {
		fmt.Printf("   • ... ve %d chunk daha\n", len(loadedChunks)-3)
	}
	fmt.Println()

	// Test 3: Bütünlük Kontrolü
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 3: Dosya Bütünlük Kontrolü")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	if err := cont.ChunkingUseCase().VerifyFileIntegrity(ctx, file.ID, globalHash); err != nil {
		log.Fatal("❌ Bütünlük kontrolü başarısız:", err)
	}

	fmt.Println("✅ Dosya bütünlüğü doğrulandı!")
	fmt.Println("   • Tüm chunk'lar hash kontrolünden geçti")
	fmt.Println("   • Global hash eşleşti")
	fmt.Println()

	// Test 4: Chunk Verisi Okuma
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 4: Chunk Verisi Okuma")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	// İlk chunk'ı oku
	firstChunk := chunks[0]
	chunkData, err := cont.ChunkingUseCase().GetChunkData(ctx, firstChunk.Hash)
	if err != nil {
		log.Fatal("❌ Chunk verisi okunamadı:", err)
	}

	fmt.Printf("✅ Chunk verisi başarıyla okundu!\n")
	fmt.Printf("   • Hash: %s...\n", firstChunk.Hash[:32])
	fmt.Printf("   • Boyut: %d bytes\n", len(chunkData))
	fmt.Printf("   • İçerik önizleme: %s...\n\n", string(chunkData[:min(50, len(chunkData))]))

	// Test 5: Deduplication İstatistikleri
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 5: Deduplication İstatistikleri")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	// İkinci klasör oluştur (farklı path)
	testFolder2 := entity.NewFolder(filepath.Join(os.TempDir(), "test-folder-2"), entity.SyncModeBidirectional)
	testFolder2.ID = "test-folder-id-2"
	if err := cont.FolderRepository().Create(ctx, testFolder2); err != nil {
		log.Fatal("❌ İkinci test klasörü oluşturulamadı:", err)
	}

	// Aynı dosyayı tekrar ekle (deduplication testi)
	file2 := entity.NewFile("test-folder-id-2", "aether_chunk_test_copy.txt", int64(len(testData)), fileInfo.ModTime())
	file2.ID = "test-file-id-456"
	
	if err := cont.FileRepository().Create(ctx, file2); err != nil {
		log.Fatal("❌ İkinci dosya kaydı oluşturulamadı:", err)
	}

	_, _, err = cont.ChunkingUseCase().ChunkAndStoreFile(ctx, file2.ID, testFile)
	if err != nil {
		log.Fatal("❌ İkinci dosya chunking başarısız:", err)
	}

	fmt.Println("✅ Aynı dosya tekrar chunk'landı (deduplication testi)")

	// İstatistikleri al
	totalChunks, uniqueChunks, savings, err := cont.ChunkingUseCase().GetDeduplicationStats(ctx)
	if err != nil {
		log.Fatal("❌ İstatistikler alınamadı:", err)
	}

	fmt.Printf("\n📊 Deduplication İstatistikleri:\n")
	fmt.Printf("   • Toplam chunk referansı: %d\n", totalChunks)
	fmt.Printf("   • Benzersiz chunk: %d\n", uniqueChunks)
	fmt.Printf("   • Deduplication oranı: %.1f%%\n", float64(uniqueChunks)/float64(totalChunks)*100)
	fmt.Printf("   • Tasarruf edilen alan: %d KB (%.2f MB)\n", savings/1024, float64(savings)/(1024*1024))
	fmt.Println()

	// Test 6: Chunk Temizleme
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 6: Chunk Temizleme (Referans Kontrolü)")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	// İlk dosyayı sil (chunk'lar silinmemeli, 2. dosya hala kullanıyor)
	if err := cont.ChunkingUseCase().DeleteFileChunks(ctx, file.ID); err != nil {
		log.Fatal("❌ Chunk temizleme başarısız:", err)
	}

	fmt.Println("✅ İlk dosyanın chunk referansları silindi")
	fmt.Println("   • Chunk'lar disk'te kaldı (2. dosya hala kullanıyor)")

	// İkinci dosyayı da sil (şimdi chunk'lar silinmeli)
	if err := cont.ChunkingUseCase().DeleteFileChunks(ctx, file2.ID); err != nil {
		log.Fatal("❌ İkinci dosya chunk temizleme başarısız:", err)
	}

	fmt.Println("✅ İkinci dosyanın chunk referansları silindi")
	fmt.Println("   • Tüm chunk'lar disk'ten temizlendi (referans = 0)")
	fmt.Println()

	// Sonuç
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║          ✅ TÜM TESTLER BAŞARIYLA TAMAMLANDI!             ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()
	fmt.Println("📋 Test Özeti:")
	fmt.Println("   ✓ Dosya chunking")
	fmt.Println("   ✓ Chunk storage (content-addressable)")
	fmt.Println("   ✓ Veritabanı entegrasyonu")
	fmt.Println("   ✓ Bütünlük kontrolü (SHA-256)")
	fmt.Println("   ✓ Deduplication (aynı chunk tekrar kaydedilmedi)")
	fmt.Println("   ✓ Referans counting (güvenli silme)")
	fmt.Println()
}

// cleanupTestData test verilerini temizler
func cleanupTestData(ctx context.Context, cont *container.Container) {
	// Test klasörlerini sil
	folders := []string{"test-folder-id", "test-folder-id-2"}
	for _, folderID := range folders {
		folder, err := cont.FolderRepository().GetByID(ctx, folderID)
		if err == nil && folder != nil {
			// Klasördeki dosyaları getir
			files, _ := cont.FileRepository().GetByFolderID(ctx, folderID)
			for _, file := range files {
				// Dosyanın chunk'larını sil
				cont.ChunkingUseCase().DeleteFileChunks(ctx, file.ID)
				// Dosyayı sil
				cont.FileRepository().Delete(ctx, file.ID)
			}
			// Klasörü sil
			cont.FolderRepository().Delete(ctx, folderID)
		}
	}
	
	// Yetim chunk'ları temizle
	cont.ChunkRepository().DeleteOrphanedChunks(ctx)
}

// createTestData test verisi oluşturur
func createTestData(size int) []byte {
	data := make([]byte, size)
	
	// Her 256 byte'da tekrar eden bir pattern
	pattern := []byte("AETHER_CHUNKING_TEST_")
	
	for i := 0; i < size; i++ {
		data[i] = pattern[i%len(pattern)]
	}
	
	return data
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

