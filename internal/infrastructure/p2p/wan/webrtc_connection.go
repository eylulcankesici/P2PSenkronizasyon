package wan

import (
	"context"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"strings"
	"sync"
	"time"

	"github.com/google/uuid"

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

	// Pending connections (WAN için)
	pendingConns map[string]*PendingConnection
	pendingMu    sync.RWMutex
	
	// Pending invitations
	pendingInvitations map[string]*WebRTCPeer

	// Pending peers (waiting for Connect)
	pendingPeers map[string]*WebRTCPeer

	// State
	started bool
	
	// Callbacks
	onConnectionEstablished func(conn transport.Connection)
	onConnectionLost        func(peerID string)
	onConnectionRequested   func(deviceID, deviceName string)
	
	// Chunk callbacks
	chunkHandler     func(chunkHash string) ([]byte, error)
	onChunkReceived  func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error
	onTransferCancel func(peerID, fileID string)
	onFileDelete     func(peerID, fileID string)
	onPeerIDUpdated  func(oldID, newID, newName string)
}

// PendingConnection WAN için bekleyen bağlantı isteği
type PendingConnection struct {
	DeviceID   string
	DeviceName string
	SDPOffer   string
	Timestamp  time.Time
	ResponseCh chan bool
}

// NewWebRTCConnectionManager yeni WebRTC connection manager oluşturur
func NewWebRTCConnectionManager(deviceID, deviceName string, iceAgent ICEAgent, wanConfig config.NetworkConfig) *WebRTCConnectionManager {
	return &WebRTCConnectionManager{
		deviceID:           deviceID,
		deviceName:         deviceName,
		iceAgent:           iceAgent,
		wanConfig:          wanConfig,
		connections:        make(map[string]*WebRTCConnection),
		pendingConns:       make(map[string]*PendingConnection),
		pendingInvitations: make(map[string]*WebRTCPeer),
		pendingPeers:       make(map[string]*WebRTCPeer),
	}
}

