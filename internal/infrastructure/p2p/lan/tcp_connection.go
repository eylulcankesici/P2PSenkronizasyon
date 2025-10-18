package lan

import (
	"context"
	"fmt"
	"io"
	"log"
	"net"
	"sync"
	"time"

	"github.com/aether/sync/internal/domain/transport"
)

// TCPConnection TCP tabanlı peer bağlantısı
// Single Responsibility: Tek bir TCP bağlantısını yönetir
type TCPConnection struct {
	peerID        string
	address       string
	conn          net.Conn
	protocol      *Protocol
	transportType transport.TransportType
	
	connectedAt time.Time
	latency     time.Duration
	
	sendMu sync.Mutex
	recvMu sync.Mutex
	
	ctx    context.Context
	cancel context.CancelFunc
}

// NewTCPConnection yeni TCP connection oluşturur
func NewTCPConnection(peerID, address string, conn net.Conn) *TCPConnection {
	ctx, cancel := context.WithCancel(context.Background())
	
	return &TCPConnection{
		peerID:        peerID,
		address:       address,
		conn:          conn,
		protocol:      NewProtocol(),
		transportType: transport.TransportTypeLAN,
		connectedAt:   time.Now(),
		ctx:           ctx,
		cancel:        cancel,
	}
}

// SendChunk chunk gönderir
func (c *TCPConnection) SendChunk(ctx context.Context, chunkHash string, data []byte) error {
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	// Chunk response mesajı encode et
	frame, err := c.protocol.EncodeChunkResponse(chunkHash, data)
	if err != nil {
		return fmt.Errorf("chunk encode hatası: %w", err)
	}
	
	// Frame boyutunu gönder (4 bytes)
	frameLen := uint32(len(frame))
	if err := c.writeUint32(frameLen); err != nil {
		return fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// Frame'i gönder
	if _, err := c.conn.Write(frame); err != nil {
		return fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	return nil
}

// RequestChunk chunk talep eder
func (c *TCPConnection) RequestChunk(ctx context.Context, chunkHash string) ([]byte, error) {
	c.sendMu.Lock()
	
	// Chunk request mesajı encode et
	frame, err := c.protocol.EncodeChunkRequest(chunkHash)
	if err != nil {
		c.sendMu.Unlock()
		return nil, fmt.Errorf("request encode hatası: %w", err)
	}
	
	// Frame boyutunu gönder
	frameLen := uint32(len(frame))
	if err := c.writeUint32(frameLen); err != nil {
		c.sendMu.Unlock()
		return nil, fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// Frame'i gönder
	if _, err := c.conn.Write(frame); err != nil {
		c.sendMu.Unlock()
		return nil, fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	c.sendMu.Unlock()
	
	// Response bekle
	c.recvMu.Lock()
	defer c.recvMu.Unlock()
	
	// Frame boyutunu oku
	respLen, err := c.readUint32()
	if err != nil {
		return nil, fmt.Errorf("response length okunamadı: %w", err)
	}
	
	// Frame'i oku
	respFrame := make([]byte, respLen)
	if _, err := io.ReadFull(c.conn, respFrame); err != nil {
		return nil, fmt.Errorf("response frame okunamadı: %w", err)
	}
	
	// Decode et
	_, chunkData, err := c.protocol.DecodeChunkResponse(respFrame)
	if err != nil {
		return nil, fmt.Errorf("response decode hatası: %w", err)
	}
	
	return chunkData, nil
}

// SendMetadata metadata gönderir
func (c *TCPConnection) SendMetadata(ctx context.Context, metadata *transport.FileMetadata) error {
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	// Metadata mesajı encode et
	frame, err := c.protocol.EncodeMetadata(metadata)
	if err != nil {
		return fmt.Errorf("metadata encode hatası: %w", err)
	}
	
	// Frame boyutunu gönder
	frameLen := uint32(len(frame))
	if err := c.writeUint32(frameLen); err != nil {
		return fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// Frame'i gönder
	if _, err := c.conn.Write(frame); err != nil {
		return fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	return nil
}

// RequestMetadata metadata talep eder
func (c *TCPConnection) RequestMetadata(ctx context.Context, fileID string) (*transport.FileMetadata, error) {
	// Placeholder implementation
	return nil, fmt.Errorf("not implemented")
}

// Ping ping gönderir ve latency ölçer
func (c *TCPConnection) Ping(ctx context.Context) (time.Duration, error) {
	start := time.Now()
	
	c.sendMu.Lock()
	
	// Ping mesajı encode et
	frame, err := c.protocol.EncodePing(c.peerID)
	if err != nil {
		c.sendMu.Unlock()
		return 0, fmt.Errorf("ping encode hatası: %w", err)
	}
	
	// Frame boyutunu gönder
	frameLen := uint32(len(frame))
	if err := c.writeUint32(frameLen); err != nil {
		c.sendMu.Unlock()
		return 0, fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// Frame'i gönder
	if _, err := c.conn.Write(frame); err != nil {
		c.sendMu.Unlock()
		return 0, fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	c.sendMu.Unlock()
	
	// Pong bekle
	c.recvMu.Lock()
	defer c.recvMu.Unlock()
	
	// Frame boyutunu oku
	respLen, err := c.readUint32()
	if err != nil {
		return 0, fmt.Errorf("pong length okunamadı: %w", err)
	}
	
	// Frame'i oku
	respFrame := make([]byte, respLen)
	if _, err := io.ReadFull(c.conn, respFrame); err != nil {
		return 0, fmt.Errorf("pong frame okunamadı: %w", err)
	}
	
	latency := time.Since(start)
	c.latency = latency
	
	return latency, nil
}

// Close bağlantıyı kapatır
func (c *TCPConnection) Close() error {
	c.cancel()
	if c.conn != nil {
		return c.conn.Close()
	}
	return nil
}

// GetPeerID peer ID'sini döner
func (c *TCPConnection) GetPeerID() string {
	return c.peerID
}

// GetAddress adresi döner
func (c *TCPConnection) GetAddress() string {
	return c.address
}

// GetLatency son ölçülen latency'yi döner
func (c *TCPConnection) GetLatency() time.Duration {
	return c.latency
}

// IsConnected bağlı mı kontrol eder
func (c *TCPConnection) IsConnected() bool {
	// Basit kontrol: connection nil değilse bağlı kabul et
	return c.conn != nil
}

// GetTransportType transport türünü döner
func (c *TCPConnection) GetTransportType() transport.TransportType {
	return c.transportType
}

// GetConnectionTime bağlantı zamanını döner
func (c *TCPConnection) GetConnectionTime() time.Time {
	return c.connectedAt
}

// Helper methods

// writeUint32 uint32 değeri network byte order'da yazar
func (c *TCPConnection) writeUint32(val uint32) error {
	buf := make([]byte, 4)
	buf[0] = byte(val >> 24)
	buf[1] = byte(val >> 16)
	buf[2] = byte(val >> 8)
	buf[3] = byte(val)
	
	_, err := c.conn.Write(buf)
	return err
}

// readUint32 uint32 değeri network byte order'dan okur
func (c *TCPConnection) readUint32() (uint32, error) {
	buf := make([]byte, 4)
	if _, err := io.ReadFull(c.conn, buf); err != nil {
		return 0, err
	}
	
	val := uint32(buf[0])<<24 | uint32(buf[1])<<16 | uint32(buf[2])<<8 | uint32(buf[3])
	return val, nil
}

// TCPConnectionManager TCP bağlantı yöneticisi
type TCPConnectionManager struct {
	listener   net.Listener
	port       int
	deviceID   string
	deviceName string
	
	connections map[string]*TCPConnection
	mu          sync.RWMutex
	
	ctx    context.Context
	cancel context.CancelFunc
	
	// Callbacks
	onConnectionEstablished func(*TCPConnection)
}

// NewTCPConnectionManager yeni TCP connection manager oluşturur
func NewTCPConnectionManager(port int, deviceID, deviceName string) *TCPConnectionManager {
	ctx, cancel := context.WithCancel(context.Background())
	
	return &TCPConnectionManager{
		port:        port,
		deviceID:    deviceID,
		deviceName:  deviceName,
		connections: make(map[string]*TCPConnection),
		ctx:         ctx,
		cancel:      cancel,
	}
}

// Listen TCP listener başlatır
func (m *TCPConnectionManager) Listen(ctx context.Context, port int) error {
	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		return fmt.Errorf("TCP listen hatası: %w", err)
	}
	
	m.listener = listener
	m.port = port
	
	log.Printf("✅ TCP listener başlatıldı: port %d", port)
	
	// Accept loop
	go m.acceptLoop()
	
	return nil
}

// Connect peer'a TCP bağlantısı kurar
func (m *TCPConnectionManager) Connect(ctx context.Context, address string, peerID string) (transport.Connection, error) {
	// TCP dial
	conn, err := net.DialTimeout("tcp", address, 5*time.Second)
	if err != nil {
		return nil, fmt.Errorf("TCP connect hatası: %w", err)
	}
	
	// Client handshake yap
	peerHandshake, err := PerformClientHandshake(conn, m.deviceID, m.deviceName)
	if err != nil {
		conn.Close()
		return nil, fmt.Errorf("handshake başarısız: %w", err)
	}
	
	// Handshake'den gelen peer ID ile parametredeki eşleşiyor mu?
	if peerHandshake.DeviceID != peerID {
		conn.Close()
		return nil, fmt.Errorf("peer ID uyuşmazlığı: expected=%s, got=%s", peerID, peerHandshake.DeviceID)
	}
	
	// TCPConnection oluştur
	tcpConn := NewTCPConnection(peerID, address, conn)
	
	// Connection pool'a ekle
	m.mu.Lock()
	m.connections[peerID] = tcpConn
	m.mu.Unlock()
	
	log.Printf("🔗 TCP bağlantı kuruldu: %s (%s) - %s", peerHandshake.DeviceName, peerID[:8], address)
	
	return tcpConn, nil
}

// Accept incoming connection kabul eder
func (m *TCPConnectionManager) Accept(ctx context.Context) (transport.Connection, error) {
	// Bu method acceptLoop tarafından kullanılıyor
	return nil, fmt.Errorf("not implemented")
}

// acceptLoop incoming connections'ı kabul eder
func (m *TCPConnectionManager) acceptLoop() {
	for {
		select {
		case <-m.ctx.Done():
			return
		default:
			conn, err := m.listener.Accept()
			if err != nil {
				log.Printf("⚠️ Accept hatası: %v", err)
				continue
			}
			
			// Handle connection
			go m.handleIncomingConnection(conn)
		}
	}
}

// handleIncomingConnection incoming connection'ı işler
func (m *TCPConnectionManager) handleIncomingConnection(conn net.Conn) {
	log.Printf("📥 Incoming connection: %s", conn.RemoteAddr().String())
	
	// Server handshake yap
	peerHandshake, err := PerformServerHandshake(conn, m.deviceID, m.deviceName)
	if err != nil {
		log.Printf("⚠️ Handshake başarısız (%s): %v", conn.RemoteAddr(), err)
		conn.Close()
		return
	}
	
	// Handshake'i doğrula
	if err := ValidateHandshake(peerHandshake); err != nil {
		log.Printf("⚠️ Handshake validation başarısız (%s): %v", conn.RemoteAddr(), err)
		conn.Close()
		return
	}
	
	log.Printf("✅ Handshake başarılı: %s (%s) @ %s", 
		peerHandshake.DeviceName, peerHandshake.DeviceID[:8], conn.RemoteAddr())
	
	// TCPConnection oluştur
	tcpConn := NewTCPConnection(peerHandshake.DeviceID, conn.RemoteAddr().String(), conn)
	
	// Connection pool'a ekle
	m.mu.Lock()
	m.connections[peerHandshake.DeviceID] = tcpConn
	m.mu.Unlock()
	
	// Callback çağır
	if m.onConnectionEstablished != nil {
		m.onConnectionEstablished(tcpConn)
	}
	
	log.Printf("🔗 Peer bağlantı kabul edildi: %s (%s)", 
		peerHandshake.DeviceName, peerHandshake.DeviceID[:8])
	
	// Connection'ı aktif tut (chunk request/response için)
	// Bu goroutine connection kapatılana kadar yaşar
	<-tcpConn.ctx.Done()
	log.Printf("🔌 Peer bağlantısı kapandı: %s", peerHandshake.DeviceID[:8])
}

// Close manager'ı kapat
func (m *TCPConnectionManager) Close() error {
	m.cancel()
	
	if m.listener != nil {
		m.listener.Close()
	}
	
	// Tüm bağlantıları kapat
	m.mu.Lock()
	defer m.mu.Unlock()
	
	for _, conn := range m.connections {
		conn.Close()
	}
	
	return nil
}

// GetConnection peer ID'ye göre bağlantı döner
func (m *TCPConnectionManager) GetConnection(peerID string) (transport.Connection, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	
	conn, exists := m.connections[peerID]
	return conn, exists
}

// GetAllConnections tüm bağlantıları döner
func (m *TCPConnectionManager) GetAllConnections() []transport.Connection {
	m.mu.RLock()
	defer m.mu.RUnlock()
	
	connections := make([]transport.Connection, 0, len(m.connections))
	for _, conn := range m.connections {
		connections = append(connections, conn)
	}
	
	return connections
}

