package config

import (
	"fmt"
	"os"
	"path/filepath"
)

// Config uygulamanın konfigürasyon yapısı
type Config struct {
	App      AppConfig
	Database DatabaseConfig
	Network  NetworkConfig
	Sync     SyncConfig
	GRPC     GRPCConfig
}

// AppConfig uygulama genel ayarları
type AppConfig struct {
	Name        string
	Version     string
	Environment string // development, production
	DataDir     string // Veri dizini
}

// DatabaseConfig veritabanı ayarları
type DatabaseConfig struct {
	SQLitePath string
	BoltDBPath string
}

// NetworkConfig ağ ayarları
type NetworkConfig struct {
	EnableNATTraversal bool
	BandwidthLimitUp   int64 // bytes/sec
	BandwidthLimitDown int64 // bytes/sec
	ListenPort         int
	EnableMDNS         bool // Yerel ağ keşfi
	STUNServers        []string
	RelayServers       []string
}

// SyncConfig senkronizasyon ayarları
type SyncConfig struct {
	ChunkSize        int64 // bytes
	MaxVersions      int   // Dosya başına maksimum versiyon sayısı
	ScanInterval     int   // Klasör tarama aralığı (saniye)
	MaxConcurrentOps int   // Maksimum eşzamanlı işlem sayısı
}

// GRPCConfig gRPC sunucu ayarları
type GRPCConfig struct {
	Host string
	Port int
}

// Load konfigürasyonu yükler
func Load() (*Config, error) {
	// Varsayılan konfigürasyon
	cfg := &Config{
		App: AppConfig{
			Name:        "Aether",
			Version:     "0.1.0",
			Environment: getEnvOrDefault("AETHER_ENV", "development"),
			DataDir:     getDataDir(),
		},
		Database: DatabaseConfig{
			SQLitePath: "", // İnit'te ayarlanacak
			BoltDBPath: "", // İnit'te ayarlanacak
		},
		Network: NetworkConfig{
			EnableNATTraversal: true,
			BandwidthLimitUp:   0, // Sınırsız
			BandwidthLimitDown: 0, // Sınırsız
			ListenPort:         7878,
			EnableMDNS:         true,
			STUNServers: []string{
				"stun:stun.l.google.com:19302",
				"stun:stun1.l.google.com:19302",
			},
			RelayServers: []string{},
		},
		Sync: SyncConfig{
			ChunkSize:        4 * 1024 * 1024, // 4 MB
			MaxVersions:      10,
			ScanInterval:     60, // 60 saniye
			MaxConcurrentOps: 4,
		},
		GRPC: GRPCConfig{
			Host: getEnvOrDefault("AETHER_GRPC_HOST", "localhost"),
			Port: getEnvOrDefaultInt("AETHER_GRPC_PORT", 50051),
		},
	}
	
	// Veritabanı yollarını ayarla
	cfg.Database.SQLitePath = filepath.Join(cfg.App.DataDir, "aether.db")
	cfg.Database.BoltDBPath = filepath.Join(cfg.App.DataDir, "aether_config.db")
	
	// Data dizinini oluştur
	if err := ensureDataDir(cfg.App.DataDir); err != nil {
		return nil, fmt.Errorf("data dizini oluşturulamadı: %w", err)
	}
	
	return cfg, nil
}

// Validate konfigürasyonu doğrular
func (c *Config) Validate() error {
	if c.App.Name == "" {
		return fmt.Errorf("uygulama adı boş olamaz")
	}
	
	if c.Database.SQLitePath == "" {
		return fmt.Errorf("SQLite veritabanı yolu boş olamaz")
	}
	
	if c.Database.BoltDBPath == "" {
		return fmt.Errorf("BoltDB veritabanı yolu boş olamaz")
	}
	
	if c.GRPC.Port < 1024 || c.GRPC.Port > 65535 {
		return fmt.Errorf("geçersiz gRPC port: %d", c.GRPC.Port)
	}
	
	if c.Sync.ChunkSize <= 0 {
		return fmt.Errorf("chunk boyutu 0'dan büyük olmalı")
	}
	
	return nil
}

// getDataDir veri dizinini belirler
func getDataDir() string {
	// Önce AETHER_DATA_DIR ortam değişkenini kontrol et
	if dir := os.Getenv("AETHER_DATA_DIR"); dir != "" {
		return dir
	}
	
	// Kullanıcı home dizinini al
	homeDir, err := os.UserHomeDir()
	if err != nil {
		// Fallback: mevcut dizin
		return ".aether"
	}
	
	// Platform'a göre data dizini
	return filepath.Join(homeDir, ".aether")
}

// ensureDataDir veri dizininin var olduğundan emin olur
func ensureDataDir(dir string) error {
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		if err := os.MkdirAll(dir, 0755); err != nil {
			return err
		}
	}
	return nil
}

// getEnvOrDefault ortam değişkenini veya varsayılan değeri döner
func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

// getEnvOrDefaultInt ortam değişkenini veya varsayılan int değeri döner
func getEnvOrDefaultInt(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		var intValue int
		if _, err := fmt.Sscanf(value, "%d", &intValue); err == nil {
			return intValue
		}
	}
	return defaultValue
}





