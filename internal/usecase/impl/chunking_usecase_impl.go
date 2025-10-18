package impl

import (
	"context"
	"fmt"
	"log"
	"path/filepath"

	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/usecase"
	"github.com/aether/sync/pkg/chunking"
)

// ChunkingUseCaseImpl ChunkingUseCase'in concrete implementation'ı
// Single Responsibility: Chunking orchestration
// Dependency Inversion: Interface'lere bağımlı, concrete types'a değil
type ChunkingUseCaseImpl struct {
	chunkRepo  repository.ChunkRepository
	fileRepo   repository.FileRepository
	chunker    chunking.Chunker
	storage    chunking.ChunkStorage
	verifier   chunking.ChunkVerifier
}

// NewChunkingUseCase yeni bir ChunkingUseCaseImpl oluşturur (Factory)
func NewChunkingUseCase(
	chunkRepo repository.ChunkRepository,
	fileRepo repository.FileRepository,
	chunker chunking.Chunker,
	storage chunking.ChunkStorage,
	verifier chunking.ChunkVerifier,
) usecase.ChunkingUseCase {
	return &ChunkingUseCaseImpl{
		chunkRepo: chunkRepo,
		fileRepo:  fileRepo,
		chunker:   chunker,
		storage:   storage,
		verifier:  verifier,
	}
}

// ChunkAndStoreFile dosyayı chunk'lara böler, disk'e yazar ve DB'ye kaydeder
// Single Responsibility: Orchestrate chunking process
func (uc *ChunkingUseCaseImpl) ChunkAndStoreFile(
	ctx context.Context,
	fileID, filePath string,
) ([]*entity.Chunk, string, error) {
	log.Printf("📦 Chunking başlatılıyor: %s", filepath.Base(filePath))

	// 1. Dosyayı chunk'lara böl
	chunkResults, err := uc.chunker.ChunkFile(filePath)
	if err != nil {
		return nil, "", fmt.Errorf("dosya chunk'lanamadı: %w", err)
	}

	log.Printf("   ✓ %d chunk oluşturuldu", len(chunkResults))

	// 2. Global hash hesapla
	globalHash := chunking.CalculateFileHash(chunkResults)

	// 3. Chunk'ları işle (DB + Storage)
	chunks := make([]*entity.Chunk, 0, len(chunkResults))

	for i, cr := range chunkResults {
		// Chunk entity oluştur
		chunk := entity.NewChunk(cr.Hash, cr.Size)

		// DB'ye kaydet (deduplication otomatik)
		if err := uc.chunkRepo.Create(ctx, chunk); err != nil {
			return nil, "", fmt.Errorf("chunk DB'ye kaydedilemedi [%d]: %w", i, err)
		}

		// Disk'e kaydet (zaten varsa skip edilir)
		if err := uc.storage.Store(cr.Hash, cr.Data); err != nil {
			return nil, "", fmt.Errorf("chunk disk'e yazılamadı [%d]: %w", i, err)
		}

		// File-Chunk ilişkisi oluştur
		fileChunk := entity.NewFileChunk(fileID, cr.Hash, cr.Index)
		if err := uc.chunkRepo.CreateFileChunk(ctx, fileChunk); err != nil {
			return nil, "", fmt.Errorf("file-chunk ilişkisi oluşturulamadı [%d]: %w", i, err)
		}

		chunks = append(chunks, chunk)
	}

	log.Printf("   ✓ %d chunk kaydedildi (global_hash: %s...)", len(chunks), globalHash[:16])

	return chunks, globalHash, nil
}

// LoadFileChunks bir dosyanın chunk'larını yükler
func (uc *ChunkingUseCaseImpl) LoadFileChunks(ctx context.Context, fileID string) ([]*entity.Chunk, error) {
	// File-chunks ilişkisinden chunk'ları getir
	chunks, err := uc.chunkRepo.GetChunksByFileID(ctx, fileID)
	if err != nil {
		return nil, fmt.Errorf("chunk'lar yüklenemedi: %w", err)
	}

	return chunks, nil
}

