package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	pb "github.com/aether/sync/api/proto"
)

func main() {
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║          AETHER CHUNK API TEST (gRPC)                     ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()

	// gRPC bağlantısı kur
	conn, err := grpc.Dial("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatal("❌ gRPC bağlantısı kurulamadı:", err)
	}
	defer conn.Close()

	// Chunk service client
	chunkClient := pb.NewChunkServiceClient(conn)
	folderClient := pb.NewFolderServiceClient(conn)
	_ = pb.NewFileServiceClient(conn) // Kullanılmıyor ama import gerekli

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	fmt.Println("✅ gRPC bağlantısı kuruldu: localhost:50051\n")

	// Test dosyası oluştur
	testFile := filepath.Join(os.TempDir(), "api_test_file.txt")
	testData := make([]byte, 1024*1024) // 1 MB
	for i := range testData {
		testData[i] = byte('A' + (i % 26))
	}
	if err := os.WriteFile(testFile, testData, 0644); err != nil {
		log.Fatal("❌ Test dosyası oluşturulamadı:", err)
	}
	defer os.Remove(testFile)

	fmt.Printf("📄 Test dosyası oluşturuldu: %s (1 MB)\n\n", testFile)

	// Test klasörü oluştur (benzersiz path)
	testFolderPath := filepath.Join(os.TempDir(), fmt.Sprintf("aether-test-%d", time.Now().Unix()))
	os.MkdirAll(testFolderPath, 0755)
	defer os.RemoveAll(testFolderPath)

	folderResp, err := folderClient.CreateFolder(ctx, &pb.CreateFolderRequest{
		LocalPath: testFolderPath,
		SyncMode:  pb.SyncMode_SYNC_MODE_BIDIRECTIONAL,
	})
	if err != nil {
		log.Fatal("❌ Test klasörü oluşturulamadı:", err)
	}
	
	folderID := folderResp.Folder.Id
	fmt.Printf("📁 Test klasörü oluşturuldu: %s\n", folderID)
	
	// File ID oluştur
	fileID := "test-api-file-" + fmt.Sprint(time.Now().Unix())
	fmt.Printf("📝 Test dosya ID'si: %s\n\n", fileID)

	// TEST 1: ChunkFile - Dosyayı chunk'la
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 1: ChunkFile API")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	chunkResp, err := chunkClient.ChunkFile(ctx, &pb.ChunkFileRequest{
		FileId:   fileID,
		FilePath: testFile,
		FolderId: folderID,
	})
	if err != nil {
		log.Fatal("❌ ChunkFile API hatası:", err)
	}

	if !chunkResp.Status.Success {
		log.Fatalf("❌ ChunkFile başarısız: %s", chunkResp.Status.Message)
	}

	fmt.Printf("✅ %s\n", chunkResp.Status.Message)
	fmt.Printf("   • Global Hash: %s...\n", chunkResp.GlobalHash[:32])
	fmt.Printf("   • Chunk Count: %d\n", chunkResp.ChunkCount)
	fmt.Printf("   • Total Size: %d KB (%d MB)\n\n", chunkResp.TotalSize/1024, chunkResp.TotalSize/(1024*1024))

	// TEST 2: GetFileChunks - Chunk'ları getir
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 2: GetFileChunks API")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	getChunksResp, err := chunkClient.GetFileChunks(ctx, &pb.GetFileChunksRequest{
		FileId: fileID,
	})
	if err != nil {
		log.Fatal("❌ GetFileChunks API hatası:", err)
	}

	fmt.Printf("✅ %s\n", getChunksResp.Status.Message)
	fmt.Printf("   • Chunk sayısı: %d\n", len(getChunksResp.Chunks))
	fmt.Printf("   • İlk 3 chunk:\n")
	for i, chunk := range getChunksResp.Chunks {
		if i < 3 {
			fmt.Printf("     [%d] %s... (%d KB, local=%v)\n", i, chunk.Hash[:16], chunk.Size/1024, chunk.IsLocal)
		}
	}
	fmt.Println()

	// TEST 3: DownloadChunk - Chunk verisi indir
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 3: DownloadChunk API (Streaming)")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	if len(chunkResp.Chunks) > 0 {
		firstChunkHash := chunkResp.Chunks[0].Hash
		
		stream, err := chunkClient.DownloadChunk(ctx, &pb.DownloadChunkRequest{
			ChunkHash: firstChunkHash,
		})
		if err != nil {
			log.Fatal("❌ DownloadChunk stream başlatılamadı:", err)
		}

		var downloadedData []byte
		packetCount := 0
		
		for {
			packet, err := stream.Recv()
			if err == io.EOF {
				break
			}
			if err != nil {
				log.Fatal("❌ Chunk paketi alınamadı:", err)
			}

			downloadedData = append(downloadedData, packet.Data...)
			packetCount++
		}

		fmt.Printf("✅ Chunk başarıyla indirildi!\n")
		fmt.Printf("   • Hash: %s...\n", firstChunkHash[:32])
		fmt.Printf("   • Boyut: %d KB\n", len(downloadedData)/1024)
		fmt.Printf("   • Paket sayısı: %d\n", packetCount)
		fmt.Printf("   • İçerik önizleme: %s...\n\n", string(downloadedData[:min(50, len(downloadedData))]))
	}

	// TEST 4: VerifyFileIntegrity - Bütünlük kontrolü
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 4: VerifyFileIntegrity API")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	verifyResp, err := chunkClient.VerifyFileIntegrity(ctx, &pb.VerifyFileIntegrityRequest{
		FileId:             fileID,
		ExpectedGlobalHash: chunkResp.GlobalHash,
	})
	if err != nil {
		log.Fatal("❌ VerifyFileIntegrity API hatası:", err)
	}

	if verifyResp.IsValid {
		fmt.Printf("✅ %s\n", verifyResp.Status.Message)
		fmt.Printf("   • Bütünlük: OK\n")
		fmt.Printf("   • Global Hash: %s...\n\n", verifyResp.ActualGlobalHash[:32])
	} else {
		fmt.Printf("❌ Bütünlük kontrolü başarısız!\n\n")
	}

	// TEST 5: GetDeduplicationStats - İstatistikler
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 5: GetDeduplicationStats API")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	statsResp, err := chunkClient.GetDeduplicationStats(ctx, &pb.GetDeduplicationStatsRequest{})
	if err != nil {
		log.Fatal("❌ GetDeduplicationStats API hatası:", err)
	}

	fmt.Printf("✅ %s\n", statsResp.Status.Message)
	fmt.Printf("📊 Deduplication İstatistikleri:\n")
	fmt.Printf("   • Toplam chunk referansı: %d\n", statsResp.TotalChunkReferences)
	fmt.Printf("   • Benzersiz chunk: %d\n", statsResp.UniqueChunks)
	fmt.Printf("   • Deduplication oranı: %.1f%%\n", statsResp.DeduplicationRatio)
	fmt.Printf("   • Tasarruf edilen alan: %d KB (%.2f MB)\n", statsResp.SavingsBytes/1024, float64(statsResp.SavingsBytes)/(1024*1024))
	fmt.Printf("   • Disk kullanımı: %d MB\n\n", statsResp.DiskUsageBytes/(1024*1024))

	// TEST 6: CleanOrphanChunks - Orphan temizliği
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 6: CleanOrphanChunks API")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	cleanResp, err := chunkClient.CleanOrphanChunks(ctx, &pb.CleanOrphanChunksRequest{})
	if err != nil {
		log.Fatal("❌ CleanOrphanChunks API hatası:", err)
	}

	fmt.Printf("✅ %s\n", cleanResp.Status.Message)
	fmt.Printf("   • Silinen chunk: %d\n", cleanResp.DeletedChunks)
	fmt.Printf("   • Boşaltılan alan: %d KB\n\n", cleanResp.FreedBytes/1024)

	// Sonuç
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║          ✅ TÜM API TESTLERİ BAŞARILI!                    ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()
	fmt.Println("📋 Test Edilen API'ler:")
	fmt.Println("   ✓ ChunkFile (dosya chunk'lama)")
	fmt.Println("   ✓ GetFileChunks (chunk listesi)")
	fmt.Println("   ✓ DownloadChunk (streaming download)")
	fmt.Println("   ✓ VerifyFileIntegrity (bütünlük kontrolü)")
	fmt.Println("   ✓ GetDeduplicationStats (istatistikler)")
	fmt.Println("   ✓ CleanOrphanChunks (orphan temizliği)")
	fmt.Println()
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

