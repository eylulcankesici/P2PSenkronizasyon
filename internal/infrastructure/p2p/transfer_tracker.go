package p2p

import (
	"sync"
	"time"
)

// TransferTracker transfer durumlarını takip eder
type TransferTracker struct {
	transfers map[string]*TransferInfo
	mu        sync.RWMutex
}

// TransferInfo transfer bilgisi
type TransferInfo struct {
	FileID           string
	FileName         string
	PeerID           string
	PeerName         string
	TotalChunks      int
	CompletedChunks  int
	TotalBytes       int64
	TransferredBytes int64
	IsComplete       bool
	IsFailed         bool
	ErrorMessage     string
	StartTime        time.Time
	EndTime          *time.Time
	ProgressChan     chan *TransferProgressUpdate
}

// TransferProgressUpdate transfer progress güncellemesi
type TransferProgressUpdate struct {
	FileID           string
	CompletedChunks  int
	TotalChunks      int
	TransferredBytes int64
	TotalBytes       int64
	IsComplete       bool
	IsFailed         bool
	ErrorMessage     string
}

// NewTransferTracker yeni transfer tracker oluşturur
func NewTransferTracker() *TransferTracker {
	return &TransferTracker{
		transfers: make(map[string]*TransferInfo),
	}
}

// StartTransfer transfer başlatır
func (tt *TransferTracker) StartTransfer(fileID, fileName, peerID, peerName string, totalChunks int, totalBytes int64) *TransferInfo {
	tt.mu.Lock()
	defer tt.mu.Unlock()
	
	info := &TransferInfo{
		FileID:           fileID,
		FileName:         fileName,
		PeerID:           peerID,
		PeerName:         peerName,
		TotalChunks:      totalChunks,
		CompletedChunks:  0,
		TotalBytes:       totalBytes,
		TransferredBytes: 0,
		IsComplete:       false,
		IsFailed:         false,
		StartTime:        time.Now(),
		ProgressChan:     make(chan *TransferProgressUpdate, 10),
	}
	
	tt.transfers[fileID] = info
	return info
}

// UpdateProgress transfer progress'ini günceller
func (tt *TransferTracker) UpdateProgress(fileID string, completedChunks int, transferredBytes int64) {
	tt.mu.Lock()
	defer tt.mu.Unlock()
	
	info, exists := tt.transfers[fileID]
	if !exists {
		return
	}
	
	info.CompletedChunks = completedChunks
	info.TransferredBytes = transferredBytes
	
	// Progress channel'a gönder
	select {
	case info.ProgressChan <- &TransferProgressUpdate{
		FileID:           fileID,
		CompletedChunks:  completedChunks,
		TotalChunks:      info.TotalChunks,
		TransferredBytes: transferredBytes,
		TotalBytes:       info.TotalBytes,
		IsComplete:       false,
		IsFailed:         false,
	}:
	default:
		// Channel doluysa atla
	}
}

// CompleteTransfer transfer'i tamamlandı olarak işaretle
func (tt *TransferTracker) CompleteTransfer(fileID string) {
	tt.mu.Lock()
	defer tt.mu.Unlock()
	
	info, exists := tt.transfers[fileID]
	if !exists {
		return
	}
	
	now := time.Now()
	info.IsComplete = true
	info.CompletedChunks = info.TotalChunks
	info.TransferredBytes = info.TotalBytes
	info.EndTime = &now
	
	// Progress channel'a gönder
	select {
	case info.ProgressChan <- &TransferProgressUpdate{
		FileID:           fileID,
		CompletedChunks:  info.TotalChunks,
		TotalChunks:      info.TotalChunks,
		TransferredBytes: info.TotalBytes,
		TotalBytes:       info.TotalBytes,
		IsComplete:       true,
		IsFailed:         false,
	}:
	default:
	}
}

// FailTransfer transfer'i başarısız olarak işaretle
func (tt *TransferTracker) FailTransfer(fileID string, errorMessage string) {
	tt.mu.Lock()
	defer tt.mu.Unlock()
	
	info, exists := tt.transfers[fileID]
	if !exists {
		return
	}
	
	now := time.Now()
	info.IsFailed = true
	info.ErrorMessage = errorMessage
	info.EndTime = &now
	
	// Progress channel'a gönder
	select {
	case info.ProgressChan <- &TransferProgressUpdate{
		FileID:           fileID,
		CompletedChunks:  info.CompletedChunks,
		TotalChunks:      info.TotalChunks,
		TransferredBytes: info.TransferredBytes,
		TotalBytes:       info.TotalBytes,
		IsComplete:       false,
		IsFailed:         true,
		ErrorMessage:     errorMessage,
	}:
	default:
	}
}

// GetTransfer transfer bilgisini getirir
func (tt *TransferTracker) GetTransfer(fileID string) (*TransferInfo, bool) {
	tt.mu.RLock()
	defer tt.mu.RUnlock()
	
	info, exists := tt.transfers[fileID]
	return info, exists
}

// GetAllTransfers tüm transferleri getirir
func (tt *TransferTracker) GetAllTransfers() map[string]*TransferInfo {
	tt.mu.RLock()
	defer tt.mu.RUnlock()
	
	result := make(map[string]*TransferInfo)
	for k, v := range tt.transfers {
		result[k] = v
	}
	return result
}

// RemoveTransfer transfer'i kaldırır
func (tt *TransferTracker) RemoveTransfer(fileID string) {
	tt.mu.Lock()
	defer tt.mu.Unlock()
	
	info, exists := tt.transfers[fileID]
	if exists && info.ProgressChan != nil {
		close(info.ProgressChan)
	}
	
	delete(tt.transfers, fileID)
}

