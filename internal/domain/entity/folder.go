package entity

import (
	"time"
)

// SyncMode dosya senkronizasyon modunu tanımlar
type SyncMode string

const (
	SyncModeUnspecified   SyncMode = ""                // Henüz belirlenmemiş
	SyncModeBidirectional SyncMode = "bidirectional"   // Çift yönlü senkronizasyon
	SyncModeSendOnly      SyncMode = "send_only"       // Sadece gönder
	SyncModeReceiveOnly   SyncMode = "receive_only"    // Sadece al
)

// FolderSource folder'ın nereden geldiğini tanımlar
type FolderSource string

const (
	FolderSourceUser     FolderSource = "user"     // Kullanıcının manuel eklediği folder
	FolderSourceReceived FolderSource = "received" // Peer'dan alınan folder
)

// Folder senkronize edilen bir klasörü temsil eder
// Single Responsibility: Sadece klasör verilerini tutar
type Folder struct {
	ID           string
	LocalPath    string
	SyncMode     SyncMode
	Source       FolderSource // Folder'ın kaynağı (user/received)
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
		Source:       FolderSourceUser, // Varsayılan: kullanıcının eklediği
		IsActive:     true,
		LastScanTime: time.Time{},
		CreatedAt:    now,
		UpdatedAt:    now,
	}
}

// NewReceivedFolder peer'dan alınan folder oluşturur
func NewReceivedFolder(localPath string, syncMode SyncMode) *Folder {
	folder := NewFolder(localPath, syncMode)
	folder.Source = FolderSourceReceived
	return folder
}

// Validate klasörün geçerliliğini kontrol eder
func (f *Folder) Validate() error {
	if f.LocalPath == "" {
		return ErrInvalidPath
	}
	
	// SyncMode boş (unspecified) olabilir veya geçerli bir değer olmalı
	if f.SyncMode != SyncModeUnspecified &&
	   f.SyncMode != SyncModeBidirectional && 
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