// Connect peer'a WebRTC bağlantısı kurar
func (m *WebRTCConnectionManager) Connect(ctx context.Context, peer *transport.DiscoveredPeer) (transport.Connection, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	// Zaten bağlı mı kontrol et
	// Zaten bağlı mı kontrol et
	if conn, exists := m.connections[peer.DeviceID]; exists {
		// Bağlantı varsa ve durumu closed/failed değilse
		state := conn.GetState()
		if state != webrtc.PeerConnectionStateClosed && state != webrtc.PeerConnectionStateFailed {
			log.Printf("🔌 Mevcut bağlantı bulundu (%s): %s", peer.DeviceID[:8], state.String())
			
			// Handshake tamamlanmış mı?
			if conn.isHandshakeComplete {
				log.Printf("✅ Handshake zaten tamamlanmış, bağlantı aktif")
				return conn, nil
			}
			
			// Handshake tamamlanmamış, istek gönder
			log.Printf("👋 Handshake isteği gönderiliyor: %s", peer.DeviceID[:8])
			
			// Request oluştur
			reqData, err := conn.protocol.EncodeConnectionRequest(m.deviceID, m.deviceName)
			if err != nil {
				log.Printf("❌ Handshake request encode hatası: %v", err)
				return nil, err
			}
			
			// Data channel üzerinden gönder
			if conn.dataChannel != nil {
				if err := conn.dataChannel.Send(reqData); err != nil {
					log.Printf("❌ Handshake request gönderme hatası: %v", err)
					return nil, err
				}
				log.Printf("📤 Handshake request gönderildi")
			} else {
				log.Printf("⚠️ Data channel henüz hazır değil, istek gönderilemedi")
			}
			
			return conn, nil
		}
		// Failed/Closed ise yeni bağlantı oluşturmaya devam et
		log.Printf("♻️ Eski bağlantı durumu %s, yeni bağlantı oluşturuluyor: %s", state.String(), peer.DeviceID[:8])
	}

	// Pending peer var mı kontrol et (AddPeerByInvitation ile eklenen)
	// NOT: GetPendingPeer çağırmıyoruz çünkü m.mu zaten kilitli (Deadlock önleme)
	if pendingPeer, ok := m.pendingPeers[peer.DeviceID]; ok {
		log.Printf("🔌 Pending peer bulundu, mevcut WebRTC session kullanılıyor: %s", peer.DeviceID[:8])
		
		// Data channel oluştur (eğer yoksa)
		// NOT: Genellikle Offerer oluşturur, ama biz Answerer isek ve pendingPeer varsa
		// zaten session kurulmuştur. Data channel'ı kontrol etmemiz gerekebilir.
		// Ancak pendingPeer struct'ında data channel yok, WebRTCPeer içinde var mı?
		// WebRTCPeer wrapper'ında data channel saklanmıyor, sadece Pion PeerConnection var.
		// Bu durumda yeni bir data channel oluşturmayı deneyebiliriz veya OnDataChannel bekleyebiliriz.
		// Pion'da OnDataChannel callback'i zaten ayarlı (NewWebRTCPeer içinde).
		
		// Data channel'ı peer'dan al
		dc := pendingPeer.GetDataChannel()
		
		// WebRTC connection oluştur
		// Data channel varsa onu kullan, yoksa nil geç (OnDataChannel ile beklenecek)
		webrtcConn := NewWebRTCConnection(peer.DeviceID, peer.DeviceName, m.deviceName, pendingPeer, dc)
		
		// Callback'leri bağla
		webrtcConn.SetOnConnectionRequested(func(deviceID, deviceName string) {
			m.AddPendingConnection(deviceID, deviceName, "")
		})
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
		
		// Connection'ı kaydet
		m.connections[peer.DeviceID] = webrtcConn
		log.Printf("✅ WebRTC connection oluşturuldu (Pending Peer ile): %s", peer.DeviceID[:8])
		
		// Handshake isteği gönder
		// Connection henüz tam hazır olmayabilir (ICE checking vs), ama deneyelim
		go func() {
			// Data channel açılana kadar bekle (max 30 saniye)
			log.Printf("⏳ Data channel bekleniyor (max 30s)...")
			
			timeout := time.After(30 * time.Second)
			ticker := time.NewTicker(500 * time.Millisecond)
			defer ticker.Stop()
			
			tickCount := 0
			for {
				select {
				case <-timeout:
					log.Printf("⚠️ Data channel timeout, istek gönderilemedi (Pending Peer)")
					return
				case <-ticker.C:
					tickCount++
					dc := webrtcConn.GetDataChannel()
					
					// Log status every 3 seconds
					if tickCount % 6 == 0 {
						iceState := webrtcConn.GetICEConnectionState()
						connState := webrtcConn.GetState()
						dcState := "nil"
						if dc != nil {
							dcState = dc.ReadyState().String()
						}
						log.Printf("⏳ Waiting for DataChannel... ICE: %s, Conn: %s, DC: %s", iceState, connState, dcState)
					}

					if dc != nil && dc.ReadyState() == webrtc.DataChannelStateOpen {
						// Request oluştur
						reqData, err := webrtcConn.protocol.EncodeConnectionRequest(m.deviceID, m.deviceName)
						if err != nil {
							log.Printf("❌ Handshake request encode hatası: %v", err)
							return
						}
						
						// Data channel üzerinden gönder
						if err := dc.Send(reqData); err != nil {
							log.Printf("❌ Handshake request gönderme hatası: %v", err)
						} else {
							log.Printf("📤 Handshake request gönderildi (Pending Peer)")
						}
						return
					}
				}
			}
		}()
		
		return webrtcConn, nil
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
	webrtcConn := NewWebRTCConnection(peer.DeviceID, peer.DeviceName, m.deviceName, webrtcPeer, dataChannel)

	// Callback'leri bağla
	webrtcConn.SetOnConnectionRequested(func(deviceID, deviceName string) {
		m.AddPendingConnection(deviceID, deviceName, "")
	})
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
			log.Printf("📡 %d remote ICE candidate metadata'dan alındı (Remote description set edildikten sonra eklenecek)", len(candidates))
			
			// Remote ICE candidates'ı sakla, remote description set edildikten sonra ekle
			// WebRTC state: Remote description set edilmeden candidate eklenemez
			go func() {
				// Remote description set edilene kadar bekle (basit polling)
				// TODO: Daha iyi bir senkronizasyon mekanizması kullanılabilir
				timeout := time.After(30 * time.Second)
				ticker := time.NewTicker(100 * time.Millisecond)
				defer ticker.Stop()

				for {
					select {
					case <-timeout:
						log.Printf("⚠️ ICE candidate ekleme zaman aşımı: Remote description set edilmedi")
						return
					case <-ticker.C:
						if webrtcPeer.GetConnectionState() != webrtc.PeerConnectionStateNew && 
						   webrtcPeer.GetConnectionState() != webrtc.PeerConnectionStateClosed {
							// Remote description set edilmiş olabilir (state değişti)
							// Ancak Pion'da remote description kontrolü için direkt erişim yok
							// Try-error yaklaşımı ile eklemeyi dene
							
							for _, cand := range candidates {
								// WebRTC ICE candidate formatına çevir
								candidateStr := fmt.Sprintf("candidate:%s %d %s %s %s %d typ %s",
									cand.Type, cand.Priority, cand.Protocol,
									cand.IP.String(), cand.IP.String(), cand.Port, cand.Type)
								
								iceCandidate := webrtc.ICECandidateInit{
									Candidate: candidateStr,
								}
								
								if err := webrtcPeer.AddICECandidate(iceCandidate); err != nil {
									// Henüz hazır değil veya hata, sonra tekrar dene
									// log.Printf("⚠️ Remote ICE candidate eklenemedi (tekrar denenecek): %v", err)
								} else {
									// Başarılı, logla ve döngüden çık (bu candidate için)
									// log.Printf("✅ Remote ICE candidate eklendi")
								}
							}
							return
						}
					}
				}
			}()
		}
	}

	// SDP exchange yap (invitation code içinden veya gRPC üzerinden)
	// NOT: Connect metodu her zaman YENİ bir Offer oluşturur.
	// Bu nedenle metadata'daki eski SDP Answer'ı ASLA kullanmamalıyız.
	// Eski Answer, eski Offer'a aittir ve yeni Offer ile çalışmaz.
	
	// gRPC üzerinden SDP exchange yap
	grpcAddress, ok := peer.Metadata["grpc_address"]
	if !ok || grpcAddress == "" {
		log.Printf("⚠️ gRPC adresi ve SDP answer bulunamadı, SDP exchange yapılamıyor: %s", peer.DeviceID[:8])
		log.Printf("   ℹ️ Invitation code içinde SDP answer olmalı veya gRPC adresi verilmeli")
		// Connection'ı map'e ekle (SDP exchange olmadan)
		m.connections[peer.DeviceID] = webrtcConn
		log.Printf("✅ WebRTC connection oluşturuldu (SDP exchange bekleniyor): %s", peer.DeviceID[:8])
	} else {
			// gRPC client oluştur ve SDP exchange yap (geriye uyumluluk)
			log.Printf("📡 gRPC üzerinden SDP exchange başlatılıyor (geriye uyumluluk): %s -> %s", peer.DeviceID[:8], grpcAddress)
			
			// gRPC connection oluştur
			log.Printf("🔌 gRPC client oluşturuluyor: %s", grpcAddress)
			grpcConn, err := grpc.NewClient(grpcAddress, 
				grpc.WithTransportCredentials(insecure.NewCredentials()),
			)
			if err != nil {
				log.Printf("❌ gRPC client oluşturulamadı: %v (connection devam edecek)", err)
				m.connections[peer.DeviceID] = webrtcConn
				return webrtcConn, nil
			}
			defer grpcConn.Close()
			log.Printf("✅ gRPC client bağlantısı kuruldu: %s", grpcAddress)

			// Peer service client oluştur
			peerClient := pb.NewPeerServiceClient(grpcConn)

			// Offer'ı gönder
			exchangeReq := &pb.ExchangeSDPRequest{
				PeerId:  m.deviceID, // Kendi device ID'mizi gönderiyoruz
				SdpType: "offer",
				Sdp:     offer.SDP, // SDP string
			}

			log.Printf("📤 SDP offer gönderiliyor: %s -> %s (SDP uzunluk: %d)", 
				peer.DeviceID[:8], grpcAddress, len(exchangeReq.Sdp))
			
			// Timeout ekle (30 saniye)
			exchangeCtx, cancel := context.WithTimeout(ctx, 30*time.Second)
			defer cancel()
			
			log.Printf("⏳ ExchangeSDP RPC çağrısı başlatılıyor (timeout: 30s)...")
			exchangeResp, err := peerClient.ExchangeSDP(exchangeCtx, exchangeReq)
			if err != nil {
				log.Printf("❌ SDP exchange hatası: %v (connection devam edecek)", err)
				log.Printf("   Hata detayı: %T - %s", err, err.Error())
				m.connections[peer.DeviceID] = webrtcConn
				return webrtcConn, nil
			}
			
			log.Printf("📥 SDP exchange yanıtı alındı: success=%v, type=%s, SDP uzunluk=%d", 
				exchangeResp.Status.Success, exchangeResp.SdpType, len(exchangeResp.Sdp))

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
					log.Printf("✅ SDP answer gRPC'den alındı ve set edildi: %s", peer.DeviceID[:8])
				}
			}
	}
	
	return webrtcConn, nil
}
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
func (m *WebRTCConnectionManager) SetOnFileDelete(callback func(peerID, fileID string)) {
	m.onFileDelete = callback
}

