package impl

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"log"
	"path/filepath"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/domain/usecase"
	"github.com/aether/sync/pkg/reassembly"
)

// P2PTransferUseCaseImpl P2PTransferUseCase implementasyonu
type P2PTransferUseCaseImpl struct {
	transportProvider transport.TransportProvider
	chunkRepo         repository.ChunkRepository
	fileRepo          repository.FileRepository
	folderRepo        repository.FolderRepository
	chunkingUseCase   usecase.ChunkingUseCase
	fileReassembler   *reassembly.FileReassembler
}

// NewP2PTransferUseCase yeni use case oluşturur
func NewP2PTransferUseCase(
	transportProvider transport.TransportProvider,
	chunkRepo repository.ChunkRepository,
	fileRepo repository.FileRepository,
	folderRepo repository.FolderRepository,
	chunkingUseCase usecase.ChunkingUseCase,
) usecase.P2PTransferUseCase {
	return &P2PTransferUseCaseImpl{
		transportProvider: transportProvider,
		chunkRepo:         chunkRepo,
		fileRepo:          fileRepo,
		folderRepo:        folderRepo,
		chunkingUseCase:   chunkingUseCase,
		fileReassembler:   reassembly.NewFileReassembler(),
	}
}

// SendChunkToPeer chunk'ı peer'a gönderir
func (uc *P2PTransferUseCaseImpl) SendChunkToPeer(ctx context.Context, peerID, chunkHash string) error {
	log.Printf("📤 Chunk gönderiliyor: %s -> %s", chunkHash[:8], peerID[:8])

	// Bağlantıyı al
	conn, exists := uc.transportProvider.GetConnection(peerID)
	if !exists {
		return fmt.Errorf("peer bağlı değil: %s", peerID)
	}

	// Chunk verisini al
	chunkData, err := uc.chunkingUseCase.GetChunkData(ctx, chunkHash)
	if err != nil {
		return fmt.Errorf("chunk verisi alınamadı: %w", err)
	}

	// Chunk'ı gönder
	if err := conn.SendChunk(ctx, chunkHash, chunkData); err != nil {
		return fmt.Errorf("chunk gönderilemedi: %w", err)
	}

	log.Printf("✅ Chunk gönderildi: %s (%d bytes)", chunkHash[:8], len(chunkData))

	return nil
}

// RequestChunkFromPeer peer'dan chunk talep eder
func (uc *P2PTransferUseCaseImpl) RequestChunkFromPeer(ctx context.Context, peerID, chunkHash string) ([]byte, error) {
	log.Printf("📥 Chunk talep ediliyor: %s <- %s", chunkHash[:8], peerID[:8])

	// Bağlantıyı al
	conn, exists := uc.transportProvider.GetConnection(peerID)
	if !exists {
		return nil, fmt.Errorf("peer bağlı değil: %s", peerID)
	}

	// Chunk talep et
	chunkData, err := conn.RequestChunk(ctx, chunkHash)
	if err != nil {
		return nil, fmt.Errorf("chunk alınamadı: %w", err)
	}

	log.Printf("✅ Chunk alındı: %s (%d bytes)", chunkHash[:8], len(chunkData))

	return chunkData, nil
}

// SyncFileWithPeer dosyayı peer ile senkronize eder
// progressCallback her chunk gönderildiğinde çağrılır (opsiyonel)
func (uc *P2PTransferUseCaseImpl) SyncFileWithPeer(ctx context.Context, peerID, fileID string) error {
	return uc.SyncFileWithPeerWithProgress(ctx, peerID, fileID, nil, pb.SyncMode_SYNC_MODE_BIDIRECTIONAL, pb.SyncMode_SYNC_MODE_BIDIRECTIONAL)
}

