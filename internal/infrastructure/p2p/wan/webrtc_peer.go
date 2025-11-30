package wan

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/aether/sync/internal/config"
	"github.com/pion/webrtc/v3"
)

// WebRTCPeer WebRTC peer connection wrapper
// Pion WebRTC peer connection'ı yönetir
type WebRTCPeer struct {
	peerConnection *webrtc.PeerConnection
	dataChannel    *webrtc.DataChannel
	config         webrtc.Configuration
	
	// State
	mu          sync.RWMutex
	connected   bool
	connectedAt time.Time
	
	// Callbacks
	onConnectionStateChange func(webrtc.PeerConnectionState)
	onDataChannel           func(*webrtc.DataChannel)
	onICEConnectionState    func(webrtc.ICEConnectionState)
}

// NewWebRTCPeer yeni WebRTC peer oluşturur
func NewWebRTCPeer(config webrtc.Configuration) (*WebRTCPeer, error) {
	// SettingEngine oluştur ve timeout'ları ayarla
	settingEngine := webrtc.SettingEngine{}
	
	// ICE timeout'larını uzat (Manuel signaling için gerekli)
	// Disconnected: 3 dakika (kullanıcının kodu kopyalaması için)
	// Failed: 5 dakika
	// KeepAlive: 2 saniye (default)
	settingEngine.SetICETimeouts(3*time.Minute, 5*time.Minute, 2*time.Second)
	
	// API oluştur
	api := webrtc.NewAPI(webrtc.WithSettingEngine(settingEngine))

	// Peer connection oluştur
	peerConnection, err := api.NewPeerConnection(config)
	if err != nil {
		return nil, fmt.Errorf("peer connection oluşturulamadı: %w", err)
	}

	peer := &WebRTCPeer{
		peerConnection: peerConnection,
		config:         config,
		connected:      false,
	}

	// Connection state change callback
	peerConnection.OnConnectionStateChange(func(state webrtc.PeerConnectionState) {
		peer.mu.Lock()
		peer.connected = (state == webrtc.PeerConnectionStateConnected)
		peer.mu.Unlock()

		log.Printf("📡 WebRTC connection state: %s", state.String())

		if peer.onConnectionStateChange != nil {
			peer.onConnectionStateChange(state)
		}

		if state == webrtc.PeerConnectionStateFailed || state == webrtc.PeerConnectionStateClosed {
			peer.mu.Lock()
			peer.connected = false
			peer.mu.Unlock()
		}
	})

	// ICE connection state callback
	peerConnection.OnICEConnectionStateChange(func(state webrtc.ICEConnectionState) {
		log.Printf("🧊 ICE connection state: %s", state.String())

		if peer.onICEConnectionState != nil {
			peer.onICEConnectionState(state)
		}
	})

	// ICE candidate callback (Logging only)
	peerConnection.OnICECandidate(func(c *webrtc.ICECandidate) {
		if c == nil {
			return
		}
		log.Printf("🧊 ICE Candidate found: %s", c.String())
	})

	// Data channel callback (incoming)
	peerConnection.OnDataChannel(func(dc *webrtc.DataChannel) {
		log.Printf("📨 Incoming data channel: %s (id: %d)", dc.Label(), dc.ID())

		// Data channel callback'lerini ayarla
		dc.OnOpen(func() {
			log.Printf("✅ Data channel açıldı: %s", dc.Label())
		})

		dc.OnClose(func() {
			log.Printf("🔌 Data channel kapandı: %s", dc.Label())
		})

		dc.OnError(func(err error) {
			log.Printf("❌ Data channel hatası (%s): %v", dc.Label(), err)
		})

		if peer.onDataChannel != nil {
			peer.onDataChannel(dc)
		}
	})

	return peer, nil
}