// SetOnConnectionLost connection lost callback'ini ayarlar
func (m *WebRTCConnectionManager) SetOnConnectionLost(callback func(peerID string)) {
	m.onConnectionLost = callback
}

// SetOnConnectionEstablished connection established callback'ini ayarlar
func (m *WebRTCConnectionManager) SetOnConnectionEstablished(callback func(conn transport.Connection)) {
	m.onConnectionEstablished = callback
}

// SetOnConnectionRequestedCallback connection requested callback'ini ayarlar
func (m *WebRTCConnectionManager) SetOnConnectionRequestedCallback(callback func(deviceID, deviceName string)) {
	m.onConnectionRequested = callback
}

// SetOnPeerIDUpdated peer ID updated callback'ini ayarlar
func (m *WebRTCConnectionManager) SetOnPeerIDUpdated(callback func(oldID, newID, newName string)) {
	m.onPeerIDUpdated = callback
}

// AddPendingPeer adds a pending peer (waiting for Connect)
func (m *WebRTCConnectionManager) AddPendingPeer(deviceID string, peer *WebRTCPeer) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.pendingPeers[deviceID] = peer
}

// GetPendingPeer gets and removes a pending peer
func (m *WebRTCConnectionManager) GetPendingPeer(deviceID string) *WebRTCPeer {
	m.mu.Lock()
	defer m.mu.Unlock()
	if peer, ok := m.pendingPeers[deviceID]; ok {
		delete(m.pendingPeers, deviceID)
		return peer
	}
	return nil
}

// GetPendingConnections bekleyen bağlantı isteklerini döner
func (m *WebRTCConnectionManager) GetPendingConnections() []*PendingConnection {
	m.pendingMu.RLock()
	defer m.pendingMu.RUnlock()

	result := make([]*PendingConnection, 0, len(m.pendingConns))
	for _, pending := range m.pendingConns {
		result = append(result, pending)
	}

	return result
}

// AddPendingConnection pending connection ekler (ExchangeSDP'den çağrılacak)
func (m *WebRTCConnectionManager) AddPendingConnection(deviceID, deviceName, sdpOffer string) *PendingConnection {
	m.pendingMu.Lock()
	defer m.pendingMu.Unlock()

	// Zaten pending connection varsa, mevcut olanı döndür
	if existing, exists := m.pendingConns[deviceID]; exists {
		return existing
	}

	pending := &PendingConnection{
		DeviceID:   deviceID,
		DeviceName: deviceName,
		SDPOffer:   sdpOffer,
		Timestamp:  time.Now(),
		ResponseCh: make(chan bool, 1),
	}

	m.pendingConns[deviceID] = pending

	// Callback çağır (UI'a bildir)
	if m.onConnectionRequested != nil {
		m.onConnectionRequested(deviceID, deviceName)
	}

	log.Printf("🔔 WAN bağlantı isteği eklendi: %s (%s)", deviceName, deviceID[:8])

	return pending
}

