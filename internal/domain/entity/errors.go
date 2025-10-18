package entity

import "errors"

// Domain katmanı hataları
var (
	// Folder hataları
	ErrInvalidPath     = errors.New("geçersiz dosya yolu")
	ErrInvalidSyncMode = errors.New("geçersiz senkronizasyon modu")
	ErrInvalidFolderID = errors.New("geçersiz klasör ID")
	
	// File hataları
	ErrInvalidFileID   = errors.New("geçersiz dosya ID")
	ErrInvalidFileSize = errors.New("geçersiz dosya boyutu")
	
	// Chunk hataları
	ErrInvalidChunkHash = errors.New("geçersiz chunk hash")
	ErrInvalidOffset    = errors.New("geçersiz offset değeri")
	ErrInvalidChunkSize = errors.New("geçersiz chunk boyutu")
	
	// Peer hataları
	ErrInvalidDeviceID = errors.New("geçersiz cihaz ID")
	ErrInvalidPeerName = errors.New("geçersiz peer adı")
	
	// User hataları
	ErrInvalidProfileName  = errors.New("geçersiz profil adı")
	ErrInvalidUserRole     = errors.New("geçersiz kullanıcı rolü")
	ErrInvalidPasswordHash = errors.New("geçersiz şifre hash")
	
	// Version hataları
	ErrInvalidVersionNumber = errors.New("geçersiz versiyon numarası")
	
	// Genel hataları
	ErrNotFound      = errors.New("kayıt bulunamadı")
	ErrAlreadyExists = errors.New("kayıt zaten mevcut")
	ErrUnauthorized  = errors.New("yetkisiz erişim")
)





