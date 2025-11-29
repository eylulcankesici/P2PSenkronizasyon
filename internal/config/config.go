package config

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
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

	// WAN ayarları (yeni)
	EnableWAN             bool               // WAN transport'u aktif et
	TURNServers           []TURNServerConfig // TURN server yapılandırmaları
	EnableTLS             bool               // TLS encryption aktif
	TLSInsecureSkipVerify bool               // Development için (self-signed cert)
	EnableRelay           bool               // Relay server fallback
	WebRTCPortRange       PortRange          // WebRTC port aralığı
	ICEGatheringTimeout   int                // ICE gathering timeout (saniye)
	ConnectionTimeout     int                // Connection timeout (saniye)
}

// TURNServerConfig TURN server yapılandırması
type TURNServerConfig struct {
	URL      string // turn:server:port
	Username string
	Password string
}

// PortRange port aralığı
type PortRange struct {
	Min int // Minimum port
	Max int // Maximum port
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

			// WAN varsayılan ayarları (pasif)
			EnableWAN:             getEnvOrDefaultBool("AETHER_ENABLE_WAN", false), // Ortam değişkeni ile açılabilir
			TURNServers:           getTURNServers(), // Public TURN server'lar (test için)
			EnableTLS:             true, // WAN için TLS varsayılan açık
			TLSInsecureSkipVerify: false,
			EnableRelay:           false,
			WebRTCPortRange: PortRange{
				Min: 50000,
				Max: 60000,
			},
			ICEGatheringTimeout: 10, // 10 saniye
			ConnectionTimeout:   30, // 30 saniye
		},
		Sync: SyncConfig{
			ChunkSize:        4 * 1024 * 1024, // 4 MB
			MaxVersions:      10,
			ScanInterval:     60, // 60 saniye
			MaxConcurrentOps: 4,
		},
		GRPC: GRPCConfig{
			// WAN için public IP'ye açılmalı (0.0.0.0 tüm interface'ler)
			// LOCAL için localhost yeterli, ancak WAN ile uyumluluk için varsayılan 0.0.0.0
			Host: getEnvOrDefault("AETHER_GRPC_HOST", "0.0.0.0"), // Varsayılan: tüm interface'ler
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

// getEnvOrDefaultBool ortam değişkenini veya varsayılan bool değeri döner
func getEnvOrDefaultBool(key string, defaultValue bool) bool {
	if value := os.Getenv(key); value != "" {
		switch strings.ToLower(strings.TrimSpace(value)) {
		case "1", "true", "on", "yes":
			return true
		case "0", "false", "off", "no":
			return false
		}
	}
	return defaultValue
}

// getTURNServers TURN server yapılandırmalarını döner
// Ortam değişkeni ile kontrol edilebilir (AETHER_USE_PUBLIC_TURN)
// Varsayılan: Public TURN server'lar aktif (test için)
func getTURNServers() []TURNServerConfig {
	// Ortam değişkeni ile kontrol et
	usePublicTURN := getEnvOrDefaultBool("AETHER_USE_PUBLIC_TURN", true)
	
	if !usePublicTURN {
		return []TURNServerConfig{}
	}
	
	// Test için ücretsiz public TURN server'lar
	// NOT: Production'da kendi TURN server'ınızı kullanın
	// Kaynak: https://www.metered.ca/tools/openrelay/
	return []TURNServerConfig{
		{
			URL:      "turn:openrelay.metered.ca:80",
			Username: "openrelayproject",
			Password: "openrelayproject",
		},
		{
			URL:      "turn:openrelay.metered.ca:443",
			Username: "openrelayproject",
			Password: "openrelayproject",
		},
		{
			URL:      "turn:openrelay.metered.ca:443?transport=tcp",
			Username: "openrelayproject",
			Password: "openrelayproject",
		},
	}
}
