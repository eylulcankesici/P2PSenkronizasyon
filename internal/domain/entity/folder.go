package entity

import (
	"time"
)

// SyncMode dosya senkronizasyon modunu tanımlar
type SyncMode string

const (
	SyncModeBidirectional SyncMode = "bidirectional" // Çift yönlü senkronizasyon
	SyncModeSendOnly      SyncMode = "send_only"     // Sadece gönder
	SyncModeReceiveOnly   SyncMode = "receive_only"  // Sadece al
)

// Folder senkronize edilen bir klasörü temsil eder
// Single Responsibility: Sadece klasör verilerini tutar
type Folder struct {
	ID           string
	LocalPath    string
	SyncMode     SyncMode
	LastScanTime time.Time
	IsActive     bool
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// NewFolder yeni bir Folder oluşturur (Factory pattern)
func NewFolder(localPath string, syncMode SyncMode) *Folder {
	now := time.Now()
	return &Folder{
		LocalPath:    localPath,
		SyncMode:     syncMode,
		IsActive:     true,
		LastScanTime: time.Time{},
		CreatedAt:    now,
		UpdatedAt:    now,
	}
}

// Validate klasörün geçerliliğini kontrol eder
func (f *Folder) Validate() error {
	if f.LocalPath == "" {
		return ErrInvalidPath
	}
	
	if f.SyncMode != SyncModeBidirectional && 
	   f.SyncMode != SyncModeSendOnly && 
	   f.SyncMode != SyncModeReceiveOnly {
		return ErrInvalidSyncMode
	}
	
	return nil
}

// UpdateScanTime son tarama zamanını günceller
func (f *Folder) UpdateScanTime() {
	f.LastScanTime = time.Now()
	f.UpdatedAt = time.Now()
}

// Activate klasörü aktif hale getirir
func (f *Folder) Activate() {
	f.IsActive = true
	f.UpdatedAt = time.Now()
}

// Deactivate klasörü pasif hale getirir
func (f *Folder) Deactivate() {
	f.IsActive = false
	f.UpdatedAt = time.Now()
}




