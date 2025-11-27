package wan

import (
	"context"
	"fmt"
	"log"
	"sync"
	"time"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/domain/transport"
)

// WebRTCConnectionManager WebRTC data channel connection yönetimi
type WebRTCConnectionManager struct {
	deviceID   string
	deviceName string
	iceAgent   ICEAgent

	// Connections
	connections map[string]*WebRTCConnection
	mu          sync.RWMutex

	// Callbacks
	onConnectionEstablished func(transport.Connection)
	onConnectionLost        func(string)
	chunkHandler            func(chunkHash string) ([]byte, error)
	onChunkReceived         func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error
	onTransferCancel        func(peerID, fileID string)
	onFileDelete            func(peerID, fileID string)

	// State
	started bool
}

// NewWebRTCConnectionManager yeni WebRTC connection manager oluşturur
func NewWebRTCConnectionManager(deviceID, deviceName string, iceAgent ICEAgent) *WebRTCConnectionManager {
	return &WebRTCConnectionManager{
		deviceID:    deviceID,
		deviceName:  deviceName,
		iceAgent:    iceAgent,
		connections: make(map[string]*WebRTCConnection),
		started:     false,
	}
}

// Connect peer'a WebRTC bağlantısı kurar
func (m *WebRTCConnectionManager) Connect(ctx context.Context, peer *transport.DiscoveredPeer) (transport.Connection, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	// Zaten bağlı mı kontrol et
	if conn, exists := m.connections[peer.DeviceID]; exists && conn.IsConnected() {
		return conn, nil
	}

	log.Printf("🔌 WebRTC bağlantısı başlatılıyor: %s", peer.DeviceID[:8])

	// Local ICE candidate'ları al
	localCandidates, err := m.iceAgent.GetLocalCandidates()
	if err != nil {
		return nil, fmt.Errorf("local candidate'lar alınamadı: %w", err)
	}

	log.Printf("📡 %d local candidate bulundu", len(localCandidates))

	// Remote candidate'ları peer'dan al (metadata'dan)
	// NOT: Gerçek implementasyonda remote candidate'lar SDP exchange ile alınacak
	// Şimdilik placeholder

	// ICE connection başlat
	// NOT: Gerçek WebRTC implementasyonunda WebRTC peer connection kullanılacak
	iceConn, err := m.iceAgent.StartConnection(ctx, []ICECandidate{})
	if err != nil {
		return nil, fmt.Errorf("ICE connection başlatılamadı: %w", err)
	}

	// WebRTC connection oluştur (şimdilik ICE connection ile)
	webrtcConn := NewWebRTCConnection(peer.DeviceID, peer.DeviceName, iceConn)

	// Chunk handler'ı bağla
	if m.chunkHandler != nil {
		webrtcConn.SetChunkHandler(m.chunkHandler)
	}

	// Connection'ı map'e ekle
	m.connections[peer.DeviceID] = webrtcConn

	log.Printf("✅ WebRTC bağlantısı kuruldu: %s", peer.DeviceID[:8])

	// Callback çağır
	if m.onConnectionEstablished != nil {
		m.onConnectionEstablished(webrtcConn)
	}

	return webrtcConn, nil
}

// Disconnect peer bağlantısını keser
func (m *WebRTCConnectionManager) Disconnect(peerID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	conn, exists := m.connections[peerID]
	if !exists {
		return fmt.Errorf("bağlantı bulunamadı: %s", peerID)
	}

	if err := conn.Close(); err != nil {
		return fmt.Errorf("bağlantı kapatılamadı: %w", err)
	}

	delete(m.connections, peerID)

	log.Printf("🔌 WebRTC bağlantısı kesildi: %s", peerID[:8])

	// Callback çağır
	if m.onConnectionLost != nil {
		m.onConnectionLost(peerID)
	}

	return nil
}

// GetConnection peer bağlantısını döner
func (m *WebRTCConnectionManager) GetConnection(peerID string) (transport.Connection, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	conn, exists := m.connections[peerID]
	if !exists {
		return nil, false
	}

	return conn, true
}

