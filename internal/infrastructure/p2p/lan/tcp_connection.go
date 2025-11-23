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

	"google.golang.org/protobuf/proto"

	pb "github.com/aether/sync/api/proto"
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
// manager nil ise messageLoop hemen başlatılır (server tarafında)
func NewTCPConnection(peerID, address string, conn net.Conn) *TCPConnection {
	return NewTCPConnectionWithManager(peerID, address, conn, nil)
}

// NewTCPConnectionWithManager manager ile TCP connection oluşturur
// autoStartMessageLoop true ise messageLoop otomatik başlatılır (server-side)
// autoStartMessageLoop false ise messageLoop başlatılmaz, manuel başlatılmalı (client-side)
func NewTCPConnectionWithManager(peerID, address string, conn net.Conn, manager *TCPConnectionManager) *TCPConnection {
	return NewTCPConnectionWithManagerAndAutoStart(peerID, address, conn, manager, manager != nil)
}

// NewTCPConnectionWithManagerAndAutoStart manager ile TCP connection oluşturur ve messageLoop başlatmayı kontrol eder
// autoStartMessageLoop true ise messageLoop otomatik başlatılır (server-side)
// autoStartMessageLoop false ise messageLoop başlatılmaz, manuel başlatılmalı (client-side)
func NewTCPConnectionWithManagerAndAutoStart(peerID, address string, conn net.Conn, manager *TCPConnectionManager, autoStartMessageLoop bool) *TCPConnection {
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
	
	// Server-side için otomatik başlat (manager var VE autoStartMessageLoop true)
	// Client-side için manuel başlatılacak (autoStartMessageLoop false)
	if autoStartMessageLoop && manager != nil {
		go func() {
			// Client'ın connection request göndermesi için daha fazla bekle
			time.Sleep(200 * time.Millisecond)
			log.Printf("🔄 Server-side messageLoop başlatılıyor (peer: %s)", tcpConn.peerID[:8])
			tcpConn.messageLoop()
		}()
	}
	
	return tcpConn
}

// startMessageLoop messageLoop'u başlatır (client-side)
func (c *TCPConnection) startMessageLoop() {
	go func() {
		time.Sleep(100 * time.Millisecond) // Handshake tamamlansın
		c.messageLoop()
	}()
}

// SetChunkHandler chunk handler'ı set eder
func (c *TCPConnection) SetChunkHandler(handler func(chunkHash string) ([]byte, error)) {
	c.chunkHandler = handler
}

// SendChunk chunk gönderir (pull-based için)
func (c *TCPConnection) SendChunk(ctx context.Context, chunkHash string, data []byte) error {
	return c.SendChunkWithFileInfo(ctx, chunkHash, data, "", 0, 0, "")
}

