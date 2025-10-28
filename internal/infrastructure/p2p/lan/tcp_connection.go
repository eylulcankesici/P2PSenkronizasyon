package lan

import (
	"context"
	"encoding/json"
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
	
	// Chunk handler
	chunkHandler func(chunkHash string) ([]byte, error)
	
	// Manager referansı (connection request işlemek için)
	manager *TCPConnectionManager
}

// NewTCPConnection yeni TCP connection oluşturur
func NewTCPConnection(peerID, address string, conn net.Conn) *TCPConnection {
	return NewTCPConnectionWithManager(peerID, address, conn, nil)
}

// NewTCPConnectionWithManager manager ile TCP connection oluşturur
func NewTCPConnectionWithManager(peerID, address string, conn net.Conn, manager *TCPConnectionManager) *TCPConnection {
	ctx, cancel := context.WithCancel(context.Background())
	
	tcpConn := &TCPConnection{
		peerID:        peerID,
		address:       address,
		conn:          conn,
		protocol:      NewProtocol(),
		transportType: transport.TransportTypeLAN,
		connectedAt:   time.Now(),
		ctx:           ctx,
		cancel:        cancel,
		manager:       manager,
	}
	
	// Start message loop
	go tcpConn.messageLoop()
	
	return tcpConn
}