// AcceptPendingConnection pending connection'ı onaylar
func (m *WebRTCConnectionManager) AcceptPendingConnection(deviceID string) error {
	m.pendingMu.Lock()
	_, exists := m.pendingConns[deviceID]
	if exists {
		delete(m.pendingConns, deviceID)
	}
	m.pendingMu.Unlock()

	if !exists {
		return fmt.Errorf("pending connection bulunamadı: %s", deviceID[:8])
	}

	// Connection'ı bul ve accept gönder
	m.mu.RLock()
	conn, connExists := m.connections[deviceID]
	m.mu.RUnlock()

	if !connExists {
		return fmt.Errorf("aktif bağlantı bulunamadı: %s", deviceID[:8])
	}

	return conn.AcceptConnection()
}

// RejectPendingConnection pending connection'ı reddeder
func (m *WebRTCConnectionManager) RejectPendingConnection(deviceID string) error {
	m.pendingMu.Lock()
	_, exists := m.pendingConns[deviceID]
	if exists {
		delete(m.pendingConns, deviceID)
	}
	m.pendingMu.Unlock()

	if !exists {
		return fmt.Errorf("pending connection bulunamadı: %s", deviceID[:8])
	}

	// Connection'ı bul ve reject gönder
	m.mu.RLock()
	conn, connExists := m.connections[deviceID]
	m.mu.RUnlock()

	if !connExists {
		return fmt.Errorf("aktif bağlantı bulunamadı: %s", deviceID[:8])
	}

	return conn.RejectConnection()
}

// AcceptConnection bağlantı isteğini kabul eder
func (m *WebRTCConnectionManager) AcceptConnection(deviceID string) error {
	m.mu.RLock()
	conn, exists := m.connections[deviceID]
	m.mu.RUnlock()
	
	if !exists {
		return fmt.Errorf("bağlantı bulunamadı: %s", deviceID)
	}
	
	return conn.AcceptConnection()
}

// RejectConnection bağlantı isteğini reddeder
func (m *WebRTCConnectionManager) RejectConnection(deviceID string) error {
	m.mu.RLock()
	conn, exists := m.connections[deviceID]
	m.mu.RUnlock()
	
	if !exists {
		return fmt.Errorf("bağlantı bulunamadı: %s", deviceID)
	}
	
	return conn.RejectConnection()
}

// RegisterInvitation pending invitation'ı kaydeder
func (m *WebRTCConnectionManager) RegisterInvitation(code string, peer *WebRTCPeer) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.pendingInvitations[code] = peer
	log.Printf("📝 Pending invitation kaydedildi (code: %s)", code)
	
	// Timeout ekle (1 saat sonra temizle)
	go func() {
		time.Sleep(1 * time.Hour)
		m.mu.Lock()
		if p, exists := m.pendingInvitations[code]; exists {
			p.Close()
			delete(m.pendingInvitations, code)
			log.Printf("⏰ Pending invitation zaman aşımı (code: %s)", code)
		}
		m.mu.Unlock()
	}()
}

// RegisterConnection connection'ı kaydeder (AddPeerByInvitation'dan çağrılır)
func (m *WebRTCConnectionManager) RegisterConnection(deviceID string, conn *WebRTCConnection) {
	m.mu.Lock()
	defer m.mu.Unlock()
	
	// Callback'leri bağla
	conn.SetOnConnectionRequested(func(remoteDeviceID, remoteDeviceName string) {
		// Connection map'i güncelle (Eski ID -> Yeni ID)
		m.mu.Lock()
		if _, exists := m.connections[deviceID]; exists {
			delete(m.connections, deviceID)
			m.connections[remoteDeviceID] = conn
			log.Printf("🔄 Connection ID güncellendi: %s -> %s", deviceID, remoteDeviceID)
		}
		m.mu.Unlock()
		
		// Connection ID'sini güncelle
		conn.SetPeerID(remoteDeviceID)
		
		// Callback çağır
		if m.onPeerIDUpdated != nil {
			m.onPeerIDUpdated(deviceID, remoteDeviceID, remoteDeviceName)
		}
		
		m.AddPendingConnection(remoteDeviceID, remoteDeviceName, "")
	})
	
	conn.SetOnConnectionAccepted(func(remoteDeviceID, remoteDeviceName string) {
		// Connection map'i güncelle (Eski ID -> Yeni ID)
		m.mu.Lock()
		if _, exists := m.connections[deviceID]; exists {
			delete(m.connections, deviceID)
			m.connections[remoteDeviceID] = conn
			log.Printf("🔄 Connection ID güncellendi (Accepted): %s -> %s", deviceID, remoteDeviceID)
		}
		m.mu.Unlock()
		
		// Connection ID'sini güncelle
		conn.SetPeerID(remoteDeviceID)
		
		// Callback çağır
		if m.onPeerIDUpdated != nil {
			m.onPeerIDUpdated(deviceID, remoteDeviceID, remoteDeviceName)
		}
	})
	
	if m.chunkHandler != nil {
		conn.SetChunkHandler(m.chunkHandler)
	}
	if m.onChunkReceived != nil {
		conn.SetOnChunkReceived(m.onChunkReceived)
	}
	if m.onTransferCancel != nil {
		conn.SetOnTransferCancel(m.onTransferCancel)
	}
	if m.onFileDelete != nil {
		conn.SetOnFileDelete(m.onFileDelete)
	}
	
	m.connections[deviceID] = conn
	
	shortID := deviceID
	if len(deviceID) > 8 {
		shortID = deviceID[:8]
	}
	log.Printf("✅ WebRTC connection kaydedildi: %s (Handshake bekleniyor)", shortID)
	
	// Callback çağır
	if m.onConnectionEstablished != nil {
		m.onConnectionEstablished(conn)
	}
}