// GetAllConnections tüm bağlantıları döner
func (m *WebRTCConnectionManager) GetAllConnections() []transport.Connection {
	m.mu.RLock()
	defer m.mu.RUnlock()

	result := make([]transport.Connection, 0, len(m.connections))
	for _, conn := range m.connections {
		result = append(result, conn)
	}

	return result
}

// Close tüm bağlantıları kapatır
func (m *WebRTCConnectionManager) Close() error {
	m.mu.Lock()
	defer m.mu.Unlock()

	for peerID, conn := range m.connections {
		if err := conn.Close(); err != nil {
			log.Printf("⚠️ Bağlantı kapatılamadı (%s): %v", peerID[:8], err)
		}
	}

	m.connections = make(map[string]*WebRTCConnection)
	m.started = false

	return nil
}

// SetOnConnectionEstablished callback'i ayarlar
func (m *WebRTCConnectionManager) SetOnConnectionEstablished(callback func(transport.Connection)) {
	m.onConnectionEstablished = callback
}

// SetOnConnectionLost callback'i ayarlar
func (m *WebRTCConnectionManager) SetOnConnectionLost(callback func(string)) {
	m.onConnectionLost = callback
}

// SetChunkHandler chunk handler'ı ayarlar
func (m *WebRTCConnectionManager) SetChunkHandler(handler func(chunkHash string) ([]byte, error)) {
	m.chunkHandler = handler

	// Mevcut connection'lara da bağla
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, conn := range m.connections {
		conn.SetChunkHandler(handler)
	}
}

// SetOnChunkReceived chunk received callback'ini ayarlar
// NOT: Gerçek WebRTC data channel implementasyonunda kullanılacak
func (m *WebRTCConnectionManager) SetOnChunkReceived(callback func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error) {
	m.onChunkReceived = callback
}

// SetOnTransferCancel transfer cancel callback'ini ayarlar
// NOT: Gerçek WebRTC data channel implementasyonunda kullanılacak
func (m *WebRTCConnectionManager) SetOnTransferCancel(callback func(peerID, fileID string)) {
	m.onTransferCancel = callback
}

// SetOnFileDelete dosya silme callback'ini ayarlar
// NOT: Gerçek WebRTC data channel implementasyonunda kullanılacak
func (m *WebRTCConnectionManager) SetOnFileDelete(callback func(peerID, fileID string)) {
	m.onFileDelete = callback
}

// WebRTCConnection WebRTC data channel connection implementasyonu
// NOT: Gerçek WebRTC data channel implementasyonu yakında eklenecek
// Şimdilik placeholder - ICE connection ile çalışıyor
type WebRTCConnection struct {
	peerID      string
	peerName    string
	iceConn     *ICEConnection
	connected   bool
	mu          sync.RWMutex
	chunkHandler func(chunkHash string) ([]byte, error)
	connectedAt time.Time
}

// NewWebRTCConnection yeni WebRTC connection oluşturur
// NOT: Gerçek WebRTC peer connection entegrasyonu yakında eklenecek
func NewWebRTCConnection(peerID, peerName string, iceConn *ICEConnection) *WebRTCConnection {
	return &WebRTCConnection{
		peerID:      peerID,
		peerName:    peerName,
		iceConn:     iceConn,
		connected:   iceConn != nil && iceConn.Connected,
		connectedAt: time.Now(),
	}
}

// SendChunk chunk gönderir (pull-based için)
func (c *WebRTCConnection) SendChunk(ctx context.Context, chunkHash string, data []byte) error {
	return c.SendChunkWithFileInfo(ctx, chunkHash, data, "", 0, 0, "", "", pb.SyncMode_SYNC_MODE_UNSPECIFIED, pb.SyncMode_SYNC_MODE_UNSPECIFIED)
}

// SendChunkWithFileInfo chunk gönderir (push-based sync için file bilgisiyle)
// NOT: Gerçek WebRTC data channel implementasyonu yakında eklenecek
// Şimdilik placeholder - interface'i karşılamak için
func (c *WebRTCConnection) SendChunkWithFileInfo(ctx context.Context, chunkHash string, data []byte, fileID string, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if !c.connected {
		return fmt.Errorf("bağlantı kurulu değil")
	}

	// TODO: WebRTC data channel üzerinden data gönder
	log.Printf("📤 Chunk gönderiliyor (WebRTC): %s, file=%s, chunk=%d/%d (%d bytes)", 
		chunkHash[:8], fileID[:8], chunkIndex+1, totalChunks, len(data))

	// Placeholder - gerçek implementasyonda WebRTC data channel kullanılacak
	return fmt.Errorf("WebRTC data channel implementasyonu yakında eklenecek")
}

