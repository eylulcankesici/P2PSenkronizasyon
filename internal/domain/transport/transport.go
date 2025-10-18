package transport

import (
	"context"
	"time"
)

// TransportType transport türünü belirtir
type TransportType string

const (
	TransportTypeLAN   TransportType = "lan"   // Local Area Network (mDNS + TCP)
	TransportTypeWAN   TransportType = "wan"   // Wide Area Network (STUN/TURN + WebRTC)
	TransportTypeRelay TransportType = "relay" // Relay Server fallback
)

// DiscoveredPeer keşfedilen bir peer'ı temsil eder
type DiscoveredPeer struct {
	DeviceID    string            // Benzersiz cihaz ID'si
	DeviceName  string            // Kullanıcı dostu isim
	Addresses   []string          // Bağlanılabilir adresler (IP:PORT)
	Port        int               // P2P listen port
	Version     string            // Aether version
	Metadata    map[string]string // Ekstra metadata (TXT records)
	DiscoveredAt time.Time        // Keşfedilme zamanı
	TransportType TransportType   // Hangi transport ile keşfedildi
}

// FileMetadata dosya meta verilerini temsil eder
type FileMetadata struct {
	FileID       string
	RelativePath string
	Size         int64
	GlobalHash   string
	ChunkHashes  []string
	ModTime      time.Time
}

// ChunkTransferProgress chunk transfer ilerleme durumu
type ChunkTransferProgress struct {
	ChunkHash       string
	BytesTransferred int64
	TotalBytes      int64
	IsComplete      bool
}

// Connection bir peer bağlantısını temsil eder
// Single Responsibility: Tek bir peer ile iletişim
type Connection interface {
	// Data Transfer Operations
	SendChunk(ctx context.Context, chunkHash string, data []byte) error
	RequestChunk(ctx context.Context, chunkHash string) ([]byte, error)
	SendMetadata(ctx context.Context, metadata *FileMetadata) error
	RequestMetadata(ctx context.Context, fileID string) (*FileMetadata, error)
	
	// Connection Management
	Ping(ctx context.Context) (time.Duration, error) // Latency ölçümü
	Close() error
	
	// Connection Info (Read-only)
	GetPeerID() string
	GetAddress() string
	GetLatency() time.Duration
	IsConnected() bool
	GetTransportType() TransportType
	GetConnectionTime() time.Time
}

// TransportProvider transport katmanı soyutlaması
// Dependency Inversion: High-level code bu interface'e bağımlı
// Open/Closed: Yeni transport'lar eklenebilir (LAN, WAN, Relay)
type TransportProvider interface {
	// Discovery Operations
	StartDiscovery(ctx context.Context) error
	StopDiscovery() error
	GetDiscoveredPeers() []*DiscoveredPeer
	
	// Connection Operations
	Connect(ctx context.Context, peer *DiscoveredPeer) (Connection, error)
	Disconnect(peerID string) error
	GetConnection(peerID string) (Connection, bool)
	GetAllConnections() []Connection
	
	// Lifecycle Management
	Start(ctx context.Context) error
	Stop() error
	
	// Transport Info
	GetTransportType() TransportType
	GetListenPort() int
	GetDeviceID() string
	GetDeviceName() string
	
	// Event Callbacks (optional)
	OnPeerDiscovered(callback func(*DiscoveredPeer))
	OnPeerLost(callback func(string))
	OnConnectionEstablished(callback func(Connection))
	OnConnectionLost(callback func(string))
}

// ConnectionPool birden fazla connection'ı yönetir
// Interface Segregation: Sadece pool operasyonları
type ConnectionPool interface {
	Add(conn Connection) error
	Remove(peerID string) error
	Get(peerID string) (Connection, bool)
	GetAll() []Connection
	GetByTransportType(transportType TransportType) []Connection
	Size() int
	Clear() error
}

// Discovery peer keşif interface'i
// Interface Segregation: Sadece discovery operasyonları
type Discovery interface {
	Start(ctx context.Context) error
	Stop() error
	GetDiscoveredPeers() []*DiscoveredPeer
	Announce(deviceID, deviceName string, port int, metadata map[string]string) error
}

// ConnectionManager bağlantı yönetimi interface'i
// Interface Segregation: Sadece connection operasyonları
type ConnectionManager interface {
	Connect(ctx context.Context, address string, peerID string) (Connection, error)
	Accept(ctx context.Context) (Connection, error) // Incoming connections
	Listen(ctx context.Context, port int) error
	Close() error
}

// DataTransferProtocol veri transfer protokolü
// Interface Segregation: Sadece protocol operasyonları
type DataTransferProtocol interface {
	EncodeChunkRequest(chunkHash string) ([]byte, error)
	DecodeChunkRequest(data []byte) (chunkHash string, err error)
	EncodeChunkResponse(chunkHash string, chunkData []byte) ([]byte, error)
	DecodeChunkResponse(data []byte) (chunkHash string, chunkData []byte, err error)
	EncodeMetadata(metadata *FileMetadata) ([]byte, error)
	DecodeMetadata(data []byte) (*FileMetadata, error)
}

