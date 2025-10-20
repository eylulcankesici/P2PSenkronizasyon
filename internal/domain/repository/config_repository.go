package repository

import (
	"context"
)

// ConfigRepository konfigürasyon verilerine erişim için interface
// BoltDB/LevelDB üzerinde key-value store olarak çalışır
type ConfigRepository interface {
	// Set bir konfigürasyon değeri ayarlar
	Set(ctx context.Context, key string, value []byte) error
	
	// Get bir konfigürasyon değeri getirir
	Get(ctx context.Context, key string) ([]byte, error)
	
	// Delete bir konfigürasyon değerini siler
	Delete(ctx context.Context, key string) error
	
	// GetAll tüm konfigürasyon değerlerini getirir
	GetAll(ctx context.Context) (map[string][]byte, error)
	
	// Exists bir anahtarın var olup olmadığını kontrol eder
	Exists(ctx context.Context, key string) (bool, error)
	
	// GetWithPrefix belirli prefix ile başlayan tüm değerleri getirir
	GetWithPrefix(ctx context.Context, prefix string) (map[string][]byte, error)
	
	// String helper metodları
	GetString(ctx context.Context, key string) (string, error)
	SetString(ctx context.Context, key, value string) error
	GetStringOrDefault(ctx context.Context, key, defaultValue string) string
}

// Konfigürasyon anahtarları
const (
	ConfigKeyUserProfile         = "user:profile_name"
	ConfigKeyAdminPasswordHash   = "user:admin_password_hash"
	ConfigKeyNATTraversalEnabled = "network:nat_traversal_enabled"
	ConfigKeyBandwidthLimitUp    = "network:bandwidth_limit_up"
	ConfigKeyBandwidthLimitDown  = "network:bandwidth_limit_down"
	ConfigKeyChunkSize           = "sync:chunk_size"
	ConfigKeyMaxVersions         = "sync:max_versions"
	ConfigKeyDeviceID            = "device:id"
	ConfigKeyDeviceName          = "device:name"
	ConfigKeyTheme               = "ui:theme"
	ConfigKeyLanguage            = "ui:language"
)