// RequestChunk chunk talep eder
func (c *WebRTCConnection) RequestChunk(ctx context.Context, chunkHash string) ([]byte, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if !c.connected {
		return nil, fmt.Errorf("bağlantı kurulu değil")
	}

	// TODO: WebRTC data channel üzerinden chunk talep et
	log.Printf("📥 Chunk talep ediliyor (WebRTC): %s", chunkHash[:8])

	// Placeholder - gerçek implementasyonda WebRTC data channel kullanılacak
	return nil, fmt.Errorf("WebRTC data channel implementasyonu yakında eklenecek")
}

// SendFileDelete dosya silme bildirimini gönderir (peer-to-peer)
// NOT: Gerçek WebRTC data channel implementasyonu yakında eklenecek
func (c *WebRTCConnection) SendFileDelete(ctx context.Context, fileID string) error {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if !c.connected {
		return fmt.Errorf("bağlantı kurulu değil")
	}

	// TODO: WebRTC data channel üzerinden file delete bildirimi gönder
	log.Printf("🗑️ Dosya silme bildirimi gönderiliyor (WebRTC): %s", fileID[:8])

	// Placeholder - gerçek implementasyonda WebRTC data channel kullanılacak
	return fmt.Errorf("WebRTC data channel implementasyonu yakında eklenecek")
}

// SendMetadata metadata gönderir
func (c *WebRTCConnection) SendMetadata(ctx context.Context, metadata *transport.FileMetadata) error {
	// TODO: Implement
	return fmt.Errorf("not implemented")
}

// RequestMetadata metadata talep eder
func (c *WebRTCConnection) RequestMetadata(ctx context.Context, fileID string) (*transport.FileMetadata, error) {
	// TODO: Implement
	return nil, fmt.Errorf("not implemented")
}

// Ping ping gönderir
func (c *WebRTCConnection) Ping(ctx context.Context) (time.Duration, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if !c.connected {
		return 0, fmt.Errorf("bağlantı kurulu değil")
	}

	// TODO: WebRTC data channel üzerinden ping gönder ve latency ölç
	log.Printf("🏓 Ping gönderiliyor (WebRTC): %s", c.peerID[:8])

	// Placeholder - gerçek implementasyonda WebRTC data channel kullanılacak
	return 0, fmt.Errorf("WebRTC ping implementasyonu yakında eklenecek")
}

// Close bağlantıyı kapatır
func (c *WebRTCConnection) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	if !c.connected {
		return nil
	}

	c.connected = false

	if c.iceConn != nil && c.iceConn.Conn != nil {
		// ICE connection kapat
		// TODO: ICE connection close
	}

	log.Printf("🔌 WebRTC bağlantısı kapatıldı: %s", c.peerID[:8])
	return nil
}

// GetPeerID peer ID döner
func (c *WebRTCConnection) GetPeerID() string {
	return c.peerID
}

// GetAddress adres döner
func (c *WebRTCConnection) GetAddress() string {
	if c.iceConn != nil && c.iceConn.RemoteAddress != nil {
		return c.iceConn.RemoteAddress.String()
	}
	return "webrtc://" + c.peerID[:8]
}

// GetLatency latency döner
func (c *WebRTCConnection) GetLatency() time.Duration {
	// TODO: Gerçek latency ölçümü
	return 0
}

// IsConnected bağlantı durumunu döner
func (c *WebRTCConnection) IsConnected() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.connected
}

// GetTransportType transport tipini döner
func (c *WebRTCConnection) GetTransportType() transport.TransportType {
	return transport.TransportTypeWAN
}

// GetConnectionTime bağlantı zamanını döner
func (c *WebRTCConnection) GetConnectionTime() time.Time {
	return c.connectedAt
}

// SetChunkHandler chunk handler'ı ayarlar
func (c *WebRTCConnection) SetChunkHandler(handler func(chunkHash string) ([]byte, error)) {
	c.chunkHandler = handler
}