// HandleAnswer SDP answer'ı işler
func (m *WebRTCConnectionManager) HandleAnswer(deviceID, deviceName, answerSDP string, iceCandidates []ICECandidate) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	
	if len(m.pendingInvitations) == 0 {
		return fmt.Errorf("bekleyen invitation bulunamadı")
	}
	
	log.Printf("🔍 HandleAnswer: %d pending invitation var, answer deneniyor...", len(m.pendingInvitations))
	
	var matchedPeer *WebRTCPeer
	var matchedCode string
	
	for code, peer := range m.pendingInvitations {
		// Answer'ı set etmeyi dene
		answerDesc := webrtc.SessionDescription{
			Type: webrtc.SDPTypeAnswer,
			SDP:  answerSDP,
		}
		
		// Debug: SDP içindeki candidate'leri logla
		log.Printf("🔍 HandleAnswer: SDP Answer Candidates:")
		lines := strings.Split(answerSDP, "\r\n")
		for _, line := range lines {
			if strings.HasPrefix(line, "a=candidate") {
				log.Printf("  %s", line)
			}
		}
		
		if err := peer.SetRemoteDescription(answerDesc); err == nil {
			log.Printf("✅ Answer başarıyla eşleşti (code: %s)", code)
			matchedPeer = peer
			matchedCode = code
			break
		} else {
			log.Printf("⚠️ Answer bu invitation ile eşleşmedi: %v", err)
		}
	}
	
	if matchedPeer == nil {
		return fmt.Errorf("answer hiçbir invitation ile eşleşmedi")
	}
	
	// Eşleşen peer'ı invitation listesinden çıkar
	delete(m.pendingInvitations, matchedCode)

	// Remote ICE candidates'ı ekle
	if len(iceCandidates) > 0 {
		log.Printf("📡 %d remote ICE candidate ekleniyor...", len(iceCandidates))
		for _, cand := range iceCandidates {
			// WebRTC ICE candidate formatına çevir
			candidateStr := fmt.Sprintf("candidate:%s %d %s %s %s %d typ %s",
				cand.Type, cand.Priority, cand.Protocol,
				cand.IP.String(), cand.IP.String(), cand.Port, cand.Type)
			
			iceCandidate := webrtc.ICECandidateInit{
				Candidate: candidateStr,
			}
			
			if err := matchedPeer.AddICECandidate(iceCandidate); err != nil {
				log.Printf("⚠️ Remote ICE candidate eklenemedi: %v", err)
			}
		}
	}
	
	// Data channel handler'ı ekle (Answerer tarafı için)
	matchedPeer.SetOnDataChannel(func(dc *webrtc.DataChannel) {
		log.Printf("✅ WebRTC data channel açıldı (Answerer): %s", dc.Label())
		
		// WebRTCConnection oluştur
		conn := NewWebRTCConnection(deviceID, deviceName, m.deviceName, matchedPeer, dc)
		
		// Callback'leri bağla
		conn.SetOnConnectionRequested(func(deviceID, deviceName string) {
			m.AddPendingConnection(deviceID, deviceName, "")
		})
		if m.chunkHandler != nil {
			conn.SetChunkHandler(m.chunkHandler)
		}
		if m.onChunkReceived != nil {
			conn.SetOnChunkReceived(m.onChunkReceived)
		}
		if m.onTransferCancel != nil {
			conn.SetOnTransferCancel(m.onTransferCancel)
		}
		if m.onFileDelete != nil {
			conn.SetOnFileDelete(m.onFileDelete)
		}
		
		// Connection'ı kaydet
		m.mu.Lock()
		m.connections[deviceID] = conn
		m.mu.Unlock()
		
		log.Printf("✅ WebRTC connection otomatik oluşturuldu (Data Channel ile): %s", deviceID[:8])
		
		// Callback çağır
		if m.onConnectionEstablished != nil {
			m.onConnectionEstablished(conn)
		}
	})
	
	// Data channel oluştur (eğer yoksa - Offerer tarafı için)
	dc := matchedPeer.GetDataChannel()
	if dc == nil {
		// Data channel yoksa oluştur
		var err error
		dc, err = matchedPeer.CreateDataChannel("aether-chunks", true)
		if err != nil {
			log.Printf("⚠️ Data channel oluşturulamadı: %v", err)
		}
	}
	
	// WebRTCConnection oluşturma! Sadece pending peer olarak ekle.
	// Kullanıcı "Connect" dediğinde bu peer kullanılacak.
	m.pendingPeers[deviceID] = matchedPeer
	
	log.Printf("✅ Pending peer eklendi (Connect bekleniyor): %s", deviceID[:8])
	
	return nil
}

// GetDataChannel data channel'ı döner
func (c *WebRTCConnection) GetDataChannel() *webrtc.DataChannel {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.dataChannel
}

// GetState connection state döner
func (c *WebRTCConnection) GetState() webrtc.PeerConnectionState {
	if c.webrtcPeer == nil {
		return webrtc.PeerConnectionStateClosed
	}
	return c.webrtcPeer.GetConnectionState()
}

