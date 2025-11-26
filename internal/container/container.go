package container

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
	
	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/domain/entity"
	"github.com/aether/sync/internal/domain/repository"
	"github.com/aether/sync/internal/domain/transport"
	"github.com/aether/sync/internal/domain/usecase"
	"github.com/aether/sync/internal/domain/utils"
	"github.com/aether/sync/internal/infrastructure/database/boltdb"
	"github.com/aether/sync/internal/infrastructure/database/sqlite"
	"github.com/aether/sync/internal/infrastructure/filesystem"
	"github.com/aether/sync/internal/infrastructure/p2p"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"
	"github.com/aether/sync/internal/infrastructure/watcher"
	usecaseImpl "github.com/aether/sync/internal/usecase/impl"
	"github.com/aether/sync/pkg/chunking"
	"github.com/aether/sync/pkg/reassembly"
)

// Container dependency injection container
// Tüm bağımlılıkları yönetir ve sağlar
type Container struct {
	config *config.Config
	
	// Database connections
	sqliteConn *sqlite.Connection
	boltdbConn *boltdb.Connection
	
	// Repositories
	folderRepo         repository.FolderRepository
	fileRepo           repository.FileRepository
	chunkRepo          repository.ChunkRepository
	peerRepo           repository.PeerRepository
	userRepo           repository.UserRepository
	versionRepo        repository.VersionRepository
	filePeerSyncRepo   repository.FilePeerSyncRepository
	configRepo         repository.ConfigRepository
	
	// Use cases
	chunkingUseCase      usecase.ChunkingUseCase
	peerDiscoveryUseCase usecase.PeerDiscoveryUseCase
	p2pTransferUseCase   usecase.P2PTransferUseCase
	
	// P2P Transport
	transportProvider transport.TransportProvider
	
	// File reassembler (push-based sync için)
	fileReassembler *reassembly.FileReassembler
	
	// Retry tracking (chunk hash doğrulama için)
	chunkRetryCount map[string]int
	retryMu         sync.RWMutex
	
	// Transfer manager (transfer durumu takibi için)
	transferManager *p2p.TransferManager
	
	// Rejected chunks tracking (TCP buffer temizleme için)
	// İptal edilen transfer'lardan kalan chunk'ları sayar
	rejectedChunks sync.Map // fileID -> counter (int)
	
	// File watcher (real-time file monitoring)
	fileWatcher      *watcher.FileWatcher
	eventHandler     *watcher.EventHandler
	eventBroadcaster *watcher.EventBroadcaster
	
	// Symlink manager (Desktop shortcut oluşturma)
	symlinkManager *filesystem.SymlinkManager
}