// SetChunkHandler chunk handler'ı set eder
func (c *TCPConnection) SetChunkHandler(handler func(chunkHash string) ([]byte, error)) {
	c.chunkHandler = handler
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

// messageLoop gelen mesajları işler
func (c *TCPConnection) messageLoop() {
	for {
		select {
		case <-c.ctx.Done():
			return
		default:
			// Frame boyutunu oku
			frameLen, err := c.readUint32()
			if err != nil {
				if c.ctx.Err() == nil {
					log.Printf("⚠️ Frame length okuma hatası: %v", err)
				}
				return
			}
			
			// Frame'i oku
			frame := make([]byte, frameLen)
			if _, err := io.ReadFull(c.conn, frame); err != nil {
				if c.ctx.Err() == nil {
					log.Printf("⚠️ Frame okuma hatası: %v", err)
				}
				return
			}
			
			// Decode et
			messageType, payload, err := c.protocol.DecodeFrame(frame)
			if err != nil {
				log.Printf("⚠️ Frame decode hatası: %v", err)
				continue
			}
			
			// Mesaj tipine göre işle
			if err := c.handleMessage(messageType, payload); err != nil {
				log.Printf("⚠️ Mesaj işleme hatası: %v", err)
			}
		}
	}
}

// handleMessage gelen mesajı işler
func (c *TCPConnection) handleMessage(messageType uint16, payload []byte) error {
	switch messageType {
	case MessageTypeChunkRequest:
		return c.handleChunkRequest(payload)
	case MessageTypePing:
		return c.handlePing(payload)
	case MessageTypeConnectionRequest:
		// Manager varsa onun handler'ını kullan
		if c.manager != nil {
			deviceID, deviceName, err := c.protocol.DecodeConnectionRequest(payload)
			if err != nil {
				return fmt.Errorf("connection request decode hatası: %w", err)
			}
			c.manager.handleConnectionRequestInManager(c, deviceID, deviceName)
			return nil
		}
		return c.handleConnectionRequest(payload)
	case MessageTypeConnectionAccept, MessageTypeConnectionReject:
		// Bu mesajlar client tarafında işlenecek
		return nil
	default:
		return fmt.Errorf("bilinmeyen mesaj tipi: 0x%04x", messageType)
	}
}

// handleChunkRequest chunk request'i işler
func (c *TCPConnection) handleChunkRequest(payload []byte) error {
	chunkHash, err := c.protocol.DecodeChunkRequest(payload)
	if err != nil {
		return fmt.Errorf("chunk request decode hatası: %w", err)
	}
	
	log.Printf("📥 Chunk request alındı: %s", chunkHash[:8])
	
	// Chunk handler yoksa hata döndür
	if c.chunkHandler == nil {
		log.Printf("⚠️ Chunk handler tanımlı değil")
		return fmt.Errorf("chunk handler tanımlı değil")
	}
	
	// Chunk'ı al
	chunkData, err := c.chunkHandler(chunkHash)
	if err != nil {
		log.Printf("⚠️ Chunk alınamadı: %v", err)
		// Hata durumunda boş chunk gönder
		chunkData = []byte{}
	}
	
	// Response gönder
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	response, err := c.protocol.EncodeChunkResponse(chunkHash, chunkData)
	if err != nil {
		return fmt.Errorf("chunk response encode hatası: %w", err)
	}
	
	// Frame boyutunu gönder
	if err := c.writeUint32(uint32(len(response))); err != nil {
		return fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// Frame'i gönder
	if _, err := c.conn.Write(response); err != nil {
		return fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	log.Printf("✅ Chunk response gönderildi: %s (%d bytes)", chunkHash[:8], len(chunkData))
	
	return nil
}

// handlePing ping request'i işler
func (c *TCPConnection) handlePing(payload []byte) error {
	_, err := c.protocol.DecodePing(payload)
	if err != nil {
		return fmt.Errorf("ping decode hatası: %w", err)
	}
	
	log.Printf("🏓 Ping alındı, pong gönderiliyor...")
	
	// Pong gönder
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	response, err := c.protocol.EncodePong(c.peerID, 0)
	if err != nil {
		return fmt.Errorf("pong encode hatası: %w", err)
	}
	
	// Frame boyutunu gönder
	if err := c.writeUint32(uint32(len(response))); err != nil {
		return fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// Frame'i gönder
	if _, err := c.conn.Write(response); err != nil {
		return fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	return nil
}

// handleConnectionRequest connection request'i işler (server-side)
// Bu fonksiyon artık manager üzerinden çağrılmalı
func (c *TCPConnection) handleConnectionRequest(payload []byte) error {
	// Bu metod artık kullanılmıyor, handleConnectionRequestInManager kullanılmalı
	return fmt.Errorf("deprecated: handleConnectionRequestInManager kullanın")
}

// handleConnectionRequestInManager connection request'i manager üzerinden işler
func (m *TCPConnectionManager) handleConnectionRequestInManager(tcpConn *TCPConnection, deviceID, deviceName string) {
	log.Printf("🔔 Bağlantı isteği alındı: %s (%s)", deviceName, deviceID[:8])
	
	// Pending connection oluştur
	pending := &PendingConnection{
		DeviceID:   deviceID,
		DeviceName: deviceName,
		Conn:       tcpConn,
		Timestamp:  time.Now(),
		ResponseCh: make(chan bool, 1),
	}
	
	// Pending listesine ekle
	m.mu.Lock()
	m.pendingConns[deviceID] = pending
	m.mu.Unlock()
	
	// Callback çağır (UI'a bildir)
	if m.onConnectionRequested != nil {
		m.onConnectionRequested(deviceID, deviceName)
	}
	
	// UI'dan yanıt bekle (30 saniye timeout)
	go func() {
		select {
		case accepted := <-pending.ResponseCh:
			m.mu.Lock()
			delete(m.pendingConns, deviceID)
			m.mu.Unlock()
			
			if accepted {
				// Accept gönder
				tcpConn.sendMu.Lock()
				response, err := tcpConn.protocol.EncodeConnectionAccept(m.deviceID)
				if err != nil {
					log.Printf("⚠️ Connection accept encode hatası: %v", err)
					tcpConn.sendMu.Unlock()
					return
				}
				
				// Frame boyutunu gönder
				if err := tcpConn.writeUint32(uint32(len(response))); err != nil {
					log.Printf("⚠️ Frame length yazılamadı: %v", err)
					tcpConn.sendMu.Unlock()
					return
				}
				
				// Frame'i gönder
				if _, err := tcpConn.conn.Write(response); err != nil {
					log.Printf("⚠️ Frame yazılamadı: %v", err)
					tcpConn.sendMu.Unlock()
					return
				}
				tcpConn.sendMu.Unlock()
				
				// Connection pool'a ekle
				m.mu.Lock()
				m.connections[deviceID] = tcpConn
				m.mu.Unlock()
				
				// Chunk handler'ı bağla (varsa)
				if m.chunkHandlerCallback != nil {
					tcpConn.SetChunkHandler(m.chunkHandlerCallback)
				}
				
				// Callback çağır
				if m.onConnectionEstablished != nil {
					m.onConnectionEstablished(tcpConn)
				}
				
				log.Printf("✅ Bağlantı kabul edildi: %s", deviceName)
			} else {
				// Reject gönder
				tcpConn.sendMu.Lock()
				response, err := tcpConn.protocol.EncodeConnectionReject("Bağlantı reddedildi")
				if err != nil {
					log.Printf("⚠️ Connection reject encode hatası: %v", err)
					tcpConn.sendMu.Unlock()
					tcpConn.Close()
					return
				}
				
				// Frame boyutunu gönder
				if err := tcpConn.writeUint32(uint32(len(response))); err != nil {
					log.Printf("⚠️ Frame length yazılamadı: %v", err)
					tcpConn.sendMu.Unlock()
					tcpConn.Close()
					return
				}
				
				// Frame'i gönder
				if _, err := tcpConn.conn.Write(response); err != nil {
					log.Printf("⚠️ Frame yazılamadı: %v", err)
					tcpConn.sendMu.Unlock()
					tcpConn.Close()
					return
				}
				tcpConn.sendMu.Unlock()
				
				tcpConn.Close()
				log.Printf("❌ Bağlantı reddedildi: %s", deviceName)
			}
		case <-time.After(30 * time.Second):
			// Timeout - otomatik reddet
			m.mu.Lock()
			delete(m.pendingConns, deviceID)
			m.mu.Unlock()
			
			tcpConn.sendMu.Lock()
			response, _ := tcpConn.protocol.EncodeConnectionReject("İstek zaman aşımına uğradı")
			tcpConn.writeUint32(uint32(len(response)))
			tcpConn.conn.Write(response)
			tcpConn.sendMu.Unlock()
			
			tcpConn.Close()
			log.Printf("⏱️ Bağlantı isteği zaman aşımına uğradı: %s", deviceName)
		}
	}()
}

// SendConnectionRequest connection request gönderir (client-side)
func (c *TCPConnection) SendConnectionRequest(deviceID, deviceName string) error {
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	request, err := c.protocol.EncodeConnectionRequest(deviceID, deviceName)
	if err != nil {
		return fmt.Errorf("connection request encode hatası: %w", err)
	}
	
	// Frame boyutunu gönder
	if err := c.writeUint32(uint32(len(request))); err != nil {
		return fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// Frame'i gönder
	if _, err := c.conn.Write(request); err != nil {
		return fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	log.Printf("📤 Bağlantı isteği gönderildi: %s", deviceName)
	return nil
}

// WaitForConnectionResponse connection response bekler (client-side)
func (c *TCPConnection) WaitForConnectionResponse(timeout time.Duration) error {
	// Frame boyutunu oku
	frameLen, err := c.readUint32()
	if err != nil {
		return fmt.Errorf("response length okunamadı: %w", err)
	}
	
	// Frame'i oku
	frame := make([]byte, frameLen)
	if _, err := io.ReadFull(c.conn, frame); err != nil {
		return fmt.Errorf("response frame okunamadı: %w", err)
	}
	
	// Decode et
	messageType, payload, err := c.protocol.DecodeFrame(frame)
	if err != nil {
		return fmt.Errorf("response decode hatası: %w", err)
	}
	
	// Accept mesajı mı?
	if messageType == MessageTypeConnectionAccept {
		// Payload'u decode et
		var resp struct {
			Accepted bool   `json:"accepted"`
			Message  string `json:"message"`
			DeviceID string `json:"device_id"`
		}
		if err := json.Unmarshal(payload, &resp); err != nil {
			return fmt.Errorf("connection accept decode hatası: %w", err)
		}
		if !resp.Accepted {
			return fmt.Errorf("bağlantı reddedildi: %s", resp.Message)
		}
		log.Printf("✅ Bağlantı kabul edildi")
		return nil
	}
	
	// Reject mesajı mı?
	if messageType == MessageTypeConnectionReject {
		// Payload'u decode et
		var resp struct {
			Accepted bool   `json:"accepted"`
			Message  string `json:"message"`
			DeviceID string `json:"device_id"`
		}
		if err := json.Unmarshal(payload, &resp); err != nil {
			return fmt.Errorf("connection reject decode hatası: %w", err)
		}
		return fmt.Errorf("bağlantı reddedildi: %s", resp.Message)
	}
	
	return fmt.Errorf("beklenmeyen mesaj tipi: 0x%04x", messageType)
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

// PendingConnection bekleyen bağlantı isteği
// Bu struct export edilmiştir, external code tarafından kullanılabilir
type PendingConnection struct {
	DeviceID   string
	DeviceName string
	Conn       *TCPConnection
	Timestamp  time.Time
	ResponseCh chan bool // true = accept, false = reject
}

// TCPConnectionManager TCP bağlantı yöneticisi
type TCPConnectionManager struct {
	listener   net.Listener
	port       int
	deviceID   string
	deviceName string
	
	connections     map[string]*TCPConnection
	pendingConns    map[string]*PendingConnection
	mu              sync.RWMutex
	
	ctx    context.Context
	cancel context.CancelFunc
	
	// Callbacks
	onConnectionEstablished func(transport.Connection)
	onConnectionRequested   func(deviceID, deviceName string)
	chunkHandlerCallback    func(chunkHash string) ([]byte, error)
}

// NewTCPConnectionManager yeni TCP connection manager oluşturur
func NewTCPConnectionManager(port int, deviceID, deviceName string) *TCPConnectionManager {
	ctx, cancel := context.WithCancel(context.Background())
	
	return &TCPConnectionManager{
		port:         port,
		deviceID:     deviceID,
		deviceName:   deviceName,
		connections:  make(map[string]*TCPConnection),
		pendingConns: make(map[string]*PendingConnection),
		ctx:          ctx,
		cancel:       cancel,
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
func (m *TCPConnectionManager) Connect(ctx context.Context, address string, peerID string, deviceName string) (transport.Connection, error) {
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
	
	// TCPConnection oluştur (messageLoop başlamadan önce)
	tcpConn := NewTCPConnection(peerID, address, conn)
	
	// Connection request gönder
	if err := tcpConn.SendConnectionRequest(m.deviceID, m.deviceName); err != nil {
		tcpConn.Close()
		return nil, fmt.Errorf("connection request gönderilemedi: %w", err)
	}
	
	// Connection response bekle (5 saniye timeout)
	if err := tcpConn.WaitForConnectionResponse(5 * time.Second); err != nil {
		tcpConn.Close()
		return nil, fmt.Errorf("connection response alınamadı: %w", err)
	}
	
	// Connection pool'a ekle
	m.mu.Lock()
	m.connections[peerID] = tcpConn
	m.mu.Unlock()
	
	log.Printf("🔗 TCP bağlantı kuruldu ve kabul edildi: %s (%s) - %s", peerHandshake.DeviceName, peerID[:8], address)
	
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
	
	// TCPConnection oluştur (manager ile)
	tcpConn := NewTCPConnectionWithManager(peerHandshake.DeviceID, conn.RemoteAddr().String(), conn, m)
	
	// Connection request bekle (messageLoop içinde işlenecek)
	// Connection request geldiğinde handleConnectionRequestInManager çağrılacak
	// Bu connection'ı özel bir şekilde işlemek için messageLoop'a manager referansı verilmeli
	// Şimdilik basit bir yaklaşım: connection request'i manuel olarak bekle
	
	// Connection'ı geçici olarak sakla (handleConnectionRequestInManager'da işlenecek)
	// MessageLoop connection request'i aldığında manager'a bildirecek
	
	// Connection'ı aktif tut - connection request geldiğinde handleConnectionRequestInManager çağrılacak
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

// setOnConnectionEstablished connection established callback'ini set eder
func (m *TCPConnectionManager) setOnConnectionEstablished(callback func(transport.Connection)) {
	m.onConnectionEstablished = callback
}

// SetChunkHandler chunk handler callback'ini set eder
func (m *TCPConnectionManager) SetChunkHandler(handler func(chunkHash string) ([]byte, error)) {
	m.chunkHandlerCallback = handler
	
	// Mevcut connection'lara handler'ı bağla
	m.mu.RLock()
	for _, conn := range m.connections {
		conn.SetChunkHandler(handler)
	}
	m.mu.RUnlock()
}

// SetOnConnectionRequested connection requested callback'ini set eder
func (m *TCPConnectionManager) SetOnConnectionRequested(callback func(deviceID, deviceName string)) {
	m.onConnectionRequested = callback
}

// GetPendingConnections bekleyen bağlantı isteklerini döner
func (m *TCPConnectionManager) GetPendingConnections() []*PendingConnection {
	m.mu.RLock()
	defer m.mu.RUnlock()
	
	pending := make([]*PendingConnection, 0, len(m.pendingConns))
	for _, p := range m.pendingConns {
		pending = append(pending, p)
	}
	return pending
}

// AcceptConnection bağlantı isteğini onaylar
func (m *TCPConnectionManager) AcceptConnection(deviceID string) error {
	m.mu.RLock()
	pending, exists := m.pendingConns[deviceID]
	m.mu.RUnlock()
	
	if !exists {
		return fmt.Errorf("bekleyen bağlantı isteği bulunamadı: %s", deviceID)
	}
	
	// Response channel'a true gönder
	select {
	case pending.ResponseCh <- true:
		return nil
	default:
		return fmt.Errorf("bağlantı isteği zaten işlenmiş")
	}
}

// RejectConnection bağlantı isteğini reddeder
func (m *TCPConnectionManager) RejectConnection(deviceID string) error {
	m.mu.RLock()
	pending, exists := m.pendingConns[deviceID]
	m.mu.RUnlock()
	
	if !exists {
		return fmt.Errorf("bekleyen bağlantı isteği bulunamadı: %s", deviceID)
	}
	
	// Response channel'a false gönder
	select {
	case pending.ResponseCh <- false:
		return nil
	default:
		return fmt.Errorf("bağlantı isteği zaten işlenmiş")
	}
}