// CreateDataChannel data channel oluşturur
func (p *WebRTCPeer) CreateDataChannel(label string, ordered bool) (*webrtc.DataChannel, error) {
	options := &webrtc.DataChannelInit{
		Ordered: &ordered,
	}

	dataChannel, err := p.peerConnection.CreateDataChannel(label, options)
	if err != nil {
		return nil, fmt.Errorf("data channel oluşturulamadı: %w", err)
	}

	// Data channel callback'lerini ayarla
	dataChannel.OnOpen(func() {
		log.Printf("✅ Data channel açıldı: %s", label)
	})

	dataChannel.OnClose(func() {
		log.Printf("🔌 Data channel kapandı: %s", label)
	})

	dataChannel.OnError(func(err error) {
		log.Printf("❌ Data channel hatası (%s): %v", label, err)
	})

	p.mu.Lock()
	p.dataChannel = dataChannel
	p.mu.Unlock()

	return dataChannel, nil
}

// CreateOffer SDP offer oluşturur
func (p *WebRTCPeer) CreateOffer(ctx context.Context) (webrtc.SessionDescription, error) {
	offer, err := p.peerConnection.CreateOffer(nil)
	if err != nil {
		return webrtc.SessionDescription{}, fmt.Errorf("offer oluşturulamadı: %w", err)
	}

	// Local description set et
	if err := p.peerConnection.SetLocalDescription(offer); err != nil {
		return webrtc.SessionDescription{}, fmt.Errorf("local description set edilemedi: %w", err)
	}

	// ICE gathering tamamlanmasını bekle
	ctx, cancel := context.WithTimeout(ctx, 20*time.Second)
	defer cancel()

	// Gather complete event'ini bekle
	gatherComplete := webrtc.GatheringCompletePromise(p.peerConnection)

	select {
	case <-gatherComplete:
		log.Println("✅ ICE gathering tamamlandı")
		// Updated offer'ı al (ICE candidates ile)
		offer = *p.peerConnection.LocalDescription()
	case <-ctx.Done():
		log.Printf("⚠️ ICE gathering timeout, mevcut offer kullanılıyor")
		if desc := p.peerConnection.LocalDescription(); desc != nil {
			offer = *desc
		}
	}

	return offer, nil
}

// CreateAnswer SDP answer oluşturur
func (p *WebRTCPeer) CreateAnswer(ctx context.Context) (webrtc.SessionDescription, error) {
	answer, err := p.peerConnection.CreateAnswer(nil)
	if err != nil {
		return webrtc.SessionDescription{}, fmt.Errorf("answer oluşturulamadı: %w", err)
	}

	// Local description set et
	if err := p.peerConnection.SetLocalDescription(answer); err != nil {
		return webrtc.SessionDescription{}, fmt.Errorf("local description set edilemedi: %w", err)
	}

	// ICE gathering tamamlanmasını bekle
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	gatherComplete := webrtc.GatheringCompletePromise(p.peerConnection)

	select {
	case <-gatherComplete:
		log.Println("✅ ICE gathering tamamlandı (answer)")
		answer = *p.peerConnection.LocalDescription()
	case <-ctx.Done():
		log.Printf("⚠️ ICE gathering timeout, mevcut answer kullanılıyor")
		if desc := p.peerConnection.LocalDescription(); desc != nil {
			answer = *desc
		}
	}

	return answer, nil
}

// SetRemoteDescription remote SDP description set eder
func (p *WebRTCPeer) SetRemoteDescription(desc webrtc.SessionDescription) error {
	return p.peerConnection.SetRemoteDescription(desc)
}

// AddICECandidate ICE candidate ekler
func (p *WebRTCPeer) AddICECandidate(candidate webrtc.ICECandidateInit) error {
	return p.peerConnection.AddICECandidate(candidate)
}

// GetLocalDescription local SDP description döner
func (p *WebRTCPeer) GetLocalDescription() *webrtc.SessionDescription {
	return p.peerConnection.LocalDescription()
}

// IsConnected bağlantı durumunu döner
func (p *WebRTCPeer) IsConnected() bool {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.connected
}

// GetConnectionState connection state döner
func (p *WebRTCPeer) GetConnectionState() webrtc.PeerConnectionState {
	return p.peerConnection.ConnectionState()
}

