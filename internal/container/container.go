package container

import (
	"context"
	"fmt"
	"log"
	"path/filepath"
	
	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/domain/usecase"
	"github.com/aether/sync/internal/domain/utils"
	"github.com/aether/sync/internal/infrastructure/database/boltdb"
	"github.com/aether/sync/internal/infrastructure/database/sqlite"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"
	usecaseImpl "github.com/aether/sync/internal/usecase/impl"
	"github.com/aether/sync/pkg/chunking"
)

// Container dependency injection container
// Tüm bağımlılıkları yönetir ve sağlar
type Container struct {
	config *config.Config
	
	// Database connections
	sqliteConn *sqlite.Connection
	boltdbConn *boltdb.Connection
	
	// Repositories
	folderRepo  repository.FolderRepository
	fileRepo    repository.FileRepository
	chunkRepo   repository.ChunkRepository
	peerRepo    repository.PeerRepository
	userRepo    repository.UserRepository
	versionRepo repository.VersionRepository
	configRepo  repository.ConfigRepository
	
	// Use cases
	chunkingUseCase      usecase.ChunkingUseCase
	peerDiscoveryUseCase usecase.PeerDiscoveryUseCase
	p2pTransferUseCase   usecase.P2PTransferUseCase
	
	// P2P Transport
	transportProvider transport.TransportProvider
}

// NewContainer yeni bir container oluşturur
func NewContainer(cfg *config.Config) (*Container, error) {
	container := &Container{
		config: cfg,
	}
	
	// Database bağlantılarını kur
	if err := container.initDatabases(); err != nil {
		return nil, fmt.Errorf("veritabanı başlatılamadı: %w", err)
	}
	
	// Repository'leri oluştur
	container.initRepositories()
	
	// Migration'ları çalıştır
	if err := container.runMigrations(); err != nil {
		return nil, fmt.Errorf("migration'lar çalıştırılamadı: %w", err)
	}
	
	// Use case'leri oluştur
	if err := container.initUseCases(); err != nil {
		return nil, fmt.Errorf("use case'ler başlatılamadı: %w", err)
	}
	
	log.Println("Container başarıyla oluşturuldu")
	
	return container, nil
}

// initDatabases veritabanı bağlantılarını başlatır
func (c *Container) initDatabases() error {
	// SQLite bağlantısı
	sqliteConn, err := sqlite.NewConnection(c.config.Database.SQLitePath)
	if err != nil {
		return fmt.Errorf("sqlite connection oluşturulamadı: %w", err)
	}
	
	if err := sqliteConn.Open(); err != nil {
		return fmt.Errorf("sqlite bağlantısı açılamadı: %w", err)
	}
	
	c.sqliteConn = sqliteConn
	log.Printf("SQLite bağlantısı açıldı: %s", c.config.Database.SQLitePath)
	
	// BoltDB bağlantısı
	boltdbConn := boltdb.NewConnection(c.config.Database.BoltDBPath)
	if err := boltdbConn.Open(); err != nil {
		return fmt.Errorf("boltdb bağlantısı açılamadı: %w", err)
	}
	
	c.boltdbConn = boltdbConn
	log.Printf("BoltDB bağlantısı açıldı: %s", c.config.Database.BoltDBPath)
	
	return nil
}

// initRepositories repository'leri oluşturur
func (c *Container) initRepositories() {
	c.folderRepo = sqlite.NewFolderRepository(c.sqliteConn)
	c.fileRepo = sqlite.NewFileRepository(c.sqliteConn)
	c.chunkRepo = sqlite.NewChunkRepository(c.sqliteConn)
	c.peerRepo = sqlite.NewPeerRepository(c.sqliteConn)
	c.userRepo = sqlite.NewUserRepository(c.sqliteConn)
	c.versionRepo = sqlite.NewVersionRepository(c.sqliteConn)
	
	// Config repository BoltDB üzerinde
	c.configRepo = boltdb.NewConfigRepository(c.boltdbConn)
	
	log.Println("Repository'ler oluşturuldu (SQLite + BoltDB)")
}

// runMigrations veritabanı migration'larını çalıştırır
func (c *Container) runMigrations() error {
	migration := sqlite.NewMigration(c.sqliteConn)
	if err := migration.RunMigrations(); err != nil {
		return err
	}
	
	log.Println("Migration'lar başarıyla çalıştırıldı")
	return nil
}

// Close tüm bağlantıları kapatır
func (c *Container) Close() error {
	var errors []error
	
	// P2P Transport'u durdur
	if c.transportProvider != nil {
		log.Println("P2P Transport durduruluyor...")
		if err := c.transportProvider.Stop(); err != nil {
			errors = append(errors, fmt.Errorf("p2p transport kapatılamadı: %w", err))
		}
	}
	
	if c.sqliteConn != nil {
		if err := c.sqliteConn.Close(); err != nil {
			errors = append(errors, fmt.Errorf("sqlite kapatılamadı: %w", err))
		}
	}
	
	if c.boltdbConn != nil {
		if err := c.boltdbConn.Close(); err != nil {
			errors = append(errors, fmt.Errorf("boltdb kapatılamadı: %w", err))
		}
	}
	
	if len(errors) > 0 {
		return fmt.Errorf("container kapatılırken hatalar oluştu: %v", errors)
	}
	
	log.Println("Container kapatıldı")
	return nil
}

