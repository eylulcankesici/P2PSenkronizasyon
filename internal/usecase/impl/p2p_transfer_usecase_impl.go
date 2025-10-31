package impl

import (
	"context"
	"fmt"
	"log"
	"path/filepath"

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
func (uc *P2PTransferUseCaseImpl) SyncFileWithPeer(ctx context.Context, peerID, fileID string) error {
	log.Printf("🔄 Dosya senkronize ediliyor: %s <-> %s", fileID, peerID[:8])
	
	// Dosya bilgisini al (fileName için)
	file, err := uc.fileRepo.GetByID(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya bilgisi alınamadı: %w", err)
	}
	
	// Dosyanın file-chunk ilişkilerini al (index bilgisi için)
	fileChunks, err := uc.chunkRepo.GetFileChunks(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya chunk'ları alınamadı: %w", err)
	}
	
	if len(fileChunks) == 0 {
		return fmt.Errorf("dosyanın chunk'ı yok: %s", fileID)
	}
	
	// Bağlantıyı al
	conn, exists := uc.transportProvider.GetConnection(peerID)
	if !exists {
		return fmt.Errorf("peer bağlı değil: %s", peerID)
	}
	
	// Her chunk'ı peer'a gönder (file_id, fileName ve index bilgisiyle)
	for i, fc := range fileChunks {
		log.Printf("  📤 Chunk %d/%d gönderiliyor: %s", i+1, len(fileChunks), fc.ChunkHash[:8])
		
		// Chunk verisini al
		chunkData, err := uc.chunkingUseCase.GetChunkData(ctx, fc.ChunkHash)
		if err != nil {
			return fmt.Errorf("chunk verisi alınamadı [%d]: %w", i, err)
		}
		
		// Chunk'ı file bilgisiyle gönder
		if tcpConn, ok := conn.(interface {
			SendChunkWithFileInfo(ctx context.Context, chunkHash string, data []byte, fileID string, chunkIndex, totalChunks int, fileName string) error
		}); ok {
			log.Printf("  📤 Chunk %d/%d gönderiliyor (fileID: %s, fileName: %s): %s", fc.ChunkIndex+1, len(fileChunks), fileID, file.RelativePath, fc.ChunkHash[:8])
			if err := tcpConn.SendChunkWithFileInfo(ctx, fc.ChunkHash, chunkData, fileID, fc.ChunkIndex, len(fileChunks), file.RelativePath); err != nil {
				return fmt.Errorf("chunk gönderilemedi [%d]: %w", i, err)
			}
		} else {
			// Fallback: normal SendChunk (file bilgisi olmadan)
			if err := conn.SendChunk(ctx, fc.ChunkHash, chunkData); err != nil {
				return fmt.Errorf("chunk gönderilemedi [%d]: %w", i, err)
			}
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