// GetICEConnectionState ICE connection state döner
func (c *WebRTCConnection) GetICEConnectionState() webrtc.ICEConnectionState {
	if c.webrtcPeer == nil {
		return webrtc.ICEConnectionStateClosed
	}
	return c.webrtcPeer.GetICEConnectionState()
}

// WebRTCConnection WebRTC data channel connection implementasyonu
type WebRTCConnection struct {
	peerID      string
	peerName    string
	localDeviceName string // Kendi ismimiz (Accept mesajında göndermek için)
	webrtcPeer  *WebRTCPeer
	dataChannel *webrtc.DataChannel
	protocol    *lan.Protocol
	
	connected   bool
	isHandshakeComplete bool
	mu          sync.RWMutex
	chunkHandler func(chunkHash string) ([]byte, error)
	connectedAt time.Time
	
	// Callbacks
	onChunkReceived  func(peerID, fileID, chunkHash string, chunkData []byte, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) error
	onTransferCancel func(peerID, fileID string)
	onFileDelete     func(peerID, fileID string)
	onConnectionRequested func(deviceID, deviceName string)
	onConnectionAccepted  func(deviceID, deviceName string)

	// Fragmentation
	fragmentBuffer map[string]*fragmentAssembler
	fragmentMu     sync.Mutex
}

type fragmentAssembler struct {
	totalFragments int
	receivedCount  int
	data           [][]byte
	lastUpdate     time.Time
}

// NewWebRTCConnection yeni WebRTC connection oluşturur
func NewWebRTCConnection(peerID, peerName, localDeviceName string, webrtcPeer *WebRTCPeer, dataChannel *webrtc.DataChannel) *WebRTCConnection {
	conn := &WebRTCConnection{
		peerID:          peerID,
		peerName:        peerName,
		localDeviceName: localDeviceName,
		webrtcPeer:      webrtcPeer,
		dataChannel:     dataChannel,
		protocol:        lan.NewProtocol(),
		connected:       false,
		isHandshakeComplete: false,
		connectedAt:     time.Now(),
		fragmentBuffer:  make(map[string]*fragmentAssembler),
	}
	
	// Data channel callback'lerini ayarla
	// Data channel callback'lerini ayarla
	if dataChannel != nil {
		conn.setupDataChannel(dataChannel)
	}

	// Peer connection state change callback'ini ayarla
	webrtcPeer.SetOnConnectionStateChange(func(state webrtc.PeerConnectionState) {
		conn.mu.Lock()
		conn.connected = (state == webrtc.PeerConnectionStateConnected)
		conn.mu.Unlock()
		
		if state == webrtc.PeerConnectionStateConnected {
			shortID := peerID
			if len(peerID) > 8 {
				shortID = peerID[:8]
			}
			log.Printf("✅ WebRTC connection state connected: %s", shortID)
		} else if state == webrtc.PeerConnectionStateFailed || state == webrtc.PeerConnectionStateClosed {
			shortID := peerID
			if len(peerID) > 8 {
				shortID = peerID[:8]
			}
			log.Printf("🔌 WebRTC connection state disconnected: %s (%s)", shortID, state.String())
		}
	})
	
	// Eğer zaten bağlıysa state'i güncelle
	if webrtcPeer.IsConnected() {
		conn.mu.Lock()
		conn.connected = true
		conn.mu.Unlock()
	}
	
	// OnDataChannel callback'ini ayarla (Answerer tarafı için)
	webrtcPeer.SetOnDataChannel(func(dc *webrtc.DataChannel) {
		conn.mu.Lock()
		// Eğer data channel henüz yoksa veya kapalıysa yenisini kullan
		if conn.dataChannel == nil {
			conn.dataChannel = dc
			conn.mu.Unlock()
			conn.setupDataChannel(dc)
			log.Printf("✅ Data channel alındı ve ayarlandı: %s", peerID[:8])
		} else {
			conn.mu.Unlock()
			shortID := peerID
			if len(peerID) > 8 {
				shortID = peerID[:8]
			}
			log.Printf("ℹ️ Ekstra data channel yoksayıldı: %s", shortID)
		}
	})
	
	return conn
}