// SendChunkWithFileInfo chunk gönderir (push-based sync için file bilgisiyle)
func (c *TCPConnection) SendChunkWithFileInfo(ctx context.Context, chunkHash string, data []byte, fileID string, chunkIndex, totalChunks int, fileName string) error {
	// Context iptal kontrolü (göndermeden önce)
	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
	}
	
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	// Context iptal kontrolü (lock aldıktan sonra tekrar kontrol)
	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
	}
	
	// Chunk response mesajı encode et
	frame, err := c.protocol.EncodeChunkResponseWithFileInfo(chunkHash, data, fileID, chunkIndex, totalChunks, fileName)
	if err != nil {
		return fmt.Errorf("chunk encode hatası: %w", err)
	}
	
	// Context iptal kontrolü (frame göndermeden önce)
	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
	}
	
	// Frame boyutunu gönder (4 bytes)
	frameLen := uint32(len(frame))
	if err := c.writeUint32(frameLen); err != nil {
		// Context iptal edilmişse özel hata döndür
		if ctx.Err() != nil {
			return ctx.Err()
		}
		return fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	// ⚠️ FRAME LENGTH YAZILDIKTAN SONRA CONTEXT KONTROLÜ YAPMA!
	// Frame'i mutlaka tamamla, yoksa TCP stream bozulur (yarım frame kalır)
	
	// Frame'i gönder (context kontrolü YOK - frame tamamlanmalı!)
	if _, err := c.conn.Write(frame); err != nil {
		// Context iptal edilmişse özel hata döndür
		if ctx.Err() != nil {
			return ctx.Err()
		}
		return fmt.Errorf("frame yazılamadı: %w", err)
	}
	
	// ✅ Frame tamamlandı, şimdi context kontrolü güvenli
	select {
	case <-ctx.Done():
		return ctx.Err()
	default:
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

// SendTransferCancel transfer iptal bildirimi gönderir (alıcı taraf -> gönderen taraf)
func (c *TCPConnection) SendTransferCancel(ctx context.Context, fileID, reason string) error {
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	// Transfer cancel mesajı encode et
	frame, err := c.protocol.EncodeTransferCancel(fileID, reason)
	if err != nil {
		return fmt.Errorf("transfer cancel encode hatası: %w", err)
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
	
	log.Printf("  🛑 Transfer iptal bildirimi gönderildi: %s (reason: %s)", fileID[:8], reason)
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
	log.Printf("🔄 Message loop başladı (peer: %s)", c.peerID[:8])
	
	for {
		select {
		case <-c.ctx.Done():
			log.Printf("🔌 Message loop sonlandı (peer: %s)", c.peerID[:8])
			// Manager varsa connection'ı map'ten kaldır ve callback çağır
			if c.manager != nil {
				c.manager.handleConnectionLost(c.peerID)
			}
			return
		default:
			// Frame boyutunu oku
			frameLen, err := c.readUint32()
			if err != nil {
				// EOF veya bağlantı kapatıldığında normal bir durum
				if err == io.EOF || c.ctx.Err() != nil {
					log.Printf("🔌 Bağlantı kapandı (peer: %s)", c.peerID[:8])
				} else {
					log.Printf("⚠️ Frame length okuma hatası (%s): %v", c.peerID[:8], err)
				}
				// Manager varsa connection'ı map'ten kaldır ve callback çağır
				if c.manager != nil {
					c.manager.handleConnectionLost(c.peerID)
				}
				return
			}
			
		// Log kapatıldı - spam önleme (chunk mesajları için çok fazla log oluşuyor)
		// Sadece gerekli durumlarda (hata vs.) log gösterilecek
		
		// Frame'i oku
			frame := make([]byte, frameLen)
			if _, err := io.ReadFull(c.conn, frame); err != nil {
				// EOF veya bağlantı kapatıldığında normal bir durum
				if err == io.EOF || c.ctx.Err() != nil {
					log.Printf("🔌 Bağlantı kapandı (peer: %s)", c.peerID[:8])
				} else {
					log.Printf("⚠️ Frame okuma hatası (%s): %v", c.peerID[:8], err)
				}
				// Manager varsa connection'ı map'ten kaldır ve callback çağır
				if c.manager != nil {
					c.manager.handleConnectionLost(c.peerID)
				}
				return
			}
			
			// Decode et
			messageType, payload, err := c.protocol.DecodeFrame(frame)
			if err != nil {
				log.Printf("⚠️ Frame decode hatası (%s): %v", c.peerID[:8], err)
				// Frame'in ilk birkaç byte'ını logla
				debugLen := len(frame)
				if debugLen > 30 {
					debugLen = 30
				}
				log.Printf("   Frame (ilk %d byte): %x", debugLen, frame[:debugLen])
				continue
			}
			
		// Sadece chunk olmayan mesajlar için log göster (spam önleme)
		if messageType != MessageTypeChunkResponse && messageType != MessageTypeChunkRequest {
			log.Printf("✅ Frame decode başarılı: type=0x%04x, payload=%d bytes (peer: %s)", messageType, len(payload), c.peerID[:8])
		}
		
		// Mesaj tipine göre işle
		if err := c.handleMessage(messageType, payload); err != nil {
			log.Printf("⚠️ Mesaj işleme hatası (%s): %v", c.peerID[:8], err)
		}
		}
	}
}

// handleMessage gelen mesajı işler
func (c *TCPConnection) handleMessage(messageType uint16, payload []byte) error {
	switch messageType {
	case MessageTypeChunkRequest:
		return c.handleChunkRequest(payload)
	case MessageTypeChunkResponse:
		return c.handleChunkResponse(payload)
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
	case MessageTypeTransferCancel:
		return c.handleTransferCancel(payload)
	default:
		return fmt.Errorf("bilinmeyen mesaj tipi: 0x%04x", messageType)
	}
}

// handleChunkRequest chunk request'i işler
func (c *TCPConnection) handleChunkRequest(payload []byte) error {
	// Payload zaten decode edilmiş, protobuf unmarshal yap
	req := &pb.ChunkRequest{}
	if err := proto.Unmarshal(payload, req); err != nil {
		return fmt.Errorf("chunk request decode hatası: %w", err)
	}
	chunkHash := req.ChunkHash
	
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

// handleChunkResponse chunk response'i işler (push-based sync için)
func (c *TCPConnection) handleChunkResponse(payload []byte) error {
	// Payload zaten decode edilmiş, protobuf unmarshal yap
	resp := &pb.ChunkResponse{}
	if err := proto.Unmarshal(payload, resp); err != nil {
		return fmt.Errorf("chunk response decode hatası: %w", err)
	}
	
	// Log azaltıldı - sadece her 50 chunk'ta bir log (spam önleme)
	if resp.ChunkIndex%50 == 0 || resp.ChunkIndex == 0 || resp.ChunkIndex == resp.TotalChunks-1 {
		log.Printf("📥 Chunk response alındı: %s (%d bytes), FileId: '%s', FileName: '%s', ChunkIndex: %d, TotalChunks: %d", 
			resp.ChunkHash[:8], len(resp.ChunkData), resp.FileId, resp.FileName, resp.ChunkIndex, resp.TotalChunks)
	}
	
	// Eğer file_id varsa, push-based sync demektir
	if resp.FileId != "" {
		// Log azaltıldı - sadece her 50 chunk'ta bir log
		if resp.ChunkIndex%50 == 0 || resp.ChunkIndex == 0 || resp.ChunkIndex == resp.TotalChunks-1 {
			log.Printf("  📁 Dosya sync: %s, fileName: %s, chunk %d/%d", resp.FileId[:8], resp.FileName, resp.ChunkIndex+1, resp.TotalChunks)
		}
		
		// Manager varsa ve chunk received callback varsa çağır
		if c.manager != nil && c.manager.onChunkReceived != nil {
			return c.manager.onChunkReceived(c.peerID, resp.FileId, resp.ChunkHash, resp.ChunkData, int(resp.ChunkIndex), int(resp.TotalChunks), resp.FileName)
		}
		
		log.Printf("  ⚠️ Chunk received callback tanımlı değil, chunk kaydedilemiyor")
	} else {
		log.Printf("  ⚠️ FileId boş, push-based sync aktif değil")
	}
	
	return nil
}

// handleTransferCancel transfer iptal bildirimi işler (gönderen taraf için)
func (c *TCPConnection) handleTransferCancel(payload []byte) error {
	// Payload zaten decode edilmiş, protobuf unmarshal yap
	notif := &pb.TransferCancelNotification{}
	if err := proto.Unmarshal(payload, notif); err != nil {
		return fmt.Errorf("transfer cancel unmarshal hatası: %w", err)
	}
	
	fileID := notif.FileId
	reason := notif.Reason
	
	log.Printf("🛑 Transfer iptal bildirimi alındı: file_id=%s, reason=%s (peer: %s)", fileID[:8], reason, c.peerID[:8])
	
	// Manager varsa ve onTransferCancel callback'i varsa, transfer'i iptal et
	if c.manager != nil && c.manager.onTransferCancel != nil {
		c.manager.onTransferCancel(c.peerID, fileID)
		log.Printf("  ✅ Transfer iptal callback'i çağrıldı: %s", fileID[:8])
	} else {
		log.Printf("  ⚠️ Transfer iptal callback'i tanımlı değil (manager: %v, callback: %v): %s", c.manager != nil, c.manager != nil && c.manager.onTransferCancel != nil, fileID[:8])
	}
	
	return nil
}

// handlePing ping request'i işler
func (c *TCPConnection) handlePing(payload []byte) error {
	// Payload zaten decode edilmiş, protobuf unmarshal yap
	req := &pb.PingRequest{}
	if err := proto.Unmarshal(payload, req); err != nil {
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
	log.Printf("📤 Connection request hazırlanıyor: %s (%s)", deviceName, deviceID[:8])
	
	c.sendMu.Lock()
	defer c.sendMu.Unlock()
	
	request, err := c.protocol.EncodeConnectionRequest(deviceID, deviceName)
	if err != nil {
		return fmt.Errorf("connection request encode hatası: %w", err)
	}
	
	log.Printf("📦 Connection request frame hazır: %d bytes", len(request))
	
	// Frame boyutunu gönder
	if err := c.writeUint32(uint32(len(request))); err != nil {
		return fmt.Errorf("frame length yazılamadı: %w", err)
	}
	
	log.Printf("✅ Frame length yazıldı: %d", len(request))
	
	// Frame'i gönder
	if n, err := c.conn.Write(request); err != nil {
		return fmt.Errorf("frame yazılamadı: %w", err)
	} else {
		log.Printf("✅ Frame yazıldı: %d bytes", n)
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
	onConnectionLost        func(peerID string)
	chunkHandlerCallback    func(chunkHash string) ([]byte, error)
	onChunkReceived         func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName string) error
	onTransferCancel        func(peerID, fileID string) // Transfer iptal bildirimi callback'i
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
	log.Printf("🔌 TCP bağlantısı deneniyor: %s (peer: %s)", address, peerID[:8])
	
	// TCP dial
	conn, err := net.DialTimeout("tcp", address, 5*time.Second)
	if err != nil {
		log.Printf("❌ TCP connect hatası: %v (address: %s)", err, address)
		return nil, fmt.Errorf("TCP connect hatası: %w", err)
	}
	
	log.Printf("✅ TCP bağlantısı kuruldu: %s", address)
	
	// Client handshake yap
	log.Printf("🤝 Handshake başlatılıyor...")
	peerHandshake, err := PerformClientHandshake(conn, m.deviceID, m.deviceName)
	if err != nil {
		log.Printf("❌ Handshake hatası: %v", err)
		conn.Close()
		return nil, fmt.Errorf("handshake başarısız: %w", err)
	}
	
	log.Printf("✅ Handshake başarılı: %s (%s)", peerHandshake.DeviceName, peerHandshake.DeviceID[:8])
	
	// Handshake'den gelen peer ID ile parametredeki eşleşiyor mu?
	if peerHandshake.DeviceID != peerID {
		conn.Close()
		return nil, fmt.Errorf("peer ID uyuşmazlığı: expected=%s, got=%s", peerID, peerHandshake.DeviceID)
	}
	
	// TCPConnection oluştur (manager referansı ile - client-side connection da manager'a bağlı olmalı)
	// Böylece bağlantı kapandığında handleConnectionLost çağrılabilir
	// autoStartMessageLoop=false çünkü önce connection request gönderip response bekleyeceğiz
	tcpConn := NewTCPConnectionWithManagerAndAutoStart(peerID, address, conn, m, false)
	
	// Connection request gönder (messageLoop başlamadan önce)
	log.Printf("🔧 SendConnectionRequest çağrılıyor...")
	if err := tcpConn.SendConnectionRequest(m.deviceID, m.deviceName); err != nil {
		log.Printf("❌ Connection request hatası: %v", err)
		tcpConn.Close()
		return nil, fmt.Errorf("connection request gönderilemedi: %w", err)
	}
	log.Printf("✅ SendConnectionRequest tamamlandı")
	
	// Connection response bekle (5 saniye timeout)
	if err := tcpConn.WaitForConnectionResponse(5 * time.Second); err != nil {
		tcpConn.Close()
		return nil, fmt.Errorf("connection response alınamadı: %w", err)
	}
	
	// Response alındıktan sonra messageLoop'u başlat
	tcpConn.startMessageLoop()
	
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

// Disconnect peer bağlantısını keser ve map'ten kaldırır
func (m *TCPConnectionManager) Disconnect(peerID string) error {
	m.mu.Lock()
	conn, exists := m.connections[peerID]
	if exists {
		delete(m.connections, peerID)
	}
	m.mu.Unlock()
	
	if !exists {
		return fmt.Errorf("bağlantı bulunamadı: %s", peerID)
	}
	
	log.Printf("🔌 Bağlantı kesiliyor: %s", peerID[:8])
	
	// Bağlantıyı kapat (messageLoop sonlandırılacak)
	if err := conn.Close(); err != nil {
		return fmt.Errorf("bağlantı kapatılamadı: %w", err)
	}
	
	log.Printf("✅ Bağlantı kapatıldı: %s", peerID[:8])
	return nil
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

// SetOnConnectionLost connection lost callback'ini set eder
func (m *TCPConnectionManager) SetOnConnectionLost(callback func(peerID string)) {
	m.onConnectionLost = callback
}

// SetOnChunkReceived chunk received callback'ini set eder
func (m *TCPConnectionManager) SetOnChunkReceived(callback func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName string) error) {
	m.onChunkReceived = callback
}

// SetOnTransferCancel transfer cancel callback'ini set eder
func (m *TCPConnectionManager) SetOnTransferCancel(callback func(peerID, fileID string)) {
	m.onTransferCancel = callback
}

// handleConnectionLost bağlantı kaybını işler (internal)
func (m *TCPConnectionManager) handleConnectionLost(peerID string) {
	m.mu.Lock()
	_, exists := m.connections[peerID]
	if exists {
		delete(m.connections, peerID)
		log.Printf("🔌 Connection map'ten kaldırıldı: %s", peerID[:8])
	}
	m.mu.Unlock()
	
	if exists {
		// Callback çağır
		if m.onConnectionLost != nil {
			m.onConnectionLost(peerID)
		}
	}
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

