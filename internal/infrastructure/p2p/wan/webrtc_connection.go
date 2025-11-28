package wan

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"sync"
	"time"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/infrastructure/p2p/lan"
	"github.com/pion/webrtc/v3"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/proto"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/domain/transport"
)

// WebRTCConnectionManager WebRTC data channel connection yönetimi
type WebRTCConnectionManager struct {
	deviceID   string
	deviceName string
	iceAgent   ICEAgent
	wanConfig  config.NetworkConfig

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
func NewWebRTCConnectionManager(deviceID, deviceName string, iceAgent ICEAgent, wanConfig config.NetworkConfig) *WebRTCConnectionManager {
	return &WebRTCConnectionManager{
		deviceID:    deviceID,
		deviceName:  deviceName,
		iceAgent:    iceAgent,
		wanConfig:   wanConfig,
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

	// WebRTC configuration oluştur
	webrtcConfig := CreateWebRTCConfiguration(
		m.wanConfig.STUNServers,
		m.wanConfig.TURNServers,
		m.wanConfig.WebRTCPortRange,
	)

	// WebRTC peer connection oluştur
	webrtcPeer, err := NewWebRTCPeer(webrtcConfig)
	if err != nil {
		return nil, fmt.Errorf("WebRTC peer oluşturulamadı: %w", err)
	}

	// Data channel oluştur
	dataChannel, err := webrtcPeer.CreateDataChannel("aether-chunks", true)
	if err != nil {
		webrtcPeer.Close()
		return nil, fmt.Errorf("data channel oluşturulamadı: %w", err)
	}

	// WebRTC connection oluştur
	webrtcConn := NewWebRTCConnection(peer.DeviceID, peer.DeviceName, webrtcPeer, dataChannel)

	// Callback'leri bağla
	if m.chunkHandler != nil {
		webrtcConn.SetChunkHandler(m.chunkHandler)
	}
	if m.onChunkReceived != nil {
		webrtcConn.SetOnChunkReceived(m.onChunkReceived)
	}
	if m.onTransferCancel != nil {
		webrtcConn.SetOnTransferCancel(m.onTransferCancel)
	}
	if m.onFileDelete != nil {
		webrtcConn.SetOnFileDelete(m.onFileDelete)
	}

	// SDP offer oluştur
	offer, err := webrtcPeer.CreateOffer(ctx)
	if err != nil {
		webrtcPeer.Close()
		return nil, fmt.Errorf("SDP offer oluşturulamadı: %w", err)
	}

	log.Printf("📋 SDP offer oluşturuldu (type: %s)", offer.Type.String())

	// Remote ICE candidates'ı peer metadata'dan al ve ekle
	if iceCandidatesJSON, ok := peer.Metadata["ice_candidates"]; ok && iceCandidatesJSON != "" {
		candidates := parseICECandidatesFromJSON(iceCandidatesJSON)
		if len(candidates) > 0 {
			log.Printf("📡 %d remote ICE candidate metadata'dan alındı", len(candidates))
			
			// Remote ICE candidates'ı WebRTC peer connection'a ekle
			// NOT: WebRTC SDP'den otomatik candidate alır
			// Ancak invitation code'dan gelen candidate'ları da manuel ekleyebiliriz
			for _, cand := range candidates {
				// WebRTC ICE candidate formatına çevir
				candidateStr := fmt.Sprintf("candidate:%s %d %s %s %s %d typ %s",
					cand.Type, cand.Priority, cand.Protocol,
					cand.IP.String(), cand.IP.String(), cand.Port, cand.Type)
				
				iceCandidate := webrtc.ICECandidateInit{
					Candidate: candidateStr,
				}
				
				if err := webrtcPeer.AddICECandidate(iceCandidate); err != nil {
					log.Printf("⚠️ Remote ICE candidate eklenemedi: %v", err)
				}
			}
		}
	}

	// SDP exchange yap (gRPC üzerinden)
	grpcAddress, ok := peer.Metadata["grpc_address"]
	if !ok || grpcAddress == "" {
		log.Printf("⚠️ gRPC adresi bulunamadı, SDP exchange yapılamıyor: %s", peer.DeviceID[:8])
		// Connection'ı map'e ekle (SDP exchange olmadan)
		m.connections[peer.DeviceID] = webrtcConn
		log.Printf("✅ WebRTC connection oluşturuldu (SDP exchange bekleniyor): %s", peer.DeviceID[:8])
	} else {
		// gRPC client oluştur ve SDP exchange yap
		log.Printf("📡 gRPC üzerinden SDP exchange başlatılıyor: %s -> %s", peer.DeviceID[:8], grpcAddress)
		
		// gRPC connection oluştur
		grpcConn, err := grpc.NewClient(grpcAddress, grpc.WithTransportCredentials(insecure.NewCredentials()))
		if err != nil {
			log.Printf("⚠️ gRPC client oluşturulamadı: %v (connection devam edecek)", err)
			m.connections[peer.DeviceID] = webrtcConn
			return webrtcConn, nil
		}
		defer grpcConn.Close()

		// Peer service client oluştur
		peerClient := pb.NewPeerServiceClient(grpcConn)

		// Offer'ı gönder
		exchangeReq := &pb.ExchangeSDPRequest{
			PeerId:  m.deviceID, // Kendi device ID'mizi gönderiyoruz
			SdpType: "offer",
			Sdp:     offer.SDP, // SDP string
		}

		log.Printf("📤 SDP offer gönderiliyor: %s", peer.DeviceID[:8])
		exchangeResp, err := peerClient.ExchangeSDP(ctx, exchangeReq)
		if err != nil {
			log.Printf("⚠️ SDP exchange hatası: %v (connection devam edecek)", err)
			m.connections[peer.DeviceID] = webrtcConn
			return webrtcConn, nil
		}

		if !exchangeResp.Status.Success {
			log.Printf("⚠️ SDP exchange başarısız: %s (connection devam edecek)", exchangeResp.Status.Message)
			m.connections[peer.DeviceID] = webrtcConn
			return webrtcConn, nil
		}

		if exchangeResp.SdpType == "answer" && exchangeResp.Sdp != "" {
			// Answer alındı, remote description set et
			answerDesc := webrtc.SessionDescription{
				Type: webrtc.SDPTypeAnswer,
				SDP:  exchangeResp.Sdp,
			}

			if err := webrtcPeer.SetRemoteDescription(answerDesc); err != nil {
				log.Printf("⚠️ Remote description set edilemedi: %v", err)
			} else {
				log.Printf("✅ SDP answer alındı ve set edildi: %s", peer.DeviceID[:8])
			}
		}
	}

	// Connection'ı map'e ekle
	m.connections[peer.DeviceID] = webrtcConn

	log.Printf("✅ WebRTC connection oluşturuldu: %s", peer.DeviceID[:8])

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
type WebRTCConnection struct {
	peerID      string
	peerName    string
	webrtcPeer  *WebRTCPeer
	dataChannel *webrtc.DataChannel
	protocol    *lan.Protocol
	
	connected   bool
	mu          sync.RWMutex
	chunkHandler func(chunkHash string) ([]byte, error)
	connectedAt time.Time
	
	// Callbacks
	onChunkReceived  func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error
	onTransferCancel func(peerID, fileID string)
	onFileDelete     func(peerID, fileID string)
}

// NewWebRTCConnection yeni WebRTC connection oluşturur
func NewWebRTCConnection(peerID, peerName string, webrtcPeer *WebRTCPeer, dataChannel *webrtc.DataChannel) *WebRTCConnection {
	conn := &WebRTCConnection{
		peerID:      peerID,
		peerName:    peerName,
		webrtcPeer:  webrtcPeer,
		dataChannel: dataChannel,
		protocol:    lan.NewProtocol(),
		connected:   false,
		connectedAt: time.Now(),
	}
	
	// Data channel callback'lerini ayarla
	if dataChannel != nil {
		conn.setupDataChannel(dataChannel)
	}
	
	return conn
}

// setupDataChannel data channel callback'lerini ayarlar
func (c *WebRTCConnection) setupDataChannel(dc *webrtc.DataChannel) {
	dc.OnOpen(func() {
		c.mu.Lock()
		c.connected = true
		c.mu.Unlock()
		log.Printf("✅ WebRTC data channel açıldı: %s", c.peerID[:8])
	})
	
	dc.OnClose(func() {
		c.mu.Lock()
		c.connected = false
		c.mu.Unlock()
		log.Printf("🔌 WebRTC data channel kapandı: %s", c.peerID[:8])
	})
	
	dc.OnError(func(err error) {
		log.Printf("❌ WebRTC data channel hatası (%s): %v", c.peerID[:8], err)
	})
	
	dc.OnMessage(func(msg webrtc.DataChannelMessage) {
		go c.handleIncomingMessage(msg.Data)
	})
}

// handleIncomingMessage gelen mesajı işler
func (c *WebRTCConnection) handleIncomingMessage(data []byte) {
	if len(data) == 0 {
		return
	}
	
	// Protocol ile decode et
	messageType, payload, err := c.protocol.DecodeFrame(data)
	if err != nil {
		log.Printf("⚠️ Mesaj decode edilemedi (%s): %v", c.peerID[:8], err)
		return
	}
	
	switch messageType {
	case lan.MessageTypeChunkResponse:
		c.handleChunkResponse(payload)
	case lan.MessageTypeChunkRequest:
		c.handleChunkRequest(payload)
	case lan.MessageTypeFileDelete:
		c.handleFileDelete(payload)
	case lan.MessageTypeTransferCancel:
		c.handleTransferCancel(payload)
	case lan.MessageTypePing:
		c.handlePing(payload)
	case lan.MessageTypePong:
		c.handlePong(payload)
	default:
		log.Printf("⚠️ Bilinmeyen mesaj tipi: 0x%04x", messageType)
	}
}

// handleChunkResponse chunk response mesajını işler
func (c *WebRTCConnection) handleChunkResponse(payload []byte) {
	resp := &pb.ChunkResponse{}
	if err := proto.Unmarshal(payload, resp); err != nil {
		log.Printf("⚠️ Chunk response parse edilemedi: %v", err)
		return
	}
	
	// Push-based sync için file bilgisi varsa callback çağır
	if resp.FileId != "" && c.onChunkReceived != nil {
		err := c.onChunkReceived(
			c.peerID,
			resp.FileId,
			resp.ChunkHash,
			resp.ChunkData,
			int(resp.ChunkIndex),
			int(resp.TotalChunks),
			resp.FileName,
			resp.FolderName,
			resp.SenderSyncMode,
			resp.ReceiverSyncMode,
		)
		if err != nil {
			log.Printf("⚠️ Chunk received callback hatası: %v", err)
		}
	}
}

// handleChunkRequest chunk request mesajını işler
func (c *WebRTCConnection) handleChunkRequest(payload []byte) {
	req := &pb.ChunkRequest{}
	if err := proto.Unmarshal(payload, req); err != nil {
		log.Printf("⚠️ Chunk request parse edilemedi: %v", err)
		return
	}
	
	// Chunk handler varsa chunk'ı al ve gönder
	if c.chunkHandler != nil {
		chunkData, err := c.chunkHandler(req.ChunkHash)
		if err != nil {
			log.Printf("⚠️ Chunk alınamadı (%s): %v", req.ChunkHash[:8], err)
			return
		}
		
		// Chunk'ı gönder (basit response)
		if err := c.SendChunk(context.Background(), req.ChunkHash, chunkData); err != nil {
			log.Printf("⚠️ Chunk gönderilemedi: %v", err)
		}
	}
}

// handleFileDelete dosya silme mesajını işler
func (c *WebRTCConnection) handleFileDelete(payload []byte) {
	fileID, err := c.protocol.DecodeFileDelete(payload)
	if err != nil {
		log.Printf("⚠️ File delete parse edilemedi: %v", err)
		return
	}
	
	if c.onFileDelete != nil {
		c.onFileDelete(c.peerID, fileID)
	}
}

// handleTransferCancel transfer cancel mesajını işler
func (c *WebRTCConnection) handleTransferCancel(payload []byte) {
	fileID, _, err := c.protocol.DecodeTransferCancel(payload)
	if err != nil {
		log.Printf("⚠️ Transfer cancel parse edilemedi: %v", err)
		return
	}
	
	if c.onTransferCancel != nil {
		c.onTransferCancel(c.peerID, fileID)
	}
}

// handlePing ping mesajını işler ve pong gönderir
func (c *WebRTCConnection) handlePing(payload []byte) {
	// Ping'e pong ile cevap ver
	_, err := c.protocol.DecodePing(payload)
	if err != nil {
		log.Printf("⚠️ Ping parse edilemedi: %v", err)
		return
	}
	
	// Pong gönder (basit implementasyon)
	pongData, err := c.protocol.EncodePong(c.peerID, 0)
	if err != nil {
		log.Printf("⚠️ Pong encode edilemedi: %v", err)
		return
	}
	
	c.mu.RLock()
	dc := c.dataChannel
	c.mu.RUnlock()
	
	if dc != nil && dc.ReadyState() == webrtc.DataChannelStateOpen {
		if err := dc.Send(pongData); err != nil {
			log.Printf("⚠️ Pong gönderilemedi: %v", err)
		}
	}
}

// handlePong pong mesajını işler
func (c *WebRTCConnection) handlePong(payload []byte) {
	// Pong alındı (latency ölçümü için kullanılabilir)
	_, err := c.protocol.DecodePong(payload)
	if err != nil {
		log.Printf("⚠️ Pong parse edilemedi: %v", err)
		return
	}
}

// SendChunk chunk gönderir (pull-based için)
func (c *WebRTCConnection) SendChunk(ctx context.Context, chunkHash string, data []byte) error {
	return c.SendChunkWithFileInfo(ctx, chunkHash, data, "", 0, 0, "", "", pb.SyncMode_SYNC_MODE_UNSPECIFIED, pb.SyncMode_SYNC_MODE_UNSPECIFIED)
}

// SendChunkWithFileInfo chunk gönderir (push-based sync için file bilgisiyle)
func (c *WebRTCConnection) SendChunkWithFileInfo(ctx context.Context, chunkHash string, data []byte, fileID string, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error {
	c.mu.RLock()
	dc := c.dataChannel
	connected := c.connected
	c.mu.RUnlock()

	if !connected || dc == nil {
		return fmt.Errorf("bağlantı kurulu değil veya data channel yok")
	}

	if dc.ReadyState() != webrtc.DataChannelStateOpen {
		return fmt.Errorf("data channel açık değil: %s", dc.ReadyState().String())
	}

	// Protocol ile encode et
	frame, err := c.protocol.EncodeChunkResponseWithFileInfo(chunkHash, data, fileID, chunkIndex, totalChunks, fileName, folderName, senderSyncMode, receiverSyncMode)
	if err != nil {
		return fmt.Errorf("chunk encode edilemedi: %w", err)
	}

	// Data channel üzerinden gönder
	if err := dc.Send(frame); err != nil {
		return fmt.Errorf("chunk gönderilemedi: %w", err)
	}

	log.Printf("📤 Chunk gönderildi (WebRTC): %s, file=%s, chunk=%d/%d (%d bytes)", 
		chunkHash[:8], fileID[:8], chunkIndex+1, totalChunks, len(data))

	return nil
}

// RequestChunk chunk talep eder
func (c *WebRTCConnection) RequestChunk(ctx context.Context, chunkHash string) ([]byte, error) {
	c.mu.RLock()
	dc := c.dataChannel
	connected := c.connected
	c.mu.RUnlock()

	if !connected || dc == nil {
		return nil, fmt.Errorf("bağlantı kurulu değil veya data channel yok")
	}

	if dc.ReadyState() != webrtc.DataChannelStateOpen {
		return nil, fmt.Errorf("data channel açık değil: %s", dc.ReadyState().String())
	}

	// Chunk request encode et
	frame, err := c.protocol.EncodeChunkRequest(chunkHash)
	if err != nil {
		return nil, fmt.Errorf("chunk request encode edilemedi: %w", err)
	}

	// Data channel üzerinden gönder
	if err := dc.Send(frame); err != nil {
		return nil, fmt.Errorf("chunk request gönderilemedi: %w", err)
	}

	log.Printf("📥 Chunk talep edildi (WebRTC): %s", chunkHash[:8])

	// NOT: Gerçek implementasyonda response'u bekle ve döndür
	// Şimdilik async olarak gönderiliyor, response callback ile gelecek
	return nil, fmt.Errorf("async chunk request - response callback ile gelecek (TODO: sync request/response implementasyonu)")
}

// SendFileDelete dosya silme bildirimini gönderir (peer-to-peer)
func (c *WebRTCConnection) SendFileDelete(ctx context.Context, fileID string) error {
	c.mu.RLock()
	dc := c.dataChannel
	connected := c.connected
	c.mu.RUnlock()

	if !connected || dc == nil {
		return fmt.Errorf("bağlantı kurulu değil veya data channel yok")
	}

	if dc.ReadyState() != webrtc.DataChannelStateOpen {
		return fmt.Errorf("data channel açık değil: %s", dc.ReadyState().String())
	}

	// File delete encode et
	frame, err := c.protocol.EncodeFileDelete(fileID)
	if err != nil {
		return fmt.Errorf("file delete encode edilemedi: %w", err)
	}

	// Data channel üzerinden gönder
	if err := dc.Send(frame); err != nil {
		return fmt.Errorf("file delete gönderilemedi: %w", err)
	}

	log.Printf("🗑️ Dosya silme bildirimi gönderildi (WebRTC): %s", fileID[:8])
	return nil
}

// SendMetadata metadata gönderir
func (c *WebRTCConnection) SendMetadata(ctx context.Context, metadata *transport.FileMetadata) error {
	c.mu.RLock()
	dc := c.dataChannel
	connected := c.connected
	c.mu.RUnlock()

	if !connected || dc == nil {
		return fmt.Errorf("bağlantı kurulu değil veya data channel yok")
	}

	if dc.ReadyState() != webrtc.DataChannelStateOpen {
		return fmt.Errorf("data channel açık değil: %s", dc.ReadyState().String())
	}

	// Metadata encode et
	frame, err := c.protocol.EncodeMetadata(metadata)
	if err != nil {
		return fmt.Errorf("metadata encode edilemedi: %w", err)
	}

	// Data channel üzerinden gönder
	if err := dc.Send(frame); err != nil {
		return fmt.Errorf("metadata gönderilemedi: %w", err)
	}

	return nil
}

// RequestMetadata metadata talep eder
func (c *WebRTCConnection) RequestMetadata(ctx context.Context, fileID string) (*transport.FileMetadata, error) {
	// NOT: Async request, response callback ile gelecek
	// Şimdilik sync request/response implementasyonu yok
	return nil, fmt.Errorf("async metadata request - response callback ile gelecek (TODO: sync request/response implementasyonu)")
}

// Ping ping gönderir
func (c *WebRTCConnection) Ping(ctx context.Context) (time.Duration, error) {
	c.mu.RLock()
	dc := c.dataChannel
	connected := c.connected
	c.mu.RUnlock()

	if !connected || dc == nil {
		return 0, fmt.Errorf("bağlantı kurulu değil veya data channel yok")
	}

	if dc.ReadyState() != webrtc.DataChannelStateOpen {
		return 0, fmt.Errorf("data channel açık değil: %s", dc.ReadyState().String())
	}

	// Ping encode et
	pingData, err := c.protocol.EncodePing(c.peerID)
	if err != nil {
		return 0, fmt.Errorf("ping encode edilemedi: %w", err)
	}

	// Ping gönder
	startTime := time.Now()
	if err := dc.Send(pingData); err != nil {
		return 0, fmt.Errorf("ping gönderilemedi: %w", err)
	}

	log.Printf("🏓 Ping gönderildi (WebRTC): %s", c.peerID[:8])

	// NOT: Pong response'u async olarak gelecek
	// Şimdilik latency hesaplanmıyor, response callback ile gelir
	// TODO: Sync ping/pong implementasyonu (channel veya promise ile)
	
	return time.Since(startTime), nil
}

// Close bağlantıyı kapatır
func (c *WebRTCConnection) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	if !c.connected {
		return nil
	}

	c.connected = false

	// Data channel'ı kapat
	if c.dataChannel != nil {
		if err := c.dataChannel.Close(); err != nil {
			log.Printf("⚠️ Data channel kapatılamadı: %v", err)
		}
	}

	// WebRTC peer connection'ı kapat
	if c.webrtcPeer != nil {
		if err := c.webrtcPeer.Close(); err != nil {
			log.Printf("⚠️ WebRTC peer kapatılamadı: %v", err)
		}
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

// SetOnChunkReceived callback'i ayarlar
func (c *WebRTCConnection) SetOnChunkReceived(callback func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error) {
	c.onChunkReceived = callback
}

// SetOnTransferCancel callback'i ayarlar
func (c *WebRTCConnection) SetOnTransferCancel(callback func(peerID, fileID string)) {
	c.onTransferCancel = callback
}

// SetOnFileDelete callback'i ayarlar
func (c *WebRTCConnection) SetOnFileDelete(callback func(peerID, fileID string)) {
	c.onFileDelete = callback
}

// GetWebRTCPeer WebRTC peer'ı döner
func (c *WebRTCConnection) GetWebRTCPeer() *WebRTCPeer {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.webrtcPeer
}

// parseICECandidatesFromJSON JSON'dan ICE candidates parse eder
func parseICECandidatesFromJSON(jsonStr string) []ICECandidate {
	var candidates []ICECandidate
	
	var candidatesData []map[string]interface{}
	if err := json.Unmarshal([]byte(jsonStr), &candidatesData); err != nil {
		log.Printf("⚠️ ICE candidates JSON parse edilemedi: %v", err)
		return candidates
	}
	
	for _, data := range candidatesData {
		cand := ICECandidate{
			Type:     getString(data, "type"),
			Protocol: getString(data, "protocol"),
		}
		
		// IP parse
		if ipStr, ok := data["ip"].(string); ok {
			cand.IP = net.ParseIP(ipStr)
		}
		
		// Port parse
		if port, ok := data["port"].(float64); ok {
			cand.Port = int(port)
		}
		
		// Priority parse
		if priority, ok := data["priority"].(float64); ok {
			cand.Priority = int64(priority)
		}
		
		if cand.IP != nil && cand.Port > 0 {
			candidates = append(candidates, cand)
		}
	}
	
	return candidates
}

// getString map'ten string değer alır
func getString(m map[string]interface{}, key string) string {
	if val, ok := m[key].(string); ok {
		return val
	}
	return ""
}