// setupDataChannel data channel callback'lerini ayarlar
func (c *WebRTCConnection) setupDataChannel(dc *webrtc.DataChannel) {
	onOpenLogic := func() {
		c.mu.Lock()
		c.connected = true
		c.mu.Unlock()
		shortID := c.peerID
		if len(c.peerID) > 8 {
			shortID = c.peerID[:8]
		}
		log.Printf("✅ WebRTC data channel açıldı: %s", shortID)
	}

	if dc.ReadyState() == webrtc.DataChannelStateOpen {
		onOpenLogic()
	} else {
		dc.OnOpen(onOpenLogic)
	}
	
	dc.OnClose(func() {
		c.mu.Lock()
		c.connected = false
		c.mu.Unlock()
		shortID := c.peerID
		if len(c.peerID) > 8 {
			shortID = c.peerID[:8]
		}
		log.Printf("🔌 WebRTC data channel kapandı: %s", shortID)
	})
	
	dc.OnError(func(err error) {
		shortID := c.peerID
		if len(c.peerID) > 8 {
			shortID = c.peerID[:8]
		}
		log.Printf("❌ WebRTC data channel hatası (%s): %v", shortID, err)
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
	case lan.MessageTypeFragment:
		c.handleFragment(payload)
	case lan.MessageTypeConnectionRequest:
		c.handleConnectionRequest(payload)
	case lan.MessageTypeConnectionAccept:
		c.handleConnectionAccept(payload)
	case lan.MessageTypeConnectionReject:
		c.handleConnectionReject(payload)
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
	
	if c.dataChannel != nil {
		if err := c.dataChannel.Send(pongData); err != nil {
			log.Printf("⚠️ Pong gönderilemedi: %v", err)
		}
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
	// Eğer mesaj boyutu 60KB'dan büyükse parçalayarak gönder
	if len(frame) > 60*1024 {
		if err := c.sendFragmentedMessage(ctx, frame); err != nil {
			return fmt.Errorf("chunk (fragmented) gönderilemedi: %w", err)
		}
	} else {
		if err := dc.Send(frame); err != nil {
			return fmt.Errorf("chunk gönderilemedi: %w", err)
		}
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
	return time.Since(startTime), nil
}


// handlePong pong mesajını işler
func (c *WebRTCConnection) handlePong(payload []byte) {
	// Pong alındı, logla
	log.Printf("✅ Pong alındı: %s", c.peerID[:8])
}

// AcceptConnection bağlantıyı kabul eder ve karşı tarafa bildirir
func (c *WebRTCConnection) AcceptConnection() error {
	// Accept mesajı gönder
	acceptData, err := c.protocol.EncodeConnectionAccept(c.peerID, c.localDeviceName)
	if err != nil {
		return err
	}
	
	if c.dataChannel != nil {
		if err := c.dataChannel.Send(acceptData); err != nil {
			return err
		}
	}
	
	c.mu.Lock()
	c.isHandshakeComplete = true
	c.mu.Unlock()
	
	// Callback tetikle (Manager'ın onConnectionEstablished'ını çağırır)
	if c.onConnectionAccepted != nil {
		c.onConnectionAccepted(c.peerID, c.peerName)
	}
	
	log.Printf("✅ Bağlantı kabul edildi ve aktif: %s", c.peerID[:8])
	return nil
}

// RejectConnection bağlantıyı reddeder ve karşı tarafa bildirir
func (c *WebRTCConnection) RejectConnection() error {
	// Reject mesajı gönder
	rejectData, err := c.protocol.EncodeConnectionReject(c.peerID)
	if err != nil {
		return err
	}
	
	if c.dataChannel != nil {
		if err := c.dataChannel.Send(rejectData); err != nil {
			return err
		}
	}
	
	log.Printf("❌ Bağlantı reddedildi: %s", c.peerID[:8])
	return nil
}

// handleConnectionRequest connection request mesajını işler
func (c *WebRTCConnection) handleConnectionRequest(payload []byte) {
	deviceID, deviceName, err := c.protocol.DecodeConnectionRequestPayload(payload)
	if err != nil {
		log.Printf("⚠️ Connection request parse edilemedi: %v", err)
		return
	}
	
	c.mu.Lock()
	c.peerName = deviceName
	c.mu.Unlock()
	
	log.Printf("📥 Handshake isteği alındı: %s (%s)", deviceName, deviceID[:8])
	
	if c.onConnectionRequested != nil {
		c.onConnectionRequested(deviceID, deviceName)
	}
}

// handleConnectionAccept connection accept mesajını işler
func (c *WebRTCConnection) handleConnectionAccept(payload []byte) {
	deviceID, deviceName, err := c.protocol.DecodeConnectionAcceptPayload(payload)
	if err != nil {
		log.Printf("⚠️ Connection accept parse edilemedi: %v", err)
		return
	}
	
	log.Printf("✅ Handshake kabul edildi: %s (%s)", deviceID[:8], deviceName)
	
	c.mu.Lock()
	c.isHandshakeComplete = true
	if deviceName != "" {
		c.peerName = deviceName
	}
	c.mu.Unlock()
	
	if c.onConnectionAccepted != nil {
		c.onConnectionAccepted(deviceID, deviceName)
	}
}

// handleConnectionReject connection reject mesajını işler
func (c *WebRTCConnection) handleConnectionReject(payload []byte) {
	deviceID, err := c.protocol.DecodeConnectionRejectPayload(payload)
	if err != nil {
		log.Printf("⚠️ Connection reject parse edilemedi: %v", err)
		return
	}
	
	log.Printf("❌ Handshake reddedildi: %s", deviceID[:8])
	// Bağlantıyı kapatabiliriz veya kullanıcıya bildirebiliriz
}

// SetOnConnectionAccepted connection accepted callback'ini ayarlar
func (c *WebRTCConnection) SetOnConnectionAccepted(callback func(deviceID, deviceName string)) {
	c.onConnectionAccepted = callback
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

	shortID := c.peerID
	if len(c.peerID) > 8 {
		shortID = c.peerID[:8]
	}
	log.Printf("🔌 WebRTC bağlantısı kapatıldı: %s", shortID)
	return nil
}

// GetPeerID peer ID döner
func (c *WebRTCConnection) GetPeerID() string {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.peerID
}

// SetPeerID peer ID günceller
func (c *WebRTCConnection) SetPeerID(id string) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.peerID = id
}

// GetAddress adres döner
func (c *WebRTCConnection) GetAddress() string {
	shortID := c.peerID
	if len(c.peerID) > 8 {
		shortID = c.peerID[:8]
	}
	return "webrtc://" + shortID
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
	return c.connected && c.isHandshakeComplete
}

// GetTransportType transport tipini döner
func (c *WebRTCConnection) GetTransportType() transport.TransportType {
	return transport.TransportTypeWAN
}

// GetConnectionTime bağlantı zamanını döner
func (c *WebRTCConnection) GetConnectionTime() time.Time {
	return c.connectedAt
}

// SetOnConnectionRequested callback'i ayarlar
func (c *WebRTCConnection) SetOnConnectionRequested(callback func(deviceID, deviceName string)) {
	c.onConnectionRequested = callback
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

// GetProtocol protocol handler'ı döner
func (c *WebRTCConnection) GetProtocol() *lan.Protocol {
	return c.protocol
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

// handleFragment parçalanmış mesajı işler
func (c *WebRTCConnection) handleFragment(payload []byte) {
	if len(payload) < 24 {
		log.Printf("⚠️ Fragment payload çok kısa: %d", len(payload))
		return
	}

	messageID := string(payload[:16])
	fragmentIndex := binary.BigEndian.Uint32(payload[16:20])
	totalFragments := binary.BigEndian.Uint32(payload[20:24])
	data := payload[24:]

	c.fragmentMu.Lock()
	defer c.fragmentMu.Unlock()

	assembler, exists := c.fragmentBuffer[messageID]
	if !exists {
		assembler = &fragmentAssembler{
			totalFragments: int(totalFragments),
			receivedCount:  0,
			data:           make([][]byte, totalFragments),
			lastUpdate:     time.Now(),
		}
		c.fragmentBuffer[messageID] = assembler
	}

	if int(fragmentIndex) >= assembler.totalFragments {
		log.Printf("⚠️ Geçersiz fragment index: %d (total: %d)", fragmentIndex, assembler.totalFragments)
		return
	}

	if assembler.data[fragmentIndex] == nil {
		assembler.data[fragmentIndex] = data
		assembler.receivedCount++
		assembler.lastUpdate = time.Now()
	}

	// Tüm parçalar geldiyse birleştir ve işle
	if assembler.receivedCount == assembler.totalFragments {
		// Mesajı birleştir
		var fullMessage []byte
		for _, part := range assembler.data {
			fullMessage = append(fullMessage, part...)
		}

		// Buffer'dan temizle
		delete(c.fragmentBuffer, messageID)
		
		// Kilidi aç ki handleIncomingMessage deadlock yapmasın (recursive call)
		c.fragmentMu.Unlock()
		
		// Birleşmiş mesajı işle
		c.handleIncomingMessage(fullMessage)
		
		// Kilidi tekrar al (defer unlock için)
		c.fragmentMu.Lock()
	}
}

// sendFragmentedMessage mesajı parçalara bölüp gönderir
func (c *WebRTCConnection) sendFragmentedMessage(ctx context.Context, data []byte) error {
	const maxFragmentSize = 60 * 1024 // 60KB (64KB limit için güvenli marj)
	
	if len(data) <= maxFragmentSize {
		// Parçalamaya gerek yok, direkt gönder (ama caller zaten bunu kontrol etmeli)
		// Ancak bu metod sadece parçalama için çağrılmalı, o yüzden caller'ın sorumluluğunda
		// Biz yine de kontrol edelim, eğer küçükse direkt gönderemeyiz çünkü caller "MessageTypeFragment" bekliyor olabilir mi?
		// Hayır, caller normal mesaj gönderemiyorsa burayı çağırır.
		// Ama eğer buraya geldiyse, karşı taraf "Fragment" bekliyor demektir.
		// O yüzden tek parça bile olsa fragment olarak sarmalayabiliriz veya direkt gönderebiliriz.
		// WebRTC'de mesaj tipi header'da olduğu için, eğer sığarsa direkt göndermek daha mantıklı.
		// AMA, bu metod "büyük mesajı gönder" amacı taşıyor.
		// Eğer caller "SendChunkWithFileInfo" ise ve data > 64KB ise burayı çağırır.
		return fmt.Errorf("mesaj boyutu küçük, parçalamaya gerek yok")
	}

	totalFragments := (len(data) + maxFragmentSize - 1) / maxFragmentSize
	// UUID string is 36 bytes. Let's use 16 bytes raw UUID.
	uuidObj := uuid.New()
	messageIDBytes, _ := uuidObj.MarshalBinary() // 16 bytes

	for i := 0; i < totalFragments; i++ {
		start := i * maxFragmentSize
		end := start + maxFragmentSize
		if end > len(data) {
			end = len(data)
		}
		chunkData := data[start:end]

		// Header oluştur: [MessageID(16)][Index(4)][Total(4)]
		header := make([]byte, 24)
		copy(header[:16], messageIDBytes)
		binary.BigEndian.PutUint32(header[16:20], uint32(i))
		binary.BigEndian.PutUint32(header[20:24], uint32(totalFragments))

		// Payload oluştur
		payload := append(header, chunkData...)

		// Mesaj tipi ekle (Protocol frame olarak encode et)
		frame, err := c.protocol.EncodeFrame(lan.MessageTypeFragment, payload)
		if err != nil {
			return fmt.Errorf("fragment encode edilemedi: %w", err)
		}

		// Gönder
		c.mu.RLock()
		dc := c.dataChannel
		c.mu.RUnlock()

		if dc == nil {
			return fmt.Errorf("data channel yok")
		}

		if err := dc.Send(frame); err != nil {
			return fmt.Errorf("fragment %d/%d gönderilemedi: %w", i+1, totalFragments, err)
		}
		
		// Rate limiting (congestion control için biraz bekle)
		// WebRTC buffer dolabilir
		if dc.BufferedAmount() > 1024*1024 { // 1MB buffer
			time.Sleep(10 * time.Millisecond)
		}
	}

	return nil
}

// getString map'ten string değer alır
func getString(m map[string]interface{}, key string) string {
	if val, ok := m[key].(string); ok {
		return val
	}
	return ""
}

