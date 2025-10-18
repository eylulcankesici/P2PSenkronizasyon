package container

import (
	"fmt"
	"log"
	"path/filepath"
	
	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/domain/usecase"
	"github.com/aether/sync/internal/infrastructure/database/boltdb"
	"github.com/aether/sync/internal/infrastructure/database/sqlite"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"
	usecaseImpl "github.com/aether/sync/internal/usecase/impl"
	"github.com/aether/sync/pkg/chunking"
	"github.com/google/uuid"
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

// initP2PTransport P2P transport'u başlatır
func (c *Container) initP2PTransport() error {
	// Device ID oluştur (veya config'den al)
	deviceID := uuid.New().String()
	deviceName := "Aether Node" // Config'den alınabilir
	
	// P2P listen port
	p2pPort := 50052 // Config'den alınabilir
	
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



