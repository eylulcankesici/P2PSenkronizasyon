package p2p

import (
	"context"
	"log"
	"sync"
	"time"

	pb "github.com/aether/sync/api/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// TransferManager transfer durumlarını yönetir
type TransferManager struct {
	mu        sync.RWMutex
	transfers map[string]*TransferInfo // fileID -> TransferInfo
}

// TransferInfo transfer bilgisi
type TransferInfo struct {
	FileID          string
	FileName        string
	PeerID          string
	PeerName        string
	Direction       pb.TransferDirection // SEND veya RECEIVE
	State           pb.TransferState      // ACTIVE, COMPLETED, FAILED, CANCELLED
	TotalChunks     int32
	CompletedChunks int32
	TotalBytes      int64
	TransferredBytes int64
	StartTime       time.Time
	EndTime         *time.Time
	Error           error
	lastUpdate      time.Time
	ctx             context.Context // Transfer context'i (iptal için)
	cancel          context.CancelFunc // Cancel fonksiyonu
}

// NewTransferManager yeni transfer manager oluşturur
func NewTransferManager() *TransferManager {
	return &TransferManager{
		transfers: make(map[string]*TransferInfo),
	}
}

// StartTransfer transfer başlatır (gönderme veya alma)
func (m *TransferManager) StartTransfer(fileID, fileName, peerID, peerName string, direction pb.TransferDirection, totalChunks int32, totalBytes int64) {
	m.mu.Lock()
	defer m.mu.Unlock()

	// Eğer önceki bir transfer varsa, durumuna göre temizle
	// Yeni transfer başlatılırken her durumda (CANCELLED, FAILED, ACTIVE) eski transfer temizlenir
	if existingTransfer, exists := m.transfers[fileID]; exists {
		log.Printf("  🗑️🗑️🗑️ ÖNCEKİ TRANSFER BULUNDU VE TEMİZLENİYOR")
		log.Printf("      Old State: %v, Direction: %v, FileID: %s", existingTransfer.State, existingTransfer.Direction, fileID[:8])
		
		// Context'i iptal et (eğer hala aktifse)
		if existingTransfer.cancel != nil {
			existingTransfer.cancel()
			log.Printf("      ✓ Context iptal edildi")
		}
		
		// Transfer'i map'ten kaldır (yeni transfer başlatılacak)
		// Her durumda (CANCELLED, FAILED, ACTIVE) temizle - aynı fileID ile yeni transfer başlatılıyor
		delete(m.transfers, fileID)
		log.Printf("      ✓ Map'ten kaldırıldı")
		log.Printf("  ✅✅✅ ÖNCEKİ TRANSFER TAMAMEN TEMİZLENDİ: %s", fileID[:8])
	} else {
		log.Printf("  ✓ Önceki transfer bulunamadı (ilk transfer): %s", fileID[:8])
	}

	// Cancel context oluştur (yeni context - önceki context ile hiçbir ilişkisi yok)
	ctx, cancel := context.WithCancel(context.Background())
	
	log.Printf("  🆕🆕🆕 YENİ TRANSFER BAŞLATILIYOR")
	log.Printf("      FileID: %s, FileName: %s", fileID[:8], fileName)
	log.Printf("      Direction: %v, TotalChunks: %d, TotalBytes: %d", direction, totalChunks, totalBytes)

	m.transfers[fileID] = &TransferInfo{
		FileID:          fileID,
		FileName:        fileName,
		PeerID:          peerID,
		PeerName:        peerName,
		Direction:       direction,
		State:           pb.TransferState_TRANSFER_STATE_ACTIVE,
		TotalChunks:     totalChunks,
		CompletedChunks: 0,
		TotalBytes:      totalBytes,
		TransferredBytes: 0,
		StartTime:       time.Now(),
		lastUpdate:      time.Now(),
		ctx:             ctx,
		cancel:          cancel,
	}
	
	log.Printf("  ✅✅✅ YENİ TRANSFER MAP'E EKLENDİ (ACTIVE STATE): %s", fileID[:8])
}

// UpdateChunkProgress chunk progress'ini günceller
func (m *TransferManager) UpdateChunkProgress(fileID string, completedChunks int32, transferredBytes int64) {
	m.mu.Lock()
	defer m.mu.Unlock()

	transfer, exists := m.transfers[fileID]
	if !exists {
		return
	}

	// Transfer iptal edilmişse veya context iptal edilmişse güncelleme yapma
	if transfer.State == pb.TransferState_TRANSFER_STATE_CANCELLED {
		return
	}
	
	// Context iptal edilmişse transfer'i iptal olarak işaretle
	if transfer.ctx != nil {
		select {
		case <-transfer.ctx.Done():
			// Context iptal edilmiş, transfer'i iptal olarak işaretle
			transfer.State = pb.TransferState_TRANSFER_STATE_CANCELLED
			now := time.Now()
			transfer.EndTime = &now
			return
		default:
			// Devam et
		}
	}

	transfer.CompletedChunks = completedChunks
	transfer.TransferredBytes = transferredBytes
	transfer.lastUpdate = time.Now()

	// Tamamlandı mı kontrol et
	if transfer.CompletedChunks >= transfer.TotalChunks && transfer.TotalChunks > 0 {
		now := time.Now()
		transfer.EndTime = &now
		transfer.State = pb.TransferState_TRANSFER_STATE_COMPLETED
	}
}

// CompleteTransfer transfer'i tamamlandı olarak işaretle
func (m *TransferManager) CompleteTransfer(fileID string) {
	m.mu.Lock()
	defer m.mu.Unlock()

	transfer, exists := m.transfers[fileID]
	if !exists {
		return
	}

	now := time.Now()
	transfer.EndTime = &now
	transfer.State = pb.TransferState_TRANSFER_STATE_COMPLETED
	transfer.CompletedChunks = transfer.TotalChunks
	transfer.TransferredBytes = transfer.TotalBytes
	transfer.lastUpdate = time.Now()
}

// FailTransfer transfer'i başarısız olarak işaretle
func (m *TransferManager) FailTransfer(fileID string, err error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	transfer, exists := m.transfers[fileID]
	if !exists {
		return
	}

	now := time.Now()
	transfer.EndTime = &now
	transfer.State = pb.TransferState_TRANSFER_STATE_FAILED
	transfer.Error = err
	transfer.lastUpdate = time.Now()
}

// CancelTransfer transfer'i iptal et
func (m *TransferManager) CancelTransfer(fileID string) {
	m.mu.Lock()
	defer m.mu.Unlock()

	transfer, exists := m.transfers[fileID]
	if !exists {
		return
	}

	// Context'i iptal et (transfer döngüsü durur)
	if transfer.cancel != nil {
		transfer.cancel()
		log.Printf("  🛑 Transfer context iptal edildi: %s", fileID)
	}

	now := time.Now()
	transfer.EndTime = &now
	transfer.State = pb.TransferState_TRANSFER_STATE_CANCELLED
	transfer.lastUpdate = time.Now()
	
	// Transfer'i map'ten hemen kaldır (yeni transfer için yer aç)
	// Goroutine'in durması için 300ms beklenecek (SyncFileWithPeerTracked içinde)
	delete(m.transfers, fileID)
	log.Printf("  🗑️ Transfer CANCELLED ve map'ten kaldırıldı: %s", fileID)
}

// ForceRemoveTransfer transfer'i zorla map'ten kaldırır (güvenlik için)
func (m *TransferManager) ForceRemoveTransfer(fileID string) {
	m.mu.Lock()
	defer m.mu.Unlock()
	
	if _, exists := m.transfers[fileID]; exists {
		delete(m.transfers, fileID)
		log.Printf("  🗑️ Transfer zorla map'ten kaldırıldı: %s", fileID)
	}
}

// GetTransfer transfer bilgisini getirir
func (m *TransferManager) GetTransfer(fileID string) (*TransferInfo, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	transfer, exists := m.transfers[fileID]
	return transfer, exists
}

// GetTransferContext transfer'in cancel context'ini döner
func (m *TransferManager) GetTransferContext(fileID string) (context.Context, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	transfer, exists := m.transfers[fileID]
	if !exists || transfer.ctx == nil {
		return nil, false
	}
	
	// CANCELLED, FAILED veya COMPLETED transfer'ler için context döndürme
	// Sadece ACTIVE transfer'ler için context döndür
	if transfer.State != pb.TransferState_TRANSFER_STATE_ACTIVE {
		log.Printf("  ⚠️ Transfer ACTIVE değil (state: %v), context döndürülmüyor: %s", transfer.State, fileID[:8])
		return nil, false
	}
	
	return transfer.ctx, true
}

// ListTransfers tüm transferleri listeler (filtre ile)
func (m *TransferManager) ListTransfers(ctx context.Context, activeOnly, completedOnly, failedOnly bool) []*TransferInfo {
	m.mu.RLock()
	defer m.mu.RUnlock()

	result := make([]*TransferInfo, 0, len(m.transfers))

	for _, transfer := range m.transfers {
		// Filtrele
		if activeOnly && transfer.State != pb.TransferState_TRANSFER_STATE_ACTIVE {
			continue
		}
		if completedOnly && transfer.State != pb.TransferState_TRANSFER_STATE_COMPLETED {
			continue
		}
		if failedOnly && transfer.State != pb.TransferState_TRANSFER_STATE_FAILED {
			continue
		}

		// Eğer hiçbir filtre yoksa, tüm transferleri döndür (CANCELLED dahil)
		// Flutter UI'da zaten isCancelled filtresi yapılıyor

		result = append(result, transfer)
	}

	return result
}

// ToProto TransferInfo'yu proto mesajına dönüştürür
func (t *TransferInfo) ToProto() *pb.TransferInfo {
	proto := &pb.TransferInfo{
		FileId:          t.FileID,
		FileName:        t.FileName,
		PeerId:          t.PeerID,
		PeerName:        t.PeerName,
		Direction:       t.Direction,
		State:           t.State,
		TotalChunks:     t.TotalChunks,
		CompletedChunks: t.CompletedChunks,
		TotalBytes:      t.TotalBytes,
		TransferredBytes: t.TransferredBytes,
		StartTime:       timestamppb.New(t.StartTime),
	}

	// Progress hesapla
	if t.TotalChunks > 0 {
		proto.ProgressPercentage = float32(t.CompletedChunks) / float32(t.TotalChunks) * 100.0
	}

	// Speed hesapla (bytes per second)
	if !t.StartTime.IsZero() {
		elapsed := time.Since(t.StartTime).Seconds()
		if elapsed > 0 && t.TransferredBytes > 0 {
			proto.SpeedBps = int64(float64(t.TransferredBytes) / elapsed)
		}
	}

	if t.EndTime != nil {
		proto.EndTime = timestamppb.New(*t.EndTime)
	}

	if t.Error != nil {
		proto.ErrorMessage = t.Error.Error()
	}

	return proto
}

// CleanupOldTransfers eski tamamlanan transferleri temizler (opsiyonel)
func (m *TransferManager) CleanupOldTransfers(maxAge time.Duration) {
	m.mu.Lock()
	defer m.mu.Unlock()

	now := time.Now()
	for fileID, transfer := range m.transfers {
		// Sadece tamamlanan veya başarısız transferleri temizle
		if transfer.State == pb.TransferState_TRANSFER_STATE_COMPLETED ||
			transfer.State == pb.TransferState_TRANSFER_STATE_FAILED ||
			transfer.State == pb.TransferState_TRANSFER_STATE_CANCELLED {
			
			if transfer.EndTime != nil && now.Sub(*transfer.EndTime) > maxAge {
				delete(m.transfers, fileID)
			}
		}
	}
}