// NewContainer yeni bir container oluşturur
func NewContainer(cfg *config.Config) (*Container, error) {
	container := &Container{
		config:          cfg,
		chunkRetryCount: make(map[string]int),
		transferManager: p2p.NewTransferManager(),
		symlinkManager:  filesystem.NewSymlinkManager(),
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
	
	// File watcher'ı başlat
	if err := container.initFileWatcher(); err != nil {
		return nil, fmt.Errorf("file watcher başlatılamadı: %w", err)
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
	c.filePeerSyncRepo = sqlite.NewFilePeerSyncRepository(c.sqliteConn)
	
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
	log.Println("🛑 Container kapatılıyor...")
	var errors []error
	
	// Event broadcaster'ı kapat
	if c.eventBroadcaster != nil {
		log.Println("Event broadcaster kapatılıyor...")
		c.eventBroadcaster.Close()
	}
	
	// File watcher'ı durdur
	if c.fileWatcher != nil {
		log.Println("File watcher durduruluyor...")
		if err := c.fileWatcher.Stop(); err != nil {
			errors = append(errors, fmt.Errorf("file watcher durdurulamadı: %w", err))
		}
	}
	
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
	
	log.Println("✅ Container kapatıldı")
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

func (c *Container) FilePeerSyncRepository() repository.FilePeerSyncRepository {
	return c.filePeerSyncRepo
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

// TransferManager transfer manager'ı döner
func (c *Container) TransferManager() *p2p.TransferManager {
	return c.transferManager
}

// FileReassembler file reassembler'ı döner
func (c *Container) FileReassembler() *reassembly.FileReassembler {
	return c.fileReassembler
}

// GetDeviceID kalıcı device ID'yi alır veya oluşturur (public)
func (c *Container) GetDeviceID() (string, error) {
	return c.getOrCreateDeviceID()
}

// getOrCreateDeviceID kalıcı device ID'yi alır veya oluşturur (private helper)
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

// GetDeviceName cihaz adını alır veya oluşturur (public)
func (c *Container) GetDeviceName() string {
	return c.getDeviceName()
}

// getDeviceName cihaz adını alır veya oluşturur (private helper)
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
	
	// File reassembler oluştur (push-based sync için)
	c.fileReassembler = reassembly.NewFileReassembler()
	
	// P2P Transfer use case oluştur
	c.p2pTransferUseCase = usecaseImpl.NewP2PTransferUseCase(
		c.transportProvider,
		c.chunkRepo,
		c.fileRepo,
		c.folderRepo,
		c.chunkingUseCase,
	)
	
	log.Println("✓ P2P Transfer use case başlatıldı")
	
	// Chunk handler'ı bağla
	if lanTransport, ok := c.transportProvider.(*lan.LANTransport); ok {
		chunkHandler := func(chunkHash string) ([]byte, error) {
			chunkData, err := c.chunkingUseCase.GetChunkData(context.Background(), chunkHash)
			if err != nil {
				return nil, fmt.Errorf("chunk alınamadı: %w", err)
			}
			return chunkData, nil
		}
		
		lanTransport.SetChunkHandler(chunkHandler)
		log.Println("✓ Chunk handler bağlandı")
		
		// Connection request callback'ini bağla
		connMgr := lanTransport.GetTCPConnectionManager()
		connMgr.SetOnConnectionRequested(func(deviceID, deviceName string) {
			log.Printf("🔔 Connection request callback tetiklendi: %s (%s)", deviceName, deviceID[:8])
			// UI'a bildirim gönderilebilir (gRPC üzerinden veya event system ile)
			// Şimdilik sadece log - UI tarafında polling ile alınabilir
		})
		
		// Chunk received callback'ini bağla (push-based sync için - folder name ile)
		connMgr.SetOnChunkReceived(func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error {
			return c.handleIncomingChunk(context.Background(), peerID, fileID, chunkHash, chunkData, chunkIndex, totalChunks, fileName, folderName, senderSyncMode, receiverSyncMode)
		})
		
		log.Println("✓ Chunk received callback bağlandı")
		
		// Transfer cancel callback'ini bağla (karşı taraf iptal ettiğinde buraya gelir)
		connMgr.SetOnTransferCancel(func(peerID, fileID string) {
			log.Printf("🛑 Transfer iptal bildirimi alındı (peer: %s, file: %s), transfer iptal ediliyor...", peerID[:8], fileID[:8])
			
			// Transfer durumunu kontrol et (iptal edilmeden önce)
			transfer, exists := c.transferManager.GetTransfer(fileID)
			if !exists {
				log.Printf("  ⚠️ Transfer bulunamadı (zaten temizlenmiş olabilir): %s", fileID[:8])
				return
			}
			
			// Transfer yönünü kaydet (iptal edilmeden önce)
			direction := transfer.Direction
			
			// Transfer'i iptal et
			c.transferManager.CancelTransfer(fileID)
			
			// Her iki direction için de fileReassembler'ı temizle (yeni transfer için hazırlık)
			log.Printf("  🗑️ Transfer iptal edildi, fileReassembler temizleniyor (direction: %v): %s", direction, fileID[:8])
			c.fileReassembler.CleanupFile(fileID)
			
			log.Printf("  ✅ Transfer iptal edildi ve fileReassembler temizlendi, yeni transfer için hazır: %s (direction: %v)", fileID[:8], direction)
		})
		
		log.Println("✓ Transfer cancel callback bağlandı")
		
		// Dosya silme callback'ini bağla (peer'dan silme bildirimi geldiğinde buraya gelir)
		connMgr.SetOnFileDelete(func(peerID, fileID string) {
			log.Printf("🗑️ Dosya silme bildirimi alındı (peer: %s, file: %s), dosya siliniyor...", peerID[:8], fileID[:8])
			
			ctx := context.Background()
			
			// Dosyayı veritabanından al
			file, err := c.fileRepo.GetByID(ctx, fileID)
			if err != nil {
				log.Printf("  ⚠️ Dosya bulunamadı: %s - %v", fileID[:8], err)
				return
			}
			
			// Folder bilgisini al
			folder, err := c.folderRepo.GetByID(ctx, file.FolderID)
			if err != nil {
				log.Printf("  ⚠️ Folder bulunamadı: %s - %v", file.FolderID[:8], err)
				return
			}
			
			// Veritabanından tamamen sil (HARD DELETE) - CASCADE olduğu için file_chunks ve file_peer_sync de silinir
			if err := c.fileRepo.HardDelete(ctx, fileID); err != nil {
				log.Printf("  ❌ Dosya veritabanından silinemedi: %s - %v", fileID[:8], err)
				return
			}
			log.Printf("  ✅ Dosya veritabanından tamamen silindi (hard delete): %s", fileID[:8])
			
			// FİZİKSEL dosyayı SİL (sadece received folder'lar için)
			if folder.Source == entity.FolderSourceReceived {
				filePath := filepath.Join(folder.LocalPath, file.RelativePath)
				if err := os.Remove(filePath); err != nil {
					log.Printf("  ⚠️ Fiziksel dosya silinemedi (%s): %v", filePath, err)
				} else {
					log.Printf("  ✅ Fiziksel dosya silindi: %s", filePath)
				}
			} else {
				log.Printf("  ℹ️  User folder, fiziksel dosya korunuyor")
			}
		})
		
		log.Println("✓ Dosya silme callback bağlandı")
	}
	
	return nil
}

// setupPeerDiscoveryCallback peer discovery callback'ini ayarlar
func (c *Container) setupPeerDiscoveryCallback() error {
	ctx := context.Background()
	
	// LAN Transport'un callback'lerini ayarla
	if lanTransport, ok := c.transportProvider.(interface {
		OnPeerDiscovered(func(*transport.DiscoveredPeer))
		OnPeerLost(func(string))
		OnConnectionLost(func(string))
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
		
		// Connection lost callback'ini ayarla
		lanTransport.OnConnectionLost(func(peerID string) {
			// Peer'ı offline olarak işaretle
			if err := c.peerRepo.UpdateStatus(ctx, peerID, entity.PeerStatusOffline); err != nil {
				log.Printf("⚠️ Peer durumu güncellenemedi: %v", err)
			} else {
				log.Printf("🔌 Connection lost, peer offline: %s", peerID[:8])
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
	
	// Chunk handler'ı daha sonra bağlanacak (chunking use case hazır olduktan sonra)
	
	c.transportProvider = lanTransport
	
	log.Printf("✓ P2P Transport başlatıldı (device: %s, port: %d)", deviceName, p2pPort)
	
	return nil
}

	// handleIncomingChunk gelen chunk'ı işler (push-based sync)
func (c *Container) handleIncomingChunk(ctx context.Context, peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error {
	// Log azaltıldı - sadece her 50 chunk'ta bir log
	if chunkIndex%50 == 0 || chunkIndex == 0 || chunkIndex == totalChunks-1 {
		log.Printf("📥 Incoming chunk: file=%s, folder=%s, chunk=%d/%d, hash=%s, receiver_sync_mode=%v", fileID[:8], folderName, chunkIndex+1, totalChunks, chunkHash[:8], receiverSyncMode)
	}
	
	// İlk chunk ise dosyayı initialize et ve transfer durumunu başlat
	if chunkIndex == 0 {
		log.Printf("  🆕🆕🆕 İLK CHUNK GELDİ - YENİ TRANSFER BAŞLATILIYOR: fileID=%s, fileName=%s, totalChunks=%d", fileID[:8], fileName, totalChunks)
		
		// Önceki transfer varsa explicit olarak temizle (CANCELLED, FAILED, ACTIVE hepsi)
		existingTransfer, exists := c.transferManager.GetTransfer(fileID)
		if exists {
			log.Printf("  🔄 ÖNCEKİ TRANSFER BULUNDU (state: %v, direction: %v) - AGRESIF TEMİZLEME YAPILIYOR: %s", existingTransfer.State, existingTransfer.Direction, fileID[:8])
			
			// Transfer'i explicit olarak iptal et ve map'ten kaldır
			c.transferManager.CancelTransfer(fileID)
			log.Printf("  ✅ Önceki transfer iptal edildi ve map'ten kaldırıldı: %s", fileID[:8])
			
			// Önceki transfer'in goroutine'inin tamamen durması için bekle
			log.Printf("  ⏳ Önceki transfer'in durması bekleniyor (200ms)...")
			time.Sleep(200 * time.Millisecond)
			log.Printf("  ✅ Bekleme tamamlandı: %s", fileID[:8])
			
			// Güvenlik kontrolü: Transfer hâlâ map'te varsa zorla kaldır
			c.transferManager.ForceRemoveTransfer(fileID)
		} else {
			log.Printf("  ✓ Önceki transfer bulunamadı (yeni transfer): %s", fileID[:8])
		}
		
		// Rejected chunks counter'ı temizle (yeni transfer başlıyor)
		if val, ok := c.rejectedChunks.Load(fileID); ok {
			count := val.(int)
			if count > 0 {
				log.Printf("  🗑️  %d eski chunk reddedildi, counter temizleniyor: %s", count, fileID[:8])
			}
			c.rejectedChunks.Delete(fileID)
		}
		
		// FileReassembler'ı temizle (yeni transfer için - her durumda)
		c.fileReassembler.CleanupFile(fileID)
		log.Printf("  ✅ FileReassembler temizlendi: %s", fileID[:8])
		
		// Dosyayı initialize et
		if err := c.fileReassembler.InitializeFile(fileID, totalChunks, ""); err != nil {
			log.Printf("  ⚠️ Dosya initialize hatası: %v, temizleme yapılıyor...", err)
			// Hata durumunda eski dosyayı temizle ve tekrar dene
			c.fileReassembler.CleanupFile(fileID)
			time.Sleep(50 * time.Millisecond)
			if err := c.fileReassembler.InitializeFile(fileID, totalChunks, ""); err != nil {
				log.Printf("  ❌ Dosya initialize edilemedi (2. deneme): %v", err)
				return fmt.Errorf("dosya initialize edilemedi: %w", err)
			}
		}
		log.Printf("  ✅ Dosya initialize edildi: %s (%d chunks)", fileID[:8], totalChunks)
		
		// Peer bilgisini al (peer name için)
		peer, err := c.peerRepo.GetByID(ctx, peerID)
		peerName := peerID[:8] // Fallback: peer ID'nin ilk 8 karakteri
		if err == nil && peer != nil {
			peerName = peer.Name
		}
		
		// Dosya bilgisini al (total bytes için)
		file, err := c.fileRepo.GetByID(ctx, fileID)
		totalBytes := int64(0)
		if err == nil && file != nil {
			totalBytes = file.Size
		} else {
			// Dosya henüz yoksa, chunk boyutlarından tahmin et
			// Varsayılan chunk boyutu * total chunks
			totalBytes = int64(len(chunkData) * totalChunks)
		}
		
		// Transfer durumunu başlat (RECEIVE - dosya alınıyor)
		// StartTransfer içinde eski CANCELLED/FAILED/ACTIVE transfer'ler temizlenir
		// Ancak yukarıda zaten explicit olarak temizledik, bu yüzden StartTransfer sadece yeni transfer oluşturur
		c.transferManager.StartTransfer(
			fileID,
			fileName,
			peerID,
			peerName,
			pb.TransferDirection_TRANSFER_DIRECTION_RECEIVE,
			int32(totalChunks),
			totalBytes,
		)
		log.Printf("  📊 YENİ TRANSFER BAŞLATILDI: %s (alınıyor, %d chunks, %d bytes) - ACTIVE state ile başlatıldı", fileName, totalChunks, totalBytes)
		
		// Yeni transfer'in context'inin hazır olduğundan emin ol
		time.Sleep(10 * time.Millisecond)
		
		// İlk chunk için, transfer yeni başlatıldığı için CANCELLED kontrolü atlanmalı
		// Doğrudan chunk işleme devam et
	} else {
		// İlk chunk değilse, transfer durumunu kontrol et
		transfer, transferExists := c.transferManager.GetTransfer(fileID)
		if transferExists {
			if transfer.State == pb.TransferState_TRANSFER_STATE_CANCELLED {
				log.Printf("  🛑 Transfer iptal edilmiş, chunk reddediliyor: %s (chunk %d/%d)", fileID[:8], chunkIndex+1, totalChunks)
				return fmt.Errorf("transfer iptal edilmiş: %s", fileID[:8])
			}
			
			// Transfer context'i varsa iptal kontrolü yap (alıcı taraf için)
			if transferCtx, hasContext := c.transferManager.GetTransferContext(fileID); hasContext {
				select {
				case <-transferCtx.Done():
					log.Printf("  🛑 Transfer context iptal edildi, chunk reddediliyor: %s (chunk %d/%d)", fileID[:8], chunkIndex+1, totalChunks)
					return fmt.Errorf("transfer iptal edildi: %w", transferCtx.Err())
				default:
					// Devam et
				}
			}
		} else {
			// Transfer bulunamadı - Bu, önceki transfer iptal edildikten sonra yeni transfer başlatılmamış demektir
			// İlk chunk gelmemiş olabilir veya gönderen taraf chunk'ları sırasız gönderiyor olabilir
			// Bu durumda, eğer chunkIndex != 0 ise, ilk chunk'ı beklemeliyiz
			// Ama eğer chunkIndex == 0 ise, yeni transfer başlatmalıyız
			
			if chunkIndex == 0 {
				// İlk chunk geldi ama transfer başlatılmamış - yeni transfer başlat
				log.Printf("  🔄 Transfer bulunamadı ama ilk chunk geldi (chunk %d/%d), yeni transfer başlatılıyor: %s", chunkIndex+1, totalChunks, fileID[:8])
				
				// Rejected chunks counter'ı temizle (yeni transfer başlıyor)
				c.rejectedChunks.Delete(fileID)
				
				// FileReassembler'ı temizle
				c.fileReassembler.CleanupFile(fileID)
				
				// Dosyayı initialize et
				if err := c.fileReassembler.InitializeFile(fileID, totalChunks, ""); err != nil {
					log.Printf("  ⚠️ Dosya initialize hatası: %v, temizleme yapılıyor...", err)
					c.fileReassembler.CleanupFile(fileID)
					time.Sleep(50 * time.Millisecond)
					if err := c.fileReassembler.InitializeFile(fileID, totalChunks, ""); err != nil {
						log.Printf("  ❌ Dosya initialize edilemedi (2. deneme): %v", err)
						return fmt.Errorf("dosya initialize edilemedi: %w", err)
					}
				}
				
				// Peer bilgisini al
				peer, err := c.peerRepo.GetByID(ctx, peerID)
				peerName := peerID[:8]
				if err == nil && peer != nil {
					peerName = peer.Name
				}
				
				// Dosya bilgisini al (total bytes için)
				file, err := c.fileRepo.GetByID(ctx, fileID)
				totalBytes := int64(0)
				if err == nil && file != nil {
					totalBytes = file.Size
				} else {
					totalBytes = int64(len(chunkData) * totalChunks)
				}
				
				// Transfer durumunu başlat
				c.transferManager.StartTransfer(
					fileID,
					fileName,
					peerID,
					peerName,
					pb.TransferDirection_TRANSFER_DIRECTION_RECEIVE,
					int32(totalChunks),
					totalBytes,
				)
				log.Printf("  ✅ Yeni transfer başlatıldı (ilk chunk sonrası): %s", fileID[:8])
				// Chunk işleme devam edecek
			} else {
				// İlk chunk değil ve transfer yok - bu eski transfer'in TCP buffer'ındaki artık chunk olabilir
				// Chunk'ı sessizce at ve buffer'ın temizlenmesini bekle (chunk 0 gelene kadar)
				
				// Reddedilen chunk'ları say
				var count int
				if val, ok := c.rejectedChunks.Load(fileID); ok {
					count = val.(int)
					count++
					c.rejectedChunks.Store(fileID, count)
					
					// Sadece her 50 chunk'ta bir log (spam önleme)
					if count%50 == 0 {
						log.Printf("  ⚠️  %d eski chunk reddedildi (TCP buffer temizleniyor, chunk 0 bekleniyor): %s", count, fileID[:8])
					}
				} else {
					count = 1
					c.rejectedChunks.Store(fileID, count)
					log.Printf("  ⚠️  Transfer bulunamadı, eski chunk'lar reddediliyor (chunk 0 bekleniyor): %s (chunk %d/%d)", fileID[:8], chunkIndex+1, totalChunks)
				}
				
				// Chunk'ı sessizce at - goroutine return eder, messageLoop devam eder, TCP buffer temizlenir
				// Bu sayede chunk 0 geldiğinde sistem hazır olur
				return nil // Hata değil, sadece chunk atıldı
			}
		}
	}
	
	// Retry sayacını kontrol et (max 3 retry)
	const maxRetries = 3
	retryKey := fmt.Sprintf("%s:%s:%d", fileID, chunkHash, chunkIndex)
	retryCount := c.getChunkRetryCount(retryKey)
	
	// Chunk'ı reassembler'a ekle (hash doğrulama burada yapılıyor)
	if err := c.fileReassembler.AddChunk(fileID, chunkIndex, chunkHash, chunkData); err != nil {
		// Hash hatası durumunda retry mekanizması
		if retryCount < maxRetries {
			log.Printf("  ❌ Chunk hash hatası (retry %d/%d): %v", retryCount+1, maxRetries, err)
			c.incrementChunkRetryCount(retryKey)
			
			// Chunk'ı tekrar talep et (folder name ile)
			if err := c.retryChunkRequest(ctx, peerID, chunkHash, fileID, chunkIndex, totalChunks, fileName, folderName); err != nil {
				log.Printf("  ⚠️ Chunk retry hatası: %v", err)
				return fmt.Errorf("chunk retry başarısız: %w", err)
			}
			
			log.Printf("  🔄 Chunk retry talep edildi: %s (retry %d/%d)", chunkHash[:8], retryCount+1, maxRetries)
			return nil // Retry talep edildi, şimdilik hata döndürme
		} else {
			log.Printf("  ❌ Chunk hash hatası: max retry sayısına ulaşıldı (%d), hata: %v", maxRetries, err)
			// Transfer durumunu başarısız olarak işaretle
			c.transferManager.FailTransfer(fileID, fmt.Errorf("chunk hash doğrulama başarısız (max retry): %w", err))
			return fmt.Errorf("chunk hash doğrulama başarısız (max retry): %w", err)
		}
	}
	
	// Transfer context'i varsa iptal kontrolü yap (progress güncellemeden önce)
	if transferCtx, hasContext := c.transferManager.GetTransferContext(fileID); hasContext {
		select {
		case <-transferCtx.Done():
			log.Printf("  🛑 Transfer iptal edildi, progress güncellemesi atlanıyor: %s (chunk %d/%d)", fileID[:8], chunkIndex+1, totalChunks)
			return fmt.Errorf("transfer iptal edildi: %w", transferCtx.Err())
		default:
		}
	}
	
	// Başarılı - retry sayacını sıfırla
	c.clearChunkRetryCount(retryKey)
	
	// Transfer progress güncelle (alma)
	completedChunks := int32(c.fileReassembler.GetProgress(fileID) * float64(totalChunks) / 100.0)
	if completedChunks == 0 && chunkIndex == 0 {
		completedChunks = 1 // İlk chunk eklendi
	} else {
		completedChunks = int32(chunkIndex + 1)
	}
	transferredBytes := int64(len(chunkData)) * int64(completedChunks) // Tahmin: chunk boyutu * tamamlanan chunk sayısı
	c.transferManager.UpdateChunkProgress(fileID, completedChunks, transferredBytes)
	
	// Tüm chunk'lar geldi mi kontrol et
	if c.fileReassembler.IsFileComplete(fileID) {
		log.Printf("  ✅ Dosya tamamlandı: %s", fileID[:8])
		
		// Dosya bilgisini al
		file, err := c.fileRepo.GetByID(ctx, fileID)
		var outputPath string
		var folder *entity.Folder
		
		if err == nil && file != nil {
			// Folder bilgisini al
			folder, err = c.folderRepo.GetByID(ctx, file.FolderID)
			if err == nil && folder != nil {
				// Orjinal path'i kullan
				outputPath = filepath.Join(folder.LocalPath, file.RelativePath)
				log.Printf("  📁 Dosya bilgisi bulundu: %s", outputPath)
			}
		}
		
		// Eğer dosya/folder bilgisi yoksa yeni klasör oluştur
		if outputPath == "" {
			log.Printf("  📁 Dosya/folder bilgisi yok, yeni klasör oluşturuluyor")
			
		// Varsayılan sync klasörü: DataDir/synced_folders/{folder_name}
		syncBaseDir := filepath.Join(c.config.App.DataDir, "synced_folders")
		
		var folderID, receivedFolderName, finalFileName, syncDir string
		
		// Folder adını belirle (öncelik: gelen folderName parametresi)
		if folderName != "" {
			// Sender'dan gelen folder adını kullan (ÖNCELİKLİ)
			receivedFolderName = folderName
			
			// ÖNEMLİ: Gönderici tarafında, mevcut folder'larla eşleştir
			// Eğer aynı isimde bir folder varsa, onu kullan (aynı folder'a dosya eklensin)
			var matchedFolder *entity.Folder
			allFolders, err := c.folderRepo.GetAll(ctx)
			if err == nil {
				for _, f := range allFolders {
					// Folder adını karşılaştır (base name)
					if filepath.Base(f.LocalPath) == folderName {
						matchedFolder = f
						log.Printf("  ✅ Aynı isimde folder bulundu: %s (ID: %s, Path: %s)", folderName, f.ID[:8], f.LocalPath)
						break
					}
				}
			}
			
			if matchedFolder != nil {
				// Mevcut folder'ı kullan (aynı folder'a ekle)
				folderID = matchedFolder.ID
				syncDir = matchedFolder.LocalPath
				folder = matchedFolder
				log.Printf("  📁 Mevcut folder kullanılıyor: %s (ID: %s)", syncDir, folderID[:8])
			} else {
				// Yeni folder oluştur (alıcı taraf için)
				// Folder adından tutarlı bir ID üret (aynı folder adı → aynı ID)
				hash := sha256.Sum256([]byte(folderName))
				folderID = hex.EncodeToString(hash[:])[:32] // İlk 32 karakter
				syncDir = filepath.Join(syncBaseDir, receivedFolderName)
				log.Printf("  ✅ Sender'dan gelen folder adı kullanılıyor (yeni folder): %s (ID: %s)", receivedFolderName, folderID[:8])
			}
		} else if file != nil && file.FolderID != "" {
			// Veritabanındaki folder bilgisini kullan (fallback)
			folderID = file.FolderID
			if folderTemp, err := c.folderRepo.GetByID(ctx, file.FolderID); err == nil && folderTemp != nil {
				receivedFolderName = filepath.Base(folderTemp.LocalPath)
				syncDir = folderTemp.LocalPath
			} else {
				receivedFolderName = folderID[:8] // İlk 8 karakter
				syncDir = filepath.Join(syncBaseDir, receivedFolderName)
			}
			log.Printf("  ⚠️ Veritabanından folder adı kullanılıyor: %s", receivedFolderName)
		} else {
			// FileID'den klasör oluştur (son fallback)
			folderID = fmt.Sprintf("synced_%s", fileID[:8])
			receivedFolderName = folderID
			syncDir = filepath.Join(syncBaseDir, receivedFolderName)
			log.Printf("  ⚠️ Fallback folder adı oluşturuldu: %s", receivedFolderName)
		}
		
		// FileName belirle
		if fileName != "" {
			finalFileName = fileName  // Gelen fileName'i kullan
			log.Printf("  ✅ Gelen fileName kullanılıyor: %s", finalFileName)
		} else if file != nil && file.RelativePath != "" {
			finalFileName = file.RelativePath
			log.Printf("  ✅ File.RelativePath kullanılıyor: %s", finalFileName)
		} else {
			finalFileName = fmt.Sprintf("file_%s", fileID[:8])
			log.Printf("  ⚠️ Fallback fileName kullanılıyor: %s", finalFileName)
		}
		
		// Klasörü oluştur (eğer yoksa)
		if err := os.MkdirAll(syncDir, 0755); err != nil {
			log.Printf("  ⚠️ Sync klasörü oluşturulamadı: %v", err)
			syncDir = syncBaseDir // Fallback
			os.MkdirAll(syncDir, 0755)
		}
		
		outputPath = filepath.Join(syncDir, finalFileName)
		log.Printf("  📁 Dosya kaydediliyor: %s", outputPath)
			
		// Folder entity oluştur (alıcı taraf için)
		if folder == nil {
			// Önce folder zaten var mı kontrol et (aynı folder'dan başka dosyalar gelebilir)
			existingFolder, err := c.folderRepo.GetByID(ctx, folderID)
			if err == nil && existingFolder != nil {
				// Folder zaten var, onu kullan
				folder = existingFolder
				log.Printf("  ✅ Folder zaten var, mevcut folder kullanılıyor: %s (%s)", folderID[:8], folder.LocalPath)
				
				// 🔄 File watcher'a eklenmiş mi kontrol et ve eklenmemişse ekle
				if c.fileWatcher != nil {
					if err := c.fileWatcher.AddFolder(folder); err != nil {
						// Zaten ekliyse hata vermesi normal
						if !strings.Contains(err.Error(), "zaten izleniyor") {
							log.Printf("  ⚠️ Folder file watcher'a eklenemedi: %v", err)
						}
					} else {
						log.Printf("  ✅ Folder file watcher'a eklendi (bidirectional sync aktif)")
					}
				}
			} else {
				// Yeni folder oluştur (alıcı taraf için - received source)
				// Gelen sync mode'u kullan (eğer UNSPECIFIED ise BIDIRECTIONAL kullan - geriye dönük uyumluluk)
				receiverSyncModeEntity := convertProtoSyncModeToEntity(receiverSyncMode)
				folder = entity.NewReceivedFolder(syncDir, receiverSyncModeEntity)
				folder.ID = folderID
				if err := c.folderRepo.Create(ctx, folder); err != nil {
					log.Printf("  ⚠️ Folder entity oluşturulamadı: %v", err)
					// Hata durumunda tekrar oku (race condition olabilir)
					folder, _ = c.folderRepo.GetByID(ctx, folderID)
				} else {
				log.Printf("  ✅ Folder entity oluşturuldu: %s (%s)", folderID[:8], syncDir)
				
				// 🔄 File watcher'a otomatik ekle (bidirectional sync için)
				if c.fileWatcher != nil {
					if err := c.fileWatcher.AddFolder(folder); err != nil {
						log.Printf("  ⚠️ Folder file watcher'a eklenemedi: %v", err)
					} else {
						log.Printf("  ✅ Folder otomatik olarak file watcher'a eklendi (bidirectional sync aktif)")
					}
				}
				
				// 🔗 Desktop'ta symlink oluştur (kullanıcı erişimi için)
				if c.symlinkManager != nil {
					symlinkPath, err := c.symlinkManager.CreateDesktopSymlink(syncDir, receivedFolderName)
					if err != nil {
						log.Printf("  ⚠️ Desktop symlink oluşturulamadı: %v", err)
					} else {
						log.Printf("  🔗 Desktop symlink oluşturuldu: %s → %s", symlinkPath, syncDir)
					}
				}
			}
		}
	}
			
		// File entity oluştur/güncelle (alıcı taraf için)
		if file == nil {
			// Önce file zaten var mı kontrol et
			existingFile, err := c.fileRepo.GetByID(ctx, fileID)
			if err == nil && existingFile != nil {
				// File zaten var, folder ID'sini güncelle
				file = existingFile
				if file.FolderID != folderID {
					file.FolderID = folderID
					file.RelativePath = finalFileName
					if err := c.fileRepo.Update(ctx, file); err != nil {
						log.Printf("  ⚠️ File entity güncellenemedi: %v", err)
					} else {
						log.Printf("  ✅ File entity güncellendi: %s (folder: %s)", fileID[:8], folderID[:8])
					}
				} else {
					log.Printf("  ✅ File zaten var, mevcut file kullanılıyor: %s", fileID[:8])
				}
			} else {
				// Yeni file oluştur
				newFile := entity.NewFile(folderID, finalFileName, 0, time.Now())
				newFile.ID = fileID
				if err := c.fileRepo.Create(ctx, newFile); err != nil {
					log.Printf("  ⚠️ File entity oluşturulamadı: %v", err)
					// Hata durumunda tekrar oku (race condition olabilir)
					file, _ = c.fileRepo.GetByID(ctx, fileID)
				} else {
					log.Printf("  ✅ File entity oluşturuldu: %s (folder: %s, file: %s)", fileID[:8], folderID[:8], finalFileName)
					file = newFile
				}
			}
		} else if file.FolderID != folderID {
			// Folder ID'sini güncelle
			file.FolderID = folderID
			file.RelativePath = finalFileName
			if err := c.fileRepo.Update(ctx, file); err != nil {
				log.Printf("  ⚠️ File entity güncellenemedi: %v", err)
			} else {
				log.Printf("  ✅ File entity güncellendi: %s (folder: %s)", fileID[:8], folderID[:8])
			}
		}
		}
		
		// Output path'in dizinini oluştur
		dirPath := filepath.Dir(outputPath)
		if err := os.MkdirAll(dirPath, 0755); err != nil {
			return fmt.Errorf("dizin oluşturulamadı: %w", err)
		}
		
		// Dosyayı oluştur
		if err := c.fileReassembler.WriteToFile(fileID, outputPath); err != nil {
			return fmt.Errorf("dosya yazılamadı: %w", err)
		}
		
		// Dosya bilgilerini güncelle (boyut vs.) - Her durumda güncelle (yeni oluşturulmuş olsa bile)
		// File entity'yi tekrar oku (eğer yoksa)
		if file == nil {
			file, err = c.fileRepo.GetByID(ctx, fileID)
			if err != nil {
				log.Printf("  ⚠️ File entity okunamadı (güncelleme için): %v", err)
			}
		}
		
		if file != nil {
			// Dosya bilgilerini disk'ten oku ve güncelle
			if fileInfo, err := os.Stat(outputPath); err == nil {
				file.Size = fileInfo.Size()
				file.ModTime = fileInfo.ModTime()
				
				// Relative path'i güncelle (folder bilgisi varsa folder'a göre hesapla)
				if folder != nil {
					relPath, err := filepath.Rel(folder.LocalPath, outputPath)
					if err == nil {
						file.RelativePath = relPath
					} else {
						// Fallback: sadece dosya adı
						file.RelativePath = filepath.Base(outputPath)
					}
				} else {
					// Folder bilgisi yoksa, folder entity'yi oku
					if file.FolderID != "" {
						folderTemp, err := c.folderRepo.GetByID(ctx, file.FolderID)
						if err == nil && folderTemp != nil {
							relPath, err := filepath.Rel(folderTemp.LocalPath, outputPath)
							if err == nil {
								file.RelativePath = relPath
							} else {
								// Fallback: sadece dosya adı
								file.RelativePath = filepath.Base(outputPath)
							}
						}
					}
				}
				
				if err := c.fileRepo.Update(ctx, file); err != nil {
					log.Printf("  ⚠️ Dosya bilgileri güncellenemedi: %v", err)
				} else {
					log.Printf("  ✅ Dosya bilgileri güncellendi: size=%d bytes, modTime=%v, relativePath=%s", file.Size, file.ModTime, file.RelativePath)
				}
			} else {
				log.Printf("  ⚠️ Dosya bilgisi alınamadı: %v", err)
			}
		} else {
			log.Printf("  ⚠️ File entity bulunamadı, dosya bilgileri güncellenemedi")
		}
		
	log.Printf("  💾 Dosya kaydedildi: %s", outputPath)
	
	// Dosya başarıyla alındı, file_peer_sync tablosuna kayıt ekle (alıcı taraf)
	// peerID = gönderen peer'ın device ID'si (karşı taraf)
	// Alıcı tarafında: peer_id = gönderen, sender_device_id = gönderen (peerID)
	sync := entity.NewFilePeerSync(fileID, peerID, peerID)
	if err := c.filePeerSyncRepo.CreateOrUpdate(ctx, sync); err != nil {
		log.Printf("  ⚠️ File-peer sync kaydı eklenemedi (alıcı taraf): %v", err)
	} else {
		log.Printf("  ✅ File-peer sync kaydı eklendi (alıcı taraf): file=%s, peer=%s, sender=%s", fileID[:8], peerID[:8], peerID[:8])
	}
	
	// Cleanup
	c.fileReassembler.CleanupFile(fileID)
}

return nil
}

// getChunkRetryCount chunk retry sayısını döner
func (c *Container) getChunkRetryCount(retryKey string) int {
	c.retryMu.RLock()
	defer c.retryMu.RUnlock()
	return c.chunkRetryCount[retryKey]
}

// incrementChunkRetryCount chunk retry sayısını artırır
func (c *Container) incrementChunkRetryCount(retryKey string) {
	c.retryMu.Lock()
	defer c.retryMu.Unlock()
	c.chunkRetryCount[retryKey]++
}

// clearChunkRetryCount chunk retry sayısını sıfırlar
func (c *Container) clearChunkRetryCount(retryKey string) {
	c.retryMu.Lock()
	defer c.retryMu.Unlock()
	delete(c.chunkRetryCount, retryKey)
}

// retryChunkRequest chunk'ı tekrar talep eder (retry mekanizması)
func (c *Container) retryChunkRequest(ctx context.Context, peerID, chunkHash, fileID string, chunkIndex, totalChunks int, fileName, folderName string) error {
	log.Printf("  🔄 Chunk retry başlatılıyor: %s (file: %s, index: %d)", chunkHash[:8], fileID[:8], chunkIndex)
	
	// Bağlantıyı al
	conn, exists := c.transportProvider.GetConnection(peerID)
	if !exists {
		return fmt.Errorf("peer bağlı değil: %s", peerID)
	}
	
	// Kısa bir süre bekle (retry rate limiting)
	time.Sleep(100 * time.Millisecond)
	
	// Chunk'ı tekrar talep et (pull-based)
	if tcpConn, ok := conn.(interface {
		RequestChunk(ctx context.Context, chunkHash string) ([]byte, error)
	}); ok {
		// Chunk'ı talep et
		retryChunkData, err := tcpConn.RequestChunk(ctx, chunkHash)
		if err != nil {
			return fmt.Errorf("chunk retry talebi başarısız: %w", err)
		}
		
		// Tekrar handleIncomingChunk çağır (recursive retry - folder name ile)
		log.Printf("  ✅ Chunk retry alındı, tekrar doğrulanıyor: %s", chunkHash[:8])
		// Retry durumunda sync mode bilgisi olmayabilir, default değerler kullan
		return c.handleIncomingChunk(ctx, peerID, fileID, chunkHash, retryChunkData, chunkIndex, totalChunks, fileName, folderName, pb.SyncMode_SYNC_MODE_UNSPECIFIED, pb.SyncMode_SYNC_MODE_UNSPECIFIED)
	}
	
	return fmt.Errorf("retry desteği yok (connection type: %T)", conn)
}

// SyncFileWithPeerTracked dosyayı peer'a gönderir ve transfer durumunu takip eder
func (c *Container) SyncFileWithPeerTracked(ctx context.Context, peerID, fileID string, senderSyncMode, receiverSyncMode pb.SyncMode) error {
	log.Printf("🔄🔄🔄 SyncFileWithPeerTracked BAŞLATILIYOR - YENİ TRANSFER HAZIRLAMA: fileID=%s, peerID=%s", fileID[:8], peerID[:8])
	
	// Önceki transfer varsa explicit olarak temizle (CANCELLED, FAILED, ACTIVE hepsi)
	existingTransfer, exists := c.transferManager.GetTransfer(fileID)
	if exists {
		log.Printf("  🔄 ÖNCEKİ TRANSFER BULUNDU (state: %v, direction: %v) - Temizleniyor: %s", existingTransfer.State, existingTransfer.Direction, fileID[:8])
		
		// Transfer'i explicit olarak iptal et (context'i de iptal eder ve map'ten kaldırır)
		c.transferManager.CancelTransfer(fileID)
		log.Printf("  ✅ Önceki transfer iptal edildi ve map'ten kaldırıldı: %s", fileID[:8])
		
		// Önceki transfer'in goroutine'inin tamamen durması için bekle
		// SendChunkWithFileInfo blocking olduğu için context iptal edilse bile biraz zaman alabilir
		log.Printf("  ⏳ Önceki transfer'in goroutine'inin durması bekleniyor (300ms)...")
		time.Sleep(300 * time.Millisecond)
		log.Printf("  ✅ Bekleme tamamlandı, yeni transfer başlatılabilir: %s", fileID[:8])
		
		// Güvenlik kontrolü: Transfer hâlâ map'te varsa zorla kaldır
		c.transferManager.ForceRemoveTransfer(fileID)
	} else {
		log.Printf("  ✓ Önceki transfer bulunamadı (yeni transfer): %s", fileID[:8])
	}
	
	// FileReassembler'ı temizle (SEND direction için de - yeni transfer için hazırlık)
	c.fileReassembler.CleanupFile(fileID)
	log.Printf("  ✅ FileReassembler temizlendi (yeni transfer için hazır): %s", fileID[:8])
	
	// Dosya bilgisini al
	file, err := c.fileRepo.GetByID(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya bulunamadı: %w", err)
	}
	
	// Folder bilgisini al (folder adını alıcı tarafa göndermek için)
	var folderName string
	if file.FolderID != "" {
		folder, err := c.folderRepo.GetByID(ctx, file.FolderID)
		if err == nil && folder != nil {
			// Folder adını belirle (path'in son kısmı)
			folderName = filepath.Base(folder.LocalPath)
			log.Printf("  📁 Folder bilgisi alındı: %s (ID: %s)", folderName, folder.ID[:8])
		} else {
			log.Printf("  ⚠️ Folder bilgisi alınamadı: %v", err)
			folderName = "" // Fallback: boş string
		}
	}
	
	// Peer bilgisini al
	peer, err := c.peerRepo.GetByID(ctx, peerID)
	peerName := peerID[:8] // Fallback
	if err == nil && peer != nil {
		peerName = peer.Name
	}
	
	// Dosyanın chunk'larını al
	fileChunks, err := c.chunkRepo.GetFileChunks(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya chunk'ları alınamadı: %w", err)
	}
	
	if len(fileChunks) == 0 {
		return fmt.Errorf("dosyanın chunk'ı yok: %s", fileID)
	}
	
	log.Printf("  📦 %d chunk bulundu, transfer başlatılıyor: %s", len(fileChunks), fileID[:8])
	
	log.Printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	log.Printf("📊 StartTransfer ÇAĞRILIYOR")
	log.Printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	
	// Transfer durumunu başlat (SEND - dosya gönderiliyor)
	// StartTransfer içinde önceki transfer temizlenir ve yeni transfer başlatılır
	c.transferManager.StartTransfer(
		fileID,
		file.RelativePath,
		peerID,
		peerName,
		pb.TransferDirection_TRANSFER_DIRECTION_SEND,
		int32(len(fileChunks)),
		file.Size,
	)
	
	log.Printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	log.Printf("✅ StartTransfer TAMAMLANDI")
	log.Printf("      File: %s", file.RelativePath)
	log.Printf("      Chunks: %d, Bytes: %d", len(fileChunks), file.Size)
	log.Printf("      Chunk'lar BAŞTAN (index 0) gönderilecek")
	log.Printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	
	// Transfer context'ini al (iptal kontrolü için)
	// StartTransfer sonrası yeni transfer'in context'ini almalıyız
	// Kısa bir süre bekle ki StartTransfer tamamlanmış olsun
	time.Sleep(10 * time.Millisecond)
	
	transferCtx, hasContext := c.transferManager.GetTransferContext(fileID)
	if !hasContext {
		log.Printf("  ⚠️ Transfer context bulunamadı, yeni context oluşturuluyor: %s", fileID[:8])
		// Yeni bir context oluştur (fallback)
		var cancel context.CancelFunc
		transferCtx, cancel = context.WithCancel(context.Background())
		_ = cancel // Cancel fonksiyonunu sakla (gerekirse kullanılabilir)
	} else {
		log.Printf("  ✅ Yeni transfer context'i alındı: %s", fileID[:8])
	}
	
	// Context'in iptal edilmediğinden emin ol
	if transferCtx != nil && transferCtx.Err() != nil {
		log.Printf("  ⚠️ Transfer context iptal edilmiş, yeni context oluşturuluyor: %s", fileID[:8])
		var cancel context.CancelFunc
		transferCtx, cancel = context.WithCancel(context.Background())
		_ = cancel
	}
	
	// Dosyayı peer'a gönder (progress callback ile)
	// Type assertion ile SyncFileWithPeerWithProgress metoduna eriş
	if useCaseImpl, ok := c.p2pTransferUseCase.(interface {
		SyncFileWithPeerWithProgress(ctx context.Context, peerID, fileID string, progressCallback func(completedChunks, totalChunks int, transferredBytes int64), senderSyncMode, receiverSyncMode pb.SyncMode) error
	}); ok {
		err = useCaseImpl.SyncFileWithPeerWithProgress(transferCtx, peerID, fileID, func(completedChunks, totalChunks int, transferredBytes int64) {
			// Context iptal kontrolü (progress güncellemeden önce)
			if transferCtx != nil && transferCtx.Err() != nil {
				log.Printf("  🛑 Transfer iptal edildi, progress güncellemesi atlanıyor: %s", fileID)
				return // Progress güncellemesini atla
			}
			// Her chunk gönderildiğinde progress güncelle
			c.transferManager.UpdateChunkProgress(fileID, int32(completedChunks), transferredBytes)
		}, senderSyncMode, receiverSyncMode)
	} else {
		// Fallback: progress callback olmadan
		err = c.p2pTransferUseCase.SyncFileWithPeer(transferCtx, peerID, fileID)
	}
	if err != nil {
		// Context iptal edilmişse transfer'i iptal olarak işaretle
		if err == context.Canceled || err == context.DeadlineExceeded || 
		   (transferCtx != nil && transferCtx.Err() != nil) {
			log.Printf("  🛑 Transfer iptal edildi: %s", file.RelativePath)
			// TransferManager.CancelTransfer zaten çağrılmış, burada sadece log
		} else {
			// Transfer durumunu başarısız olarak işaretle
			c.transferManager.FailTransfer(fileID, err)
		}
		return err
	}
	
	// Transfer durumunu tamamlandı olarak işaretle
	c.transferManager.CompleteTransfer(fileID)
	log.Printf("  ✅ Transfer tamamlandı: %s", file.RelativePath)
	
	// Dosya başarıyla gönderildi, file_peer_sync tablosuna kayıt ekle
	deviceID, err := c.getOrCreateDeviceID()
	if err != nil {
		log.Printf("  ⚠️ Device ID alınamadı, sync kaydı eklenemedi: %v", err)
	} else {
		sync := entity.NewFilePeerSync(fileID, peerID, deviceID)
		if err := c.filePeerSyncRepo.CreateOrUpdate(ctx, sync); err != nil {
			log.Printf("  ⚠️ File-peer sync kaydı eklenemedi: %v", err)
		} else {
			log.Printf("  ✅ File-peer sync kaydı eklendi: file=%s, peer=%s", fileID[:8], peerID[:8])
		}
	}
	
	return nil
}

// initFileWatcher file watcher'ı başlatır
func (c *Container) initFileWatcher() error {
	// FileWatcher oluştur
	fw, err := watcher.NewFileWatcher()
	if err != nil {
		return fmt.Errorf("file watcher oluşturulamadı: %w", err)
	}
	c.fileWatcher = fw
	
	// EventBroadcaster oluştur (UI event streaming için)
	c.eventBroadcaster = watcher.NewEventBroadcaster()
	log.Println("✓ Event broadcaster oluşturuldu")
	
	// EventHandler oluştur
	eventHandler := watcher.NewEventHandler(
		c.fileRepo,
		c.chunkingUseCase,
		c.folderRepo,
		c.chunkRepo,
		c.eventBroadcaster, // Broadcaster'ı EventHandler'a ver
	)
	c.eventHandler = eventHandler
	
	// Event handler'ı watcher'a bağla
	c.fileWatcher.OnEvent(eventHandler.HandleEvent)
	
	// File changed callback (yeni dosya için - tüm chunk'lar)
	eventHandler.SetOnFileChanged(func(fileID, folderID string) error {
		// Yeni dosya oluşturulduğunda tüm peer'lara sync et
		return c.syncFileToAllPeers(fileID, folderID)
	})
	
	// Chunks changed callback (MODIFY için - sadece değişen chunk'lar)
	eventHandler.SetOnChunksChanged(func(fileID, folderID string, changedChunks []int) error {
		// Dosya düzenlendiğinde sadece değişen chunk'ları sync et (DELTA SYNC)
		return c.syncChangedChunksToAllPeers(fileID, folderID, changedChunks)
	})
	
	// File deleted callback (DELETE için - karşı taraftan da silinmeli)
	eventHandler.SetOnFileDeleted(func(fileID, folderID string) error {
		// Dosya silindiğinde tüm peer'lara silme bildirimi gönder
		return c.DeleteFileFromAllPeers(fileID, folderID)
	})
	
	// Error handler
	c.fileWatcher.OnError(func(err error) {
		log.Printf("⚠️ File watcher hatası: %v", err)
	})
	
	// Watcher'ı başlat
	if err := c.fileWatcher.Start(); err != nil {
		return fmt.Errorf("file watcher başlatılamadı: %w", err)
	}
	
	// Aktif klasörleri otomatik olarak watch'a ekle
	ctx := context.Background()
	folders, err := c.folderRepo.GetAll(ctx)
	if err != nil {
		log.Printf("⚠️ Aktif klasörler alınamadı: %v", err)
	} else {
		for _, folder := range folders {
			if folder.IsActive {
				if err := c.fileWatcher.AddFolder(folder); err != nil {
					log.Printf("⚠️ Klasör watch'a eklenemedi (%s): %v", folder.LocalPath, err)
				}
			}
		}
	}
	
	log.Println("✅ File watcher başlatıldı")
	return nil
}

// FileWatcher returns the file watcher instance
func (c *Container) FileWatcher() *watcher.FileWatcher {
	return c.fileWatcher
}

// EventBroadcaster event broadcaster'ı döner
func (c *Container) EventBroadcaster() *watcher.EventBroadcaster {
	return c.eventBroadcaster
}

// SymlinkManager returns the symlink manager instance
func (c *Container) SymlinkManager() *filesystem.SymlinkManager {
	return c.symlinkManager
}

// syncFileToAllPeers dosyayı tüm peer'lara sync eder (otomatik sync için)
func (c *Container) syncFileToAllPeers(fileID, folderID string) error {
	ctx := context.Background()
	
	// Folder bilgisini al (sync mode kontrolü için)
	folder, err := c.folderRepo.GetByID(ctx, folderID)
	if err != nil {
		log.Printf("  ⚠️ Folder bulunamadı, sync atlanıyor: %v", err)
		return nil
	}
	
	// Sync mode kontrolü
	// SEND_ONLY veya BIDIRECTIONAL ise karşıya gönder
	// RECEIVE_ONLY ise karşıya gönderme
	if folder.SyncMode == entity.SyncModeReceiveOnly {
		log.Printf("  ℹ️  Folder receive-only mode'da, yeni dosya sync atlanıyor: %s", folderID[:8])
		return nil
	}
	
	// TransportProvider yoksa atla
	if c.transportProvider == nil {
		log.Printf("  ℹ️  TransportProvider yok, sync atlanıyor: %s", fileID[:8])
		return nil
	}
	
	// Gerçek bağlı peer'ları al (TCP connection'lardan)
	allConnections := c.transportProvider.GetAllConnections()
	
	if len(allConnections) == 0 {
		log.Printf("  ℹ️  Hiç bağlı peer yok, sync atlanıyor: %s", fileID[:8])
		return nil
	}
	
	log.Printf("🔄 Dosya otomatik sync ediliyor: %s -> %d peer", fileID[:8], len(allConnections))
	
	// Her peer'a sync et - SADECE DAHA ÖNCE SENKRONİZE EDİLMİŞ DOSYALAR İÇİN
	// Otomatik sync için: gönderen mod = folder'ın sync mode'u, alıcı mod = BIDIRECTIONAL (varsayılan)
	senderModeProto := convertEntitySyncModeToProto(folder.SyncMode)
	receiverModeProto := pb.SyncMode_SYNC_MODE_BIDIRECTIONAL
	
	// Dosyanın daha önce sync edilip edilmediğini kontrol et
	existingSyncs, err := c.filePeerSyncRepo.GetByFileID(ctx, fileID)
	if err != nil {
		log.Printf("  ⚠️ Dosya sync kayıtları alınamadı: %v", err)
		existingSyncs = []*entity.FilePeerSync{}
	}
	
	// Eğer dosya hiç sync edilmemişse, aynı folder'daki diğer dosyaların sync edildiği peer'ları bul
	syncedPeerIDsMap := make(map[string]bool) // Zaten sync edilmiş peer'lar
	for _, sync := range existingSyncs {
		syncedPeerIDsMap[sync.PeerID] = true
	}
	
	// Eğer dosya hiç sync edilmemişse ve folder BIDIRECTIONAL ise, folder'daki diğer dosyaların sync edildiği peer'ları bul
	if len(existingSyncs) == 0 && (folder.SyncMode == entity.SyncModeBidirectional || folder.SyncMode == entity.SyncModeSendOnly) {
		log.Printf("  🔍 Dosya daha önce sync edilmemiş, aynı folder'daki diğer dosyaların sync edildiği peer'lar aranıyor: folder=%s", folderID[:8])
		
		folderPeerIDs, err := c.filePeerSyncRepo.GetPeerIDsByFolderID(ctx, folderID)
		if err != nil {
			log.Printf("  ⚠️ Folder peer ID'leri alınamadı: %v", err)
		} else if len(folderPeerIDs) > 0 {
			log.Printf("  ✅ Folder'daki diğer dosyaların sync edildiği %d peer bulundu, file_peer_sync kayıtları oluşturuluyor", len(folderPeerIDs))
			
			// Mevcut device ID'mizi al (sender olarak kullanılacak)
			currentDeviceID, err := c.getOrCreateDeviceID()
			if err != nil {
				log.Printf("  ⚠️ Device ID alınamadı: %v", err)
				currentDeviceID = "" // Fallback
			}
			
			// Her peer için file_peer_sync kaydı oluştur (pre-sync kayıtları)
			for _, folderPeerID := range folderPeerIDs {
				// Sadece bağlı olan peer'lar için kayıt oluştur
				if conn, exists := c.transportProvider.GetConnection(folderPeerID); exists && conn != nil {
					sync := entity.NewFilePeerSync(fileID, folderPeerID, currentDeviceID)
					if err := c.filePeerSyncRepo.CreateOrUpdate(ctx, sync); err != nil {
						log.Printf("  ⚠️ Pre-sync kaydı oluşturulamadı (peer: %s, file: %s): %v", folderPeerID[:8], fileID[:8], err)
					} else {
						syncedPeerIDsMap[folderPeerID] = true // Artık sync edilebilir
						log.Printf("  ✅ Pre-sync kaydı oluşturuldu (peer: %s, file: %s)", folderPeerID[:8], fileID[:8])
					}
				}
			}
		}
	}
	
	for _, conn := range allConnections {
		peerID := conn.GetPeerID()
		
		// Dosya bu peer ile sync edilebilir mi? (daha önce sync edilmiş veya pre-sync kaydı oluşturulmuş)
		if !syncedPeerIDsMap[peerID] {
			log.Printf("  ℹ️  Dosya bu peer ile sync edilemez (daha önce sync edilmemiş ve folder'daki diğer dosyalar da sync edilmemiş): file=%s, peer=%s", fileID[:8], peerID[:8])
			continue
		}
		
		go func(pid string) {
			if err := c.SyncFileWithPeerTracked(ctx, pid, fileID, senderModeProto, receiverModeProto); err != nil {
				log.Printf("⚠️ Otomatik sync hatası (peer: %s, file: %s): %v", pid[:8], fileID[:8], err)
			} else {
				log.Printf("✅ Otomatik sync başarılı (peer: %s, file: %s)", pid[:8], fileID[:8])
			}
		}(peerID)
	}
	
	return nil
}

// syncChangedChunksToAllPeers sadece değişen chunk'ları tüm peer'lara sync eder (DELTA SYNC)
func (c *Container) syncChangedChunksToAllPeers(fileID, folderID string, changedChunkIndices []int) error {
	ctx := context.Background()
	
	// Folder bilgisini al (sync mode kontrolü için)
	folder, err := c.folderRepo.GetByID(ctx, folderID)
	if err != nil {
		log.Printf("  ⚠️ Folder bulunamadı, delta sync atlanıyor: %v", err)
		return nil
	}
	
	// Sync mode kontrolü
	// SEND_ONLY veya BIDIRECTIONAL ise karşıya gönder
	// RECEIVE_ONLY ise karşıya gönderme
	if folder.SyncMode == entity.SyncModeReceiveOnly {
		log.Printf("  ℹ️  Folder receive-only mode'da, değişiklik sync atlanıyor: %s", folderID[:8])
		return nil
	}
	
	// TransportProvider yoksa atla
	if c.transportProvider == nil {
		log.Printf("  ℹ️  TransportProvider yok, delta sync atlanıyor: %s", fileID[:8])
		return nil
	}
	
	// Gerçek bağlı peer'ları al
	allConnections := c.transportProvider.GetAllConnections()
	
	if len(allConnections) == 0 {
		log.Printf("  ℹ️  Hiç bağlı peer yok, delta sync atlanıyor: %s", fileID[:8])
		return nil
	}
	
	log.Printf("🔄 DELTA SYNC: %d chunk değişikliği -> %d peer", len(changedChunkIndices), len(allConnections))
	
	// Dosyanın daha önce sync edilip edilmediğini kontrol et
	existingSyncs, err := c.filePeerSyncRepo.GetByFileID(ctx, fileID)
	if err != nil {
		log.Printf("  ⚠️ Dosya sync kayıtları alınamadı: %v", err)
		existingSyncs = []*entity.FilePeerSync{}
	}
	
	// Eğer dosya hiç sync edilmemişse, aynı folder'daki diğer dosyaların sync edildiği peer'ları bul
	syncedPeerIDsMap := make(map[string]bool) // Zaten sync edilmiş peer'lar
	for _, sync := range existingSyncs {
		syncedPeerIDsMap[sync.PeerID] = true
	}
	
	// Eğer dosya hiç sync edilmemişse ve folder BIDIRECTIONAL ise, folder'daki diğer dosyaların sync edildiği peer'ları bul
	if len(existingSyncs) == 0 && (folder.SyncMode == entity.SyncModeBidirectional || folder.SyncMode == entity.SyncModeSendOnly) {
		log.Printf("  🔍 Dosya daha önce sync edilmemiş (delta sync), aynı folder'daki diğer dosyaların sync edildiği peer'lar aranıyor: folder=%s", folderID[:8])
		
		folderPeerIDs, err := c.filePeerSyncRepo.GetPeerIDsByFolderID(ctx, folderID)
		if err != nil {
			log.Printf("  ⚠️ Folder peer ID'leri alınamadı: %v", err)
		} else if len(folderPeerIDs) > 0 {
			log.Printf("  ✅ Folder'daki diğer dosyaların sync edildiği %d peer bulundu, file_peer_sync kayıtları oluşturuluyor", len(folderPeerIDs))
			
			// Mevcut device ID'mizi al (sender olarak kullanılacak)
			currentDeviceID, err := c.getOrCreateDeviceID()
			if err != nil {
				log.Printf("  ⚠️ Device ID alınamadı: %v", err)
				currentDeviceID = "" // Fallback
			}
			
			// Her peer için file_peer_sync kaydı oluştur (pre-sync kayıtları)
			for _, folderPeerID := range folderPeerIDs {
				// Sadece bağlı olan peer'lar için kayıt oluştur
				if conn, exists := c.transportProvider.GetConnection(folderPeerID); exists && conn != nil {
					sync := entity.NewFilePeerSync(fileID, folderPeerID, currentDeviceID)
					if err := c.filePeerSyncRepo.CreateOrUpdate(ctx, sync); err != nil {
						log.Printf("  ⚠️ Pre-sync kaydı oluşturulamadı (peer: %s, file: %s): %v", folderPeerID[:8], fileID[:8], err)
					} else {
						syncedPeerIDsMap[folderPeerID] = true // Artık sync edilebilir
						log.Printf("  ✅ Pre-sync kaydı oluşturuldu (peer: %s, file: %s)", folderPeerID[:8], fileID[:8])
					}
				}
			}
		}
	}
	
	// Otomatik sync için: gönderen mod = folder'ın sync mode'u, alıcı mod = BIDIRECTIONAL (varsayılan)
	senderModeProto := convertEntitySyncModeToProto(folder.SyncMode)
	receiverModeProto := pb.SyncMode_SYNC_MODE_BIDIRECTIONAL
	
	for _, conn := range allConnections {
		peerID := conn.GetPeerID()
		
		// Dosya bu peer ile sync edilebilir mi? (daha önce sync edilmiş veya pre-sync kaydı oluşturulmuş)
		if !syncedPeerIDsMap[peerID] {
			log.Printf("  ℹ️  Dosya bu peer ile sync edilemez (daha önce sync edilmemiş ve folder'daki diğer dosyalar da sync edilmemiş): file=%s, peer=%s", fileID[:8], peerID[:8])
			continue
		}
		
		go func(pid string, indices []int) {
			if err := c.syncSpecificChunksToPeer(ctx, pid, fileID, indices, senderModeProto, receiverModeProto); err != nil {
				log.Printf("⚠️ Delta sync hatası (peer: %s, file: %s): %v", pid[:8], fileID[:8], err)
			} else {
				log.Printf("✅ Delta sync başarılı (peer: %s, %d chunk)", pid[:8], len(indices))
			}
		}(peerID, changedChunkIndices)
	}
	
	return nil
}

// syncSpecificChunksToPeer belirli chunk'ları peer'a gönderir
func (c *Container) syncSpecificChunksToPeer(ctx context.Context, peerID, fileID string, chunkIndices []int, senderSyncMode, receiverSyncMode pb.SyncMode) error {
	// Dosya bilgisini al
	file, err := c.fileRepo.GetByID(ctx, fileID)
	if err != nil {
		return fmt.Errorf("dosya bulunamadı: %w", err)
	}
	
	// Folder bilgisini al (folder adı için)
	folder, err := c.folderRepo.GetByID(ctx, file.FolderID)
	if err != nil {
		return fmt.Errorf("folder bulunamadı: %w", err)
	}
	folderName := filepath.Base(folder.LocalPath)
	
	// Tüm chunk'ları al
	allChunks, err := c.chunkRepo.GetFileChunks(ctx, fileID)
	if err != nil {
		return fmt.Errorf("chunk'lar alınamadı: %w", err)
	}
	
	// Sadece değişen chunk'ları filtrele
	chunksToSend := make([]*entity.FileChunk, 0)
	for _, chunk := range allChunks {
		for _, idx := range chunkIndices {
			if chunk.ChunkIndex == idx {
				chunksToSend = append(chunksToSend, chunk)
				break
			}
		}
	}
	
	if len(chunksToSend) == 0 {
		return fmt.Errorf("gönderilecek chunk bulunamadı")
	}
	
	// Bağlantıyı al
	conn, exists := c.transportProvider.GetConnection(peerID)
	if !exists {
		return fmt.Errorf("peer bağlı değil: %s", peerID)
	}
	
	// Her değişen chunk'ı gönder
	for _, fc := range chunksToSend {
		// Chunk verisini al
		chunkData, err := c.chunkingUseCase.GetChunkData(ctx, fc.ChunkHash)
		if err != nil {
			return fmt.Errorf("chunk verisi alınamadı: %w", err)
		}
		
		// Chunk'ı gönder (file + folder bilgisiyle + sync mode)
		if tcpConn, ok := conn.(interface {
			SendChunkWithFileInfo(ctx context.Context, chunkHash string, data []byte, fileID string, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error
		}); ok {
			if err := tcpConn.SendChunkWithFileInfo(
				ctx,
				fc.ChunkHash,
				chunkData,
				fileID,
				fc.ChunkIndex,
				len(allChunks),
				file.RelativePath,
				folderName,  // Folder adı eklendi
				senderSyncMode,  // Gönderen sync mode
				receiverSyncMode,  // Alıcı sync mode
			); err != nil {
				return fmt.Errorf("chunk gönderilemedi [%d]: %w", fc.ChunkIndex, err)
			}
			log.Printf("  📤 Değişen chunk gönderildi: index=%d, hash=%s", fc.ChunkIndex, fc.ChunkHash[:8])
		} else {
			return fmt.Errorf("connection SendChunkWithFileInfo desteklemiyor")
		}
	}
	
	return nil
}

// DeleteFileFromAllPeers dosyayı tüm peer'lardan siler (otomatik sync için) - Public method
func (c *Container) DeleteFileFromAllPeers(fileID, folderID string) error {
	return c.deleteFileFromAllPeers(fileID, folderID)
}

// deleteFileFromAllPeers dosyayı tüm peer'lardan siler (otomatik sync için) - Internal method
func (c *Container) deleteFileFromAllPeers(fileID, folderID string) error {
	ctx := context.Background()
	
	// Folder bilgisini al (sync mode kontrolü için)
	folder, err := c.folderRepo.GetByID(ctx, folderID)
	if err != nil {
		log.Printf("  ⚠️ Folder bulunamadı, silme sync atlanıyor: %v", err)
		return nil
	}
	
	// Sync mode kontrolü
	// SEND_ONLY veya BIDIRECTIONAL ise karşıya gönder
	// RECEIVE_ONLY ise karşıya gönderme
	if folder.SyncMode == entity.SyncModeReceiveOnly {
		log.Printf("  ℹ️  Folder receive-only mode'da, silme sync atlanıyor: %s", folderID[:8])
		return nil
	}
	
	// TransportProvider yoksa atla
	if c.transportProvider == nil {
		log.Printf("  ℹ️  TransportProvider yok, silme sync atlanıyor: %s", fileID[:8])
		return nil
	}
	
	// Gerçek bağlı peer'ları al
	allConnections := c.transportProvider.GetAllConnections()
	
	if len(allConnections) == 0 {
		log.Printf("  ℹ️  Hiç bağlı peer yok, silme sync atlanıyor: %s", fileID[:8])
		return nil
	}
	
	log.Printf("🗑️ Dosya silme bildirimi gönderiliyor: %s -> %d peer", fileID[:8], len(allConnections))
	
	// Dosyanın daha önce sync edilip edilmediğini kontrol et
	existingSyncs, err := c.filePeerSyncRepo.GetByFileID(ctx, fileID)
	if err != nil {
		log.Printf("  ⚠️ Dosya sync kayıtları alınamadı: %v", err)
		existingSyncs = []*entity.FilePeerSync{}
	}
	
	// Eğer dosya hiç sync edilmemişse, aynı folder'daki diğer dosyaların sync edildiği peer'ları bul
	syncedPeerIDsMap := make(map[string]bool) // Zaten sync edilmiş peer'lar
	for _, sync := range existingSyncs {
		syncedPeerIDsMap[sync.PeerID] = true
	}
	
	// ALICI TARAFINDA ÇİFT YÖNLÜ SENKRONİZASYON: Eğer dosya hiç sync edilmemişse veya 
	// folder RECEIVED source'lu ve BIDIRECTIONAL ise, folder'daki diğer dosyaların sync edildiği peer'ları bul
	// Bu durumda alıcının silme işlemi göndericiye iletilmelidir
	shouldCheckFolderPeers := len(existingSyncs) == 0 && (folder.SyncMode == entity.SyncModeBidirectional || folder.SyncMode == entity.SyncModeSendOnly)
	
	// Ayrıca RECEIVED folder + BIDIRECTIONAL durumunda, dosya sync kayıtları silinmiş olsa bile
	// folder'daki diğer dosyaların sync edildiği peer'ları bul (alıcının silme işlemi göndericiye iletilmeli)
	if folder.Source == entity.FolderSourceReceived && folder.SyncMode == entity.SyncModeBidirectional {
		shouldCheckFolderPeers = true
		log.Printf("  🔍 RECEIVED folder + BIDIRECTIONAL: Alıcının silme işlemi göndericiye iletilmeli, folder peer'ları aranıyor: folder=%s", folderID[:8])
	}
	
	if shouldCheckFolderPeers {
		log.Printf("  🔍 Dosya silme bildirimi için folder'daki diğer dosyaların sync edildiği peer'lar aranıyor: folder=%s", folderID[:8])
		
		folderPeerIDs, err := c.filePeerSyncRepo.GetPeerIDsByFolderID(ctx, folderID)
		if err != nil {
			log.Printf("  ⚠️ Folder peer ID'leri alınamadı: %v", err)
		} else if len(folderPeerIDs) > 0 {
			log.Printf("  ✅ Folder'daki diğer dosyaların sync edildiği %d peer bulundu, silme bildirimi gönderilecek", len(folderPeerIDs))
			
			// Bu peer'lar için de silme bildirimi gönder (dosya zaten silindi, sadece bildirim)
			for _, folderPeerID := range folderPeerIDs {
				if _, exists := c.transportProvider.GetConnection(folderPeerID); exists {
					syncedPeerIDsMap[folderPeerID] = true // Bildirim gönderilebilir
					log.Printf("  ✅ Peer eklendi (folder peer'larından): %s", folderPeerID[:8])
				}
			}
		} else {
			log.Printf("  ⚠️ Folder'daki diğer dosyaların sync edildiği peer bulunamadı")
		}
	}
	
	// Her peer'a silme bildirimi gönder (daha önce sync edilmiş veya folder'daki diğer dosyalar sync edilmiş)
	for _, conn := range allConnections {
		peerID := conn.GetPeerID()
		
		// Dosya bu peer ile sync edilmiş mi? (daha önce sync edilmiş veya folder'daki diğer dosyalar sync edilmiş)
		if !syncedPeerIDsMap[peerID] {
			log.Printf("  ℹ️  Dosya bu peer ile sync edilmemiş, silme bildirimi gönderilmiyor: file=%s, peer=%s", fileID[:8], peerID[:8])
			continue
		}
		
		go func(pid string) {
			if err := c.sendDeleteFileToPeer(ctx, pid, fileID); err != nil {
				log.Printf("⚠️ Silme bildirimi hatası (peer: %s, file: %s): %v", pid[:8], fileID[:8], err)
			} else {
				log.Printf("✅ Silme bildirimi gönderildi (peer: %s, file: %s)", pid[:8], fileID[:8])
			}
		}(peerID)
	}
	
	return nil
}

// sendDeleteFileToPeer peer'a dosya silme bildirimi gönderir (peer-to-peer TCP)
func (c *Container) sendDeleteFileToPeer(ctx context.Context, peerID, fileID string) error {
	log.Printf("  📤 Dosya silme bildirimi gönderiliyor: peer=%s, file=%s", peerID[:8], fileID[:8])
	
	// TCP connection al
	conn, ok := c.transportProvider.GetConnection(peerID)
	if !ok || conn == nil {
		return fmt.Errorf("peer connection bulunamadı: %s", peerID[:8])
	}
	
	// SendFileDelete metodu var mı kontrol et (type assertion)
	if tcpConn, ok := conn.(interface {
		SendFileDelete(ctx context.Context, fileID string) error
	}); ok {
		// Peer'a TCP üzerinden dosya silme bildirimi gönder
		if err := tcpConn.SendFileDelete(ctx, fileID); err != nil {
			log.Printf("  ❌ Dosya silme bildirimi gönderilemedi (peer: %s, file: %s): %v", peerID[:8], fileID[:8], err)
			return fmt.Errorf("SendFileDelete başarısız: %w", err)
		}
		
		log.Printf("  ✅ Dosya silme bildirimi başarıyla gönderildi: peer=%s, file=%s", peerID[:8], fileID[:8])
		return nil
	}
	
	return fmt.Errorf("connection SendFileDelete desteklemiyor")
}

// convertProtoSyncModeToEntity protobuf SyncMode'u entity SyncMode'a çevirir
func convertProtoSyncModeToEntity(mode pb.SyncMode) entity.SyncMode {
	switch mode {
	case pb.SyncMode_SYNC_MODE_BIDIRECTIONAL:
		return entity.SyncModeBidirectional
	case pb.SyncMode_SYNC_MODE_SEND_ONLY:
		return entity.SyncModeSendOnly
	case pb.SyncMode_SYNC_MODE_RECEIVE_ONLY:
		return entity.SyncModeReceiveOnly
	default:
		// UNSPECIFIED veya bilinmeyen değer için varsayılan: BIDIRECTIONAL (geriye dönük uyumluluk)
		return entity.SyncModeBidirectional
	}
}

// convertEntitySyncModeToProto entity SyncMode'u protobuf SyncMode'a çevirir
func convertEntitySyncModeToProto(mode entity.SyncMode) pb.SyncMode {
	switch mode {
	case entity.SyncModeBidirectional:
		return pb.SyncMode_SYNC_MODE_BIDIRECTIONAL
	case entity.SyncModeSendOnly:
		return pb.SyncMode_SYNC_MODE_SEND_ONLY
	case entity.SyncModeReceiveOnly:
		return pb.SyncMode_SYNC_MODE_RECEIVE_ONLY
	default:
		return pb.SyncMode_SYNC_MODE_BIDIRECTIONAL
	}
}