// GetICEConnectionState ICE connection state döner
func (p *WebRTCPeer) GetICEConnectionState() webrtc.ICEConnectionState {
	return p.peerConnection.ICEConnectionState()
}

// Close peer connection'ı kapatır
func (p *WebRTCPeer) Close() error {
	p.mu.Lock()
	defer p.mu.Unlock()

	if p.peerConnection != nil {
		if err := p.peerConnection.Close(); err != nil {
			return fmt.Errorf("peer connection kapatılamadı: %w", err)
		}
	}

	p.connected = false
	return nil
}

// GetDataChannel açık data channel'ı döner
func (p *WebRTCPeer) GetDataChannel() *webrtc.DataChannel {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.dataChannel
}

// SetDataChannel data channel'ı set eder
func (p *WebRTCPeer) SetDataChannel(dc *webrtc.DataChannel) {
	p.mu.Lock()
	defer p.mu.Unlock()
	p.dataChannel = dc
}

// SetOnConnectionStateChange callback'i ayarlar
func (p *WebRTCPeer) SetOnConnectionStateChange(callback func(webrtc.PeerConnectionState)) {
	p.onConnectionStateChange = callback
}

// SetOnDataChannel callback'i ayarlar
func (p *WebRTCPeer) SetOnDataChannel(callback func(*webrtc.DataChannel)) {
	p.onDataChannel = callback
}

// SetOnICEConnectionState callback'i ayarlar
func (p *WebRTCPeer) SetOnICEConnectionState(callback func(webrtc.ICEConnectionState)) {
	p.onICEConnectionState = callback
}

// CreateWebRTCConfiguration WebRTC configuration oluşturur
func CreateWebRTCConfiguration(stunServers []string, turnServers []config.TURNServerConfig, portRange config.PortRange) webrtc.Configuration {
	var iceservers []webrtc.ICEServer

	// STUN server'ları ekle
	for _, stunURL := range stunServers {
		iceservers = append(iceservers, webrtc.ICEServer{
			URLs: []string{stunURL},
		})
	}

	// TURN server'ları ekle
	for _, turnServer := range turnServers {
		iceservers = append(iceservers, webrtc.ICEServer{
			URLs:       []string{turnServer.URL},
			Username:   turnServer.Username,
			Credential: turnServer.Password,
		})
	}

	// WebRTC configuration oluştur
	config := webrtc.Configuration{
		ICEServers: iceservers,
	}

	// NOT: Port range ayarlaması Pion WebRTC v3'te farklı şekilde yapılabilir
	// Şimdilik default port range kullanılıyor
	// TODO: Port range ayarlaması eklenecek (gerekirse)

	return config
}

// SDPMessage SDP mesajı (JSON serialization için)
type SDPMessage struct {
	Type string `json:"type"` // "offer" veya "answer"
	SDP  string `json:"sdp"`  // SDP string
}

// EncodeSDP SDP'yi JSON'a çevirir
func EncodeSDP(desc webrtc.SessionDescription) ([]byte, error) {
	msg := SDPMessage{
		Type: desc.Type.String(),
		SDP:  desc.SDP,
	}
	return json.Marshal(msg)
}

// DecodeSDP JSON'dan SDP'yi parse eder
func DecodeSDP(data []byte) (webrtc.SessionDescription, error) {
	var msg SDPMessage
	if err := json.Unmarshal(data, &msg); err != nil {
		return webrtc.SessionDescription{}, err
	}

	var sdpType webrtc.SDPType
	switch msg.Type {
	case "offer":
		sdpType = webrtc.SDPTypeOffer
	case "answer":
		sdpType = webrtc.SDPTypeAnswer
	default:
		return webrtc.SessionDescription{}, fmt.Errorf("bilinmeyen SDP type: %s", msg.Type)
	}

	return webrtc.SessionDescription{
		Type: sdpType,
		SDP:  msg.SDP,
	}, nil
}