// SyncFileWithPeerWithProgress dosyayı peer ile senkronize eder ve progress callback'i ile bildirim yapar
func (uc *P2PTransferUseCaseImpl) SyncFileWithPeerWithProgress(ctx context.Context, peerID, fileID string, progressCallback func(completedChunks, totalChunks int, transferredBytes int64), senderSyncMode, receiverSyncMode pb.SyncMode) error {
	log.Printf("🔄 Dosya senkronize ediliyor: %s <-> %s", fileID, peerID[:8])

	// Dosya bilgisini al (fileName için)
	file, err := uc.fileRepo.GetByID(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya bilgisi alınamadı: %w", err)
	}

	// Folder bilgisini al (folderName için)
	folder, err := uc.folderRepo.GetByID(ctx, file.FolderID)
	if err != nil {
		return fmt.Errorf("folder bilgisi alınamadı: %w", err)
	}
	folderName := filepath.Base(folder.LocalPath)

	// Dosyanın file-chunk ilişkilerini al (index bilgisi için)
	fileChunks, err := uc.chunkRepo.GetFileChunks(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya chunk'ları alınamadı: %w", err)
	}

	if len(fileChunks) == 0 {
		return fmt.Errorf("dosyanın chunk'ı yok: %s", fileID)
	}

	log.Printf("  📦 %d chunk bulundu, chunk'lar BAŞTAN (index 0) gönderilmeye başlanıyor: %s", len(fileChunks), fileID[:8])

	// Bağlantıyı al
	conn, exists := uc.transportProvider.GetConnection(peerID)
	if !exists {
		return fmt.Errorf("peer bağlı değil: %s", peerID)
	}

	// Her chunk'ı peer'a gönder (file_id, fileName ve index bilgisiyle)
	// Chunk'lar sıralı olarak baştan gönderilir (chunk_index 0'dan başlar)
	for i, fc := range fileChunks {
		// Context iptal edilmiş mi kontrol et
		select {
		case <-ctx.Done():
			log.Printf("  🛑 Transfer iptal edildi (context cancelled): %s", fileID)
			return ctx.Err()
		default:
			// Devam et
		}

		// Context iptal kontrolü (chunk verisi almadan önce)
		select {
		case <-ctx.Done():
			log.Printf("  🛑 Transfer iptal edildi, chunk verisi alınmadan durduruluyor: %s (chunk %d/%d)", fileID, i+1, len(fileChunks))
			return ctx.Err()
		default:
		}

		// Log azaltıldı - sadece her 50 chunk'ta bir log
		if i%50 == 0 || i == len(fileChunks)-1 {
			log.Printf("  📤 Chunk %d/%d gönderiliyor: %s", i+1, len(fileChunks), fc.ChunkHash[:8])
		}

		// Chunk verisini al
		chunkData, err := uc.chunkingUseCase.GetChunkData(ctx, fc.ChunkHash)
		if err != nil {
			// Context iptal edilmişse özel hata döndür
			if ctx.Err() != nil {
				log.Printf("  🛑 Transfer iptal edildi, chunk verisi alınamadı: %s", fileID)
				return ctx.Err()
			}
			return fmt.Errorf("chunk verisi alınamadı [%d]: %w", i, err)
		}

		// Context iptal kontrolü (hash doğrulamasından önce)
		select {
		case <-ctx.Done():
			log.Printf("  🛑 Transfer iptal edildi, hash doğrulaması öncesi durduruluyor: %s (chunk %d/%d)", fileID, i+1, len(fileChunks))
			return ctx.Err()
		default:
		}

		// Göndermeden önce hash doğrulaması yap (güvenlik için - chunk bozulmuş olabilir)
		// Hash kontrolü: gönderilen chunk'ın hash'i beklenen hash ile eşleşmeli
		actualHash := sha256.Sum256(chunkData)
		actualHashStr := hex.EncodeToString(actualHash[:])
		if actualHashStr != fc.ChunkHash {
			log.Printf("  ⚠️ Chunk hash uyuşmazlığı [%d]: expected=%s, got=%s - chunk tekrar yükleniyor...", i, fc.ChunkHash[:8], actualHashStr[:8])
			// Chunk'ı tekrar yükle (belki disk'te corrupt veya cache sorunu)
			chunkData, err = uc.chunkingUseCase.GetChunkData(ctx, fc.ChunkHash)
			if err != nil {
				return fmt.Errorf("chunk verisi tekrar alınamadı [%d]: %w", i, err)
			}
			// Tekrar doğrula
			actualHash = sha256.Sum256(chunkData)
			actualHashStr = hex.EncodeToString(actualHash[:])
			if actualHashStr != fc.ChunkHash {
				return fmt.Errorf("chunk hash doğrulama başarısız [%d]: expected=%s, got=%s", i, fc.ChunkHash[:8], actualHashStr[:8])
			}
			log.Printf("  ✅ Chunk hash doğrulandı (retry sonrası): %s", fc.ChunkHash[:8])

			// Retry sonrası context kontrolü
			select {
			case <-ctx.Done():
				log.Printf("  🛑 Transfer iptal edildi, retry sonrası durduruluyor: %s (chunk %d/%d)", fileID, i+1, len(fileChunks))
				return ctx.Err()
			default:
			}
		}

		// Context iptal kontrolü (chunk göndermeden önce)
		select {
		case <-ctx.Done():
			log.Printf("  🛑 Transfer iptal edildi, chunk gönderimi başlamadan durduruluyor: %s (chunk %d/%d)", fileID, i+1, len(fileChunks))
			return ctx.Err()
		default:
		}

		// Chunk'ı file + folder bilgisiyle + sync mode ile gönder
		var chunkSentBytes int64
		if tcpConn, ok := conn.(interface {
			SendChunkWithFileInfo(ctx context.Context, chunkHash string, data []byte, fileID string, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error
		}); ok {
			// Log azaltıldı - sadece her 50 chunk'ta bir log
			// log.Printf("  📤 Chunk %d/%d gönderiliyor (fileID: %s, fileName: %s, folderName: %s): %s", fc.ChunkIndex+1, len(fileChunks), fileID, file.RelativePath, folderName, fc.ChunkHash[:8])
			if err := tcpConn.SendChunkWithFileInfo(ctx, fc.ChunkHash, chunkData, fileID, fc.ChunkIndex, len(fileChunks), file.RelativePath, folderName, senderSyncMode, receiverSyncMode); err != nil {
				// Context iptal edilmişse özel hata döndür
				if ctx.Err() != nil {
					log.Printf("  🛑 Transfer iptal edildi, chunk gönderimi durduruluyor: %s (chunk %d/%d)", fileID, i+1, len(fileChunks))
					return fmt.Errorf("transfer iptal edildi: %w", ctx.Err())
				}
				return fmt.Errorf("chunk gönderilemedi [%d]: %w", i, err)
			}
			chunkSentBytes = int64(len(chunkData))
		} else {
			// Fallback: normal SendChunk (file bilgisi olmadan)
			if err := conn.SendChunk(ctx, fc.ChunkHash, chunkData); err != nil {
				// Context iptal edilmişse özel hata döndür
				if ctx.Err() != nil {
					log.Printf("  🛑 Transfer iptal edildi, chunk gönderimi durduruluyor: %s (chunk %d/%d)", fileID, i+1, len(fileChunks))
					return fmt.Errorf("transfer iptal edildi: %w", ctx.Err())
				}
				return fmt.Errorf("chunk gönderilemedi [%d]: %w", i, err)
			}
			chunkSentBytes = int64(len(chunkData))
		}

		// Context iptal kontrolü (progress callback'ten önce)
		select {
		case <-ctx.Done():
			log.Printf("  🛑 Transfer iptal edildi, progress callback öncesi durduruluyor: %s (chunk %d/%d)", fileID, i+1, len(fileChunks))
			return ctx.Err()
		default:
		}

		// Progress callback'i çağır (eğer varsa)
		if progressCallback != nil {
			transferredBytes := chunkSentBytes * int64(i+1) // Tahmin: her chunk gönderildi
			progressCallback(i+1, len(fileChunks), transferredBytes)
		}
	}

	log.Printf("✅ Dosya senkronize edildi: %s (%d chunks)", fileID, len(fileChunks))

	return nil
}

// RequestFileFromPeer dosyayı peer'dan talep eder
func (uc *P2PTransferUseCaseImpl) RequestFileFromPeer(ctx context.Context, peerID, fileID string) error {
	log.Printf("📥 Dosya talep ediliyor: %s <- %s", fileID, peerID[:8])

	// Dosya bilgisini al
	file, err := uc.fileRepo.GetByID(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya bulunamadı: %w", err)
	}

	// Folder bilgisini al (output path için)
	folder, err := uc.folderRepo.GetByID(ctx, file.FolderID)
	if err != nil {
		return fmt.Errorf("folder bulunamadı: %w", err)
	}

	// Dosyanın chunk'larını al
	fileChunks, err := uc.chunkRepo.GetFileChunks(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya chunk'ları alınamadı: %w", err)
	}

	if len(fileChunks) == 0 {
		return fmt.Errorf("dosyanın chunk'ı yok: %s", fileID)
	}

	// Global hash hesapla (chunk hash'lerinden)
	_, err = uc.chunkRepo.GetChunksByFileID(ctx, fileID)
	if err != nil {
		return fmt.Errorf("chunk detayları alınamadı: %w", err)
	}

	globalHash := "" // Placeholder, gerçekte chunk hash'lerinden hesaplanmalı

	// File reassembler'ı initialize et
	if err := uc.fileReassembler.InitializeFile(fileID, len(fileChunks), globalHash); err != nil {
		return fmt.Errorf("reassembler initialize hatası: %w", err)
	}
	defer uc.fileReassembler.CleanupFile(fileID)

	// Her chunk'ı peer'dan talep et ve reassembler'a ekle
	for i, fc := range fileChunks {
		log.Printf("  📥 Chunk %d/%d talep ediliyor: %s", i+1, len(fileChunks), fc.ChunkHash[:8])

		chunkData, err := uc.RequestChunkFromPeer(ctx, peerID, fc.ChunkHash)
		if err != nil {
			return fmt.Errorf("chunk alınamadı [%d]: %w", i, err)
		}

		// Chunk'ı reassembler'a ekle
		if err := uc.fileReassembler.AddChunk(fileID, fc.ChunkIndex, fc.ChunkHash, chunkData); err != nil {
			return fmt.Errorf("chunk eklenemedi [%d]: %w", i, err)
		}

		// Progress göster
		progress := uc.fileReassembler.GetProgress(fileID)
		log.Printf("  📊 Progress: %.1f%% (%d/%d chunks)", progress, i+1, len(fileChunks))
	}

	// Tüm chunk'lar alındı, dosyayı birleştir
	outputPath := filepath.Join(folder.LocalPath, file.RelativePath)
	if err := uc.fileReassembler.WriteToFile(fileID, outputPath); err != nil {
		return fmt.Errorf("dosya yazılamadı: %w", err)
	}

	log.Printf("✅ Dosya başarıyla alındı ve kaydedildi: %s (%d chunks, %d bytes)",
		outputPath, len(fileChunks), file.Size)

	return nil
}

// GetTransferStatus transfer durumunu döner
func (uc *P2PTransferUseCaseImpl) GetTransferStatus(ctx context.Context, fileID string) (*usecase.TransferStatus, error) {
	// Dosya bilgisini al
	file, err := uc.fileRepo.GetByID(ctx, fileID)
	if err != nil {
		return nil, fmt.Errorf("dosya bulunamadı: %w", err)
	}

	// Chunk'ları al
	fileChunks, err := uc.chunkRepo.GetFileChunks(ctx, fileID)
	if err != nil {
		return nil, fmt.Errorf("dosya chunk'ları alınamadı: %w", err)
	}

	// Local chunk'ları say
	localChunkCount := 0
	for _, fc := range fileChunks {
		chunk, err := uc.chunkRepo.GetByHash(ctx, fc.ChunkHash)
		if err == nil && chunk.IsLocal {
			localChunkCount++
		}
	}

	status := &usecase.TransferStatus{
		FileID:            fileID,
		TotalChunks:       len(fileChunks),
		TransferredChunks: localChunkCount,
		TotalBytes:        file.Size,
		TransferredBytes:  file.Size * int64(localChunkCount) / int64(len(fileChunks)),
		IsComplete:        localChunkCount == len(fileChunks),
		PeerID:            "",
	}

	return status, nil
}

// GetPeerLatency peer latency'sini ölçer
func (uc *P2PTransferUseCaseImpl) GetPeerLatency(ctx context.Context, peerID string) (int64, error) {
	// Bağlantıyı al
	conn, exists := uc.transportProvider.GetConnection(peerID)
	if !exists {
		return 0, fmt.Errorf("peer bağlı değil: %s", peerID)
	}

	// Ping gönder
	latency, err := conn.Ping(ctx)
	if err != nil {
		return 0, fmt.Errorf("ping başarısız: %w", err)
	}

	return latency.Milliseconds(), nil
}
