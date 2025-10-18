package usecase

import (
	"context"
)

// SyncUseCase dosya senkronizasyonu için use case interface
// Single Responsibility: Sadece senkronizasyon mantığından sorumlu
type SyncUseCase interface {
	// ScanFolder klasörü tarar ve değişiklikleri tespit eder
	ScanFolder(ctx context.Context, folderID string) error
	
	// SyncFile bir dosyayı senkronize eder
	SyncFile(ctx context.Context, fileID string, targetPeerIDs []string) error
	
	// RequestFile bir dosyayı peer'lardan talep eder
	RequestFile(ctx context.Context, fileID string, sourcePeerID string) error
	
	// GetSyncStatus senkronizasyon durumunu getirir
	GetSyncStatus(ctx context.Context, folderID string) (*SyncStatus, error)
	
	// PauseSyn senkronizasyonu duraklatır
	PauseSync(ctx context.Context, folderID string) error
	
	// ResumeSync senkronizasyonu devam ettirir
	ResumeSync(ctx context.Context, folderID string) error
}

// SyncStatus senkronizasyon durumunu temsil eder
type SyncStatus struct {
	FolderID         string
	TotalFiles       int
	SyncedFiles      int
	PendingFiles     int
	TotalSize        int64
	SyncedSize       int64
	LastSyncTime     int64
	IsSyncing        bool
	CurrentOperation string
}