// Getter metodları

func (c *Container) Config() *config.Config {
	return c.config
}

func (c *Container) FolderRepository() repository.FolderRepository {
	return c.folderRepo
}

func (c *Container) FileRepository() repository.FileRepository {
	return c.fileRepo
}

func (c *Container) ChunkRepository() repository.ChunkRepository {
	return c.chunkRepo
}

func (c *Container) PeerRepository() repository.PeerRepository {
	return c.peerRepo
}

func (c *Container) UserRepository() repository.UserRepository {
	return c.userRepo
}

func (c *Container) VersionRepository() repository.VersionRepository {
	return c.versionRepo
}

func (c *Container) ConfigRepository() repository.ConfigRepository {
	return c.configRepo
}

func (c *Container) ChunkingUseCase() usecase.ChunkingUseCase {
	return c.chunkingUseCase
}

func (c *Container) PeerDiscoveryUseCase() usecase.PeerDiscoveryUseCase {
	return c.peerDiscoveryUseCase
}

func (c *Container) P2PTransferUseCase() usecase.P2PTransferUseCase {
	return c.p2pTransferUseCase
}

func (c *Container) TransportProvider() transport.TransportProvider {
	return c.transportProvider
}

// getOrCreateDeviceID kalıcı device ID'yi alır veya oluşturur
func (c *Container) getOrCreateDeviceID() (string, error) {
	ctx := context.Background()
	
	// BoltDB'den device ID'yi kontrol et
	deviceID, err := c.configRepo.GetString(ctx, "device_id")
	if err != nil || deviceID == "" {
		// Yeni device ID oluştur
		generator := utils.NewDeviceIDGenerator()
		deviceID, err = generator.GeneratePersistentDeviceID()
		if err != nil {
			return "", fmt.Errorf("device ID oluşturulamadı: %w", err)
		}
		
		// Device ID'yi doğrula
		if !generator.ValidateDeviceID(deviceID) {
			return "", fmt.Errorf("geçersiz device ID oluşturuldu: %s", deviceID)
		}
		
		// BoltDB'ye kaydet
		if err := c.configRepo.SetString(ctx, "device_id", deviceID); err != nil {
			return "", fmt.Errorf("device ID kaydedilemedi: %w", err)
		}
		
		// Kaydetme işlemini doğrula
		savedID, err := c.configRepo.GetString(ctx, "device_id")
		if err != nil || savedID != deviceID {
			return "", fmt.Errorf("device ID kaydedilemedi veya doğrulanamadı")
		}
		
		log.Printf("✓ Yeni device ID oluşturuldu ve kaydedildi: %s", deviceID)
	} else {
		// Mevcut device ID'yi doğrula
		generator := utils.NewDeviceIDGenerator()
		if !generator.ValidateDeviceID(deviceID) {
			log.Printf("⚠️ Mevcut device ID geçersiz, yeni ID oluşturuluyor...")
			// Geçersiz ID'yi sil ve yeni oluştur
			c.configRepo.Delete(ctx, "device_id")
			return c.getOrCreateDeviceID() // Recursive call
		}
		
		log.Printf("✓ Mevcut device ID kullanılıyor: %s", deviceID)
	}
	
	return deviceID, nil
}

// getDeviceName cihaz adını alır veya oluşturur
func (c *Container) getDeviceName() string {
	ctx := context.Background()
	
	// BoltDB'den device name'i kontrol et
	deviceName := c.configRepo.GetStringOrDefault(ctx, "device_name", "")
	if deviceName == "" {
		// Yeni device name oluştur
		generator := utils.NewDeviceIDGenerator()
		deviceName = generator.GenerateDeviceName()
		
		// BoltDB'ye kaydet
		if err := c.configRepo.SetString(ctx, "device_name", deviceName); err != nil {
			log.Printf("Device name kaydedilemedi: %v", err)
			deviceName = "Aether Node" // Fallback
		}
		
		log.Printf("✓ Yeni device name oluşturuldu: %s", deviceName)
	} else {
		log.Printf("✓ Mevcut device name kullanılıyor: %s", deviceName)
	}
	
	return deviceName
}

// getP2PPort P2P port'unu alır
func (c *Container) getP2PPort() int {
	ctx := context.Background()
	
	// Config'den port al, yoksa default kullan
	portStr := c.configRepo.GetStringOrDefault(ctx, "p2p_port", "50052")
	
	// String'i int'e çevir (basit implementasyon)
	if portStr == "50052" {
		return 50052
	}
	
	return 50052 // Default port
}