// VerifyFileIntegrity dosyanın bütünlüğünü doğrular
// Tüm chunk'ların hash'lerini kontrol eder ve global hash'i doğrular
func (uc *ChunkingUseCaseImpl) VerifyFileIntegrity(
	ctx context.Context,
	fileID string,
	expectedGlobalHash string,
) error {
	// Chunk'ları yükle
	chunks, err := uc.LoadFileChunks(ctx, fileID)
	if err != nil {
		return fmt.Errorf("chunk'lar yüklenemedi: %w", err)
	}

	if len(chunks) == 0 {
		return fmt.Errorf("dosyanın chunk'ları yok")
	}

	// Her chunk'ı doğrula
	chunkResults := make([]*chunking.ChunkResult, 0, len(chunks))

	for i, chunk := range chunks {
		// Chunk verisini disk'ten oku
		data, err := uc.storage.Load(chunk.Hash)
		if err != nil {
			return fmt.Errorf("chunk [%d] yüklenemedi: %w", i, err)
		}

		// ChunkResult oluştur (verification için)
		cr := &chunking.ChunkResult{
			Hash:   chunk.Hash,
			Index:  i,
			Size:   chunk.Size,
			Offset: int64(i) * entity.DefaultChunkSize,
			Data:   data,
		}

		// Chunk'ı doğrula
		if err := uc.verifier.VerifyChunk(cr); err != nil {
			return fmt.Errorf("chunk [%d] doğrulanamadı: %w", i, err)
		}

		chunkResults = append(chunkResults, cr)
	}

	// Global hash doğrula
	if err := chunking.VerifyFile(chunkResults, expectedGlobalHash); err != nil {
		return fmt.Errorf("dosya bütünlüğü doğrulanamadı: %w", err)
	}

	return nil
}

// DeleteFileChunks bir dosyanın chunk'larını siler (DB + disk)
// Deduplication aware: Sadece bu dosyada kullanılan chunk'ları siler
func (uc *ChunkingUseCaseImpl) DeleteFileChunks(ctx context.Context, fileID string) error {
	// Dosyanın chunk'larını getir
	fileChunks, err := uc.chunkRepo.GetFileChunks(ctx, fileID)
	if err != nil {
		return fmt.Errorf("chunk'lar alınamadı: %w", err)
	}

	// Her chunk için referans kontrolü yap
	for _, fc := range fileChunks {
		// Kaç dosyada kullanılıyor?
		refCount, err := uc.chunkRepo.CountChunkReferences(ctx, fc.ChunkHash)
		if err != nil {
			log.Printf("   ⚠️ Chunk referans sayımı başarısız: %s", fc.ChunkHash)
			continue
		}

		// Sadece bu dosyada kullanılıyorsa sil
		if refCount <= 1 {
			// Disk'ten sil
			if err := uc.storage.Delete(fc.ChunkHash); err != nil {
				log.Printf("   ⚠️ Chunk disk'ten silinemedi: %s - %v", fc.ChunkHash, err)
			}

			// DB'den sil
			if err := uc.chunkRepo.Delete(ctx, fc.ChunkHash); err != nil {
				log.Printf("   ⚠️ Chunk DB'den silinemedi: %s - %v", fc.ChunkHash, err)
			}
		}
	}

	// File-chunk ilişkilerini sil
	if err := uc.chunkRepo.DeleteFileChunks(ctx, fileID); err != nil {
		return fmt.Errorf("file-chunk ilişkileri silinemedi: %w", err)
	}

	log.Printf("   ✓ Dosya chunk'ları temizlendi: %s", fileID)

	return nil
}

// GetChunkData chunk verisini disk'ten okur
func (uc *ChunkingUseCaseImpl) GetChunkData(ctx context.Context, hash string) ([]byte, error) {
	// Chunk DB'de var mı kontrol et
	chunk, err := uc.chunkRepo.GetByHash(ctx, hash)
	if err != nil {
		return nil, fmt.Errorf("chunk bulunamadı: %w", err)
	}

	// Local değilse hata
	if !chunk.IsLocal {
		return nil, fmt.Errorf("chunk bu cihazda yok (remote)")
	}

	// Disk'ten oku
	data, err := uc.storage.Load(hash)
	if err != nil {
		return nil, fmt.Errorf("chunk yüklenemedi: %w", err)
	}

	// Bütünlük kontrolü
	if err := uc.verifier.Verify(data, hash); err != nil {
		return nil, fmt.Errorf("chunk bütünlük hatası: %w", err)
	}

	return data, nil
}

// GetDeduplicationStats deduplication istatistiklerini döndürür
func (uc *ChunkingUseCaseImpl) GetDeduplicationStats(
	ctx context.Context,
) (totalChunks, uniqueChunks int64, savingsBytes int64, err error) {
	// Tüm local chunk'ları getir
	chunks, err := uc.chunkRepo.GetLocalChunks(ctx)
	if err != nil {
		return 0, 0, 0, fmt.Errorf("chunk'lar alınamadı: %w", err)
	}

	uniqueChunks = int64(len(chunks))

	// Her chunk için referans sayısını topla
	totalRefs := int64(0)
	totalSize := int64(0)

	for _, chunk := range chunks {
		refCount, err := uc.chunkRepo.CountChunkReferences(ctx, chunk.Hash)
		if err != nil {
			continue
		}

		totalRefs += int64(refCount)
		totalSize += chunk.Size

		// Savings hesapla (deduplication ile kazanılan alan)
		if refCount > 1 {
			savingsBytes += chunk.Size * int64(refCount-1)
		}
	}

	totalChunks = totalRefs

	return totalChunks, uniqueChunks, savingsBytes, nil
}