// initUseCases use case'leri başlatır
func (c *Container) initUseCases() error {
	// Chunk storage directory
	chunkStorageDir := filepath.Join(c.config.App.DataDir, "chunks")
	
	// Chunker oluştur (256KB)
	chunker := chunking.NewFixedSizeChunker(256 * 1024)
	
	// Chunk storage oluştur
	storage, err := chunking.NewFileSystemChunkStorage(chunkStorageDir)
	if err != nil {
		return fmt.Errorf("chunk storage oluşturulamadı: %w", err)
	}
	
	// Chunk verifier oluştur
	verifier := chunking.NewSHA256Verifier()
	
	// Chunking use case oluştur
	c.chunkingUseCase = usecaseImpl.NewChunkingUseCase(
		c.chunkRepo,
		c.fileRepo,
		chunker,
		storage,
		verifier,
	)
	
	log.Println("✓ Chunking use case başlatıldı")
	
	// P2P Transport başlat
	if err := c.initP2PTransport(); err != nil {
		return fmt.Errorf("P2P transport başlatılamadı: %w", err)
	}
	
	// Peer Discovery use case oluştur
	c.peerDiscoveryUseCase = usecaseImpl.NewPeerDiscoveryUseCase(
		c.transportProvider,
		c.peerRepo,
	)
	
	log.Println("✓ Peer Discovery use case başlatıldı")
	
	// Peer discovery callback'ini bağla (peer'ları veritabanına kaydet)
	if err := c.setupPeerDiscoveryCallback(); err != nil {
		return fmt.Errorf("peer discovery callback ayarlanamadı: %w", err)
	}
	
	// P2P Transfer use case oluştur
	c.p2pTransferUseCase = usecaseImpl.NewP2PTransferUseCase(
		c.transportProvider,
		c.chunkRepo,
		c.fileRepo,
		c.folderRepo,
		c.chunkingUseCase,
	)
	
	log.Println("✓ P2P Transfer use case başlatıldı")
	
	return nil
}

// setupPeerDiscoveryCallback peer discovery callback'ini ayarlar
func (c *Container) setupPeerDiscoveryCallback() error {
	ctx := context.Background()
	
	// LAN Transport'un callback'lerini ayarla
	if lanTransport, ok := c.transportProvider.(interface {
		OnPeerDiscovered(func(*transport.DiscoveredPeer))
		OnPeerLost(func(string))
	}); ok {
		lanTransport.OnPeerDiscovered(func(discoveredPeer *transport.DiscoveredPeer) {
			// Peer'ı veritabanına kaydet
			peer := entity.NewPeer(discoveredPeer.DeviceID, discoveredPeer.DeviceName)
			peer.Status = entity.PeerStatusOffline // İlk keşifte offline
			
			// Addresses'leri kaydet
			if len(discoveredPeer.Addresses) > 0 {
				peer.KnownAddresses = discoveredPeer.Addresses
			}
			
			// Var mı kontrol et
			existingPeer, err := c.peerRepo.GetByID(ctx, discoveredPeer.DeviceID)
			if err != nil || existingPeer == nil {
				// Yeni peer oluştur
				if err := c.peerRepo.Create(ctx, peer); err != nil {
					log.Printf("⚠️ Peer veritabanına kaydedilemedi: %v", err)
				} else {
					log.Printf("✅ Peer veritabanına kaydedildi: %s (%s)", peer.Name, peer.DeviceID[:8])
				}
			} else {
				// Mevcut peer'ı güncelle
				existingPeer.KnownAddresses = discoveredPeer.Addresses
				if err := c.peerRepo.UpdateLastSeen(ctx, discoveredPeer.DeviceID); err != nil {
					log.Printf("⚠️ Peer last seen güncellenemedi: %v", err)
				}
				log.Printf("📝 Peer güncellendi: %s (%s)", peer.Name, peer.DeviceID[:8])
			}
		})
		
		lanTransport.OnPeerLost(func(deviceID string) {
			// Peer'ı offline olarak işaretle
			if err := c.peerRepo.UpdateStatus(ctx, deviceID, entity.PeerStatusOffline); err != nil {
				log.Printf("⚠️ Peer durumu güncellenemedi: %v", err)
			} else {
				log.Printf("⏱️ Peer offline: %s", deviceID[:8])
			}
		})
	}
	
	log.Println("✅ Peer discovery callback'leri bağlandı")
	
	return nil
}

// initP2PTransport P2P transport'u başlatır
func (c *Container) initP2PTransport() error {
	// Kalıcı device ID'yi al veya oluştur
	deviceID, err := c.getOrCreateDeviceID()
	if err != nil {
		return fmt.Errorf("device ID alınamadı: %w", err)
	}
	
	// Device name'i al veya oluştur
	deviceName := c.getDeviceName()
	
	// P2P listen port'unu al
	p2pPort := c.getP2PPort()
	
	// LAN Transport oluştur
	lanTransport := lan.NewLANTransport(deviceID, deviceName, p2pPort)
	
	// Transport'u başlat
	ctx := context.Background()
	if err := lanTransport.Start(ctx); err != nil {
		return fmt.Errorf("LAN transport başlatılamadı: %w", err)
	}
	
	c.transportProvider = lanTransport
	
	log.Printf("✓ P2P Transport başlatıldı (device: %s, port: %d)", deviceName, p2pPort)
	
	return nil
}



