package wan

import (
	"context"
	"fmt"
	"log"
	"net"
	"sync"
	"time"

	"github.com/aether/sync/internal/config"
	"github.com/pion/ice/v2"
)

// ICEAgent ICE agent interface'i
type ICEAgent interface {
	StartGathering(ctx context.Context) error
	GetLocalCandidates() ([]ICECandidate, error)
	SetRemoteCandidates(candidates []ICECandidate) error
	StartConnection(ctx context.Context, remoteCandidates []ICECandidate) (*ICEConnection, error)
	Close() error
}

// ICECandidate ICE candidate bilgisi
type ICECandidate struct {
	Type     string // "host", "srflx", "relay"
	IP       net.IP
	Port     int
	Priority int64
	Protocol string // "udp", "tcp"
}

// ICEConnection ICE bağlantısı
type ICEConnection struct {
	LocalAddress  *net.UDPAddr
	RemoteAddress *net.UDPAddr
	Connected     bool
	Conn          *ice.Conn
}

// iceAgentImpl ICE agent implementasyonu
type iceAgentImpl struct {
	agent            *ice.Agent
	stunServers      []string
	turnServers      []config.TURNServerConfig
	portRange        config.PortRange
	gatheringTimeout time.Duration
	mu               sync.RWMutex
	candidates       []ICECandidate
	closed           bool
}

// NewICEAgent yeni ICE agent oluşturur
func NewICEAgent(
	stunServers []string,
	turnServers []config.TURNServerConfig,
	portRange config.PortRange,
	gatheringTimeout time.Duration,
) ICEAgent {
	return &iceAgentImpl{
		stunServers:      stunServers,
		turnServers:      turnServers,
		portRange:        portRange,
		gatheringTimeout: gatheringTimeout,
		candidates:       []ICECandidate{},
		closed:           false,
	}
}

// StartGathering ICE candidate gathering başlatır
func (a *iceAgentImpl) StartGathering(ctx context.Context) error {
	a.mu.Lock()
	defer a.mu.Unlock()

	if a.closed {
		return fmt.Errorf("ICE agent kapalı")
	}

	// STUN server'ları ICE URL formatına çevir
	iceURLs := []*ice.URL{}
	for _, stunURL := range a.stunServers {
		url, err := parseICEURL(stunURL)
		if err != nil {
			log.Printf("⚠️ STUN URL parse edilemedi: %s - %v", stunURL, err)
			continue
		}
		iceURLs = append(iceURLs, url)
	}

	// TURN server'ları ekle
	turnCount := 0
	for _, turnServer := range a.turnServers {
		url, err := parseICEURL(turnServer.URL)
		if err != nil {
			log.Printf("⚠️ TURN URL parse edilemedi: %s - %v", turnServer.URL, err)
			continue
		}
		// TURN authentication bilgilerini ekle
		url.Username = turnServer.Username
		url.Password = turnServer.Password
		iceURLs = append(iceURLs, url)
		turnCount++
		log.Printf("✅ TURN server eklendi: %s (username: %s)", turnServer.URL, turnServer.Username)
	}

	if len(iceURLs) == 0 {
		log.Println("⚠️ Hiç STUN/TURN server yok, sadece host candidate'lar kullanılacak")
	} else {
		log.Printf("📡 ICE server yapılandırması: %d STUN, %d TURN server", len(a.stunServers), turnCount)
	}

	// ICE agent config
	config := &ice.AgentConfig{
		NetworkTypes: []ice.NetworkType{ice.NetworkTypeUDP4}, // Şimdilik sadece UDP4
		Urls:         iceURLs,
		CandidateTypes: []ice.CandidateType{
			ice.CandidateTypeHost,            // Local IP
			ice.CandidateTypeServerReflexive, // STUN
			ice.CandidateTypeRelay,           // TURN
		},
		PortMin: uint16(a.portRange.Min),
		PortMax: uint16(a.portRange.Max),
	}

	// ICE agent oluştur
	agent, err := ice.NewAgent(config)
	if err != nil {
		return fmt.Errorf("ICE agent oluşturulamadı: %w", err)
	}

	a.agent = agent

	// Candidate gathering callback
	agent.OnCandidate(func(candidate ice.Candidate) {
		if candidate == nil {
			log.Println("✅ ICE candidate gathering tamamlandı")
			return
		}

		// Network type'ı protocol olarak kullan (UDP/TCP)
		protocol := "udp"
		if candidate.NetworkType() == ice.NetworkTypeTCP4 || candidate.NetworkType() == ice.NetworkTypeTCP6 {
			protocol = "tcp"
		}

		ic := ICECandidate{
			Type:     candidate.Type().String(),
			IP:       net.ParseIP(candidate.Address()),
			Port:     candidate.Port(),
			Priority: int64(candidate.Priority()),
			Protocol: protocol,
		}

		a.mu.Lock()
		a.candidates = append(a.candidates, ic)
		a.mu.Unlock()

		log.Printf("📡 ICE candidate bulundu: type=%s, addr=%s:%d, priority=%d",
			ic.Type, ic.IP.String(), ic.Port, ic.Priority)
	})

	// Gathering timeout
	gatherCtx, cancel := context.WithTimeout(ctx, a.gatheringTimeout)
	defer cancel()

	// Gathering başlat
	if err := agent.GatherCandidates(); err != nil {
		return fmt.Errorf("candidate gathering başlatılamadı: %w", err)
	}

	// Gathering'in tamamlanmasını bekle
	<-gatherCtx.Done()
	if gatherCtx.Err() == context.DeadlineExceeded {
		log.Printf("⚠️ ICE gathering timeout (%v), mevcut candidate'lar kullanılacak", a.gatheringTimeout)
	}

	log.Printf("✅ ICE candidate gathering tamamlandı: %d candidate", len(a.candidates))
	return nil
}

// GetLocalCandidates toplanan local candidate'ları döner
func (a *iceAgentImpl) GetLocalCandidates() ([]ICECandidate, error) {
	a.mu.RLock()
	defer a.mu.RUnlock()

	if a.closed {
		return nil, fmt.Errorf("ICE agent kapalı")
	}

	// Copy candidates
	result := make([]ICECandidate, len(a.candidates))
	copy(result, a.candidates)

	return result, nil
}

// SetRemoteCandidates remote candidate'ları ayarlar
func (a *iceAgentImpl) SetRemoteCandidates(candidates []ICECandidate) error {
	a.mu.Lock()
	defer a.mu.Unlock()

	if a.closed || a.agent == nil {
		return fmt.Errorf("ICE agent hazır değil")
	}

	// Remote candidate'ları Pion ICE formatına çevir
	// NOT: Gerçek implementasyonda SDP formatından parse edilecek
	// Şimdilik ICECandidate struct'ından ice.Candidate oluşturulması gerekir
	// Ancak Pion ICE API'si direkt candidate eklemeyi desteklemiyor,
	// bunun yerine SDP exchange veya manual candidate ekleme gerekiyor

	// ICE agent'ın remote candidate'ları alması için SDP exchange gerekiyor
	// Şimdilik basit bir placeholder - gerçek implementasyonda
	// SetRemoteCredentials + SDP offer/answer exchange yapılacak

	log.Printf("📥 %d remote candidate alındı (SDP exchange ile eklenecek)", len(candidates))

	// NOT: Remote candidate'lar ICE agent'a SDP üzerinden eklenir
	// Bu metod şimdilik bilgilendirme amaçlı
	return nil
}

// StartConnection remote peer ile ICE connection başlatır
func (a *iceAgentImpl) StartConnection(ctx context.Context, remoteCandidates []ICECandidate) (*ICEConnection, error) {
	a.mu.Lock()
	defer a.mu.Unlock()

	if a.closed || a.agent == nil {
		return nil, fmt.Errorf("ICE agent hazır değil")
	}

	log.Println("🔌 ICE connection başlatılıyor...")

	// ICE connection için username fragment ve password oluştur
	// (Her ICE session için unique olmalı)
	localUFrag, _, err := a.agent.GetLocalUserCredentials()
	if err != nil {
		return nil, fmt.Errorf("local credentials alınamadı: %w", err)
	}

	log.Printf("📋 ICE credentials: ufrag=%s", localUFrag)

	// NOT: Gerçek ICE connection için:
	// 1. Remote peer'dan SDP offer alınmalı (veya biz offer göndermeliyiz)
	// 2. SDP'deki remote candidate'lar ICE agent'a eklenmeli
	// 3. ICE connection attempt başlatılmalı
	//
	// Şimdilik minimal bir implementasyon - gerçek bağlantı için
	// WebRTC peer connection veya manuel ICE connection handling gerekiyor

	// ICE connection attempt başlat
	// NOT: Pion ICE API'si direkt connection attempt'i desteklemiyor
	// WebRTC peer connection veya manual handling gerekiyor
	//
	// Şimdilik placeholder connection döndürüyoruz
	// Gerçek implementasyonda WebRTC peer connection ile entegre edilecek

	log.Printf("⚠️ ICE connection başlatıldı (minimal implementasyon)")

	// Placeholder connection - gerçek bağlantı WebRTC peer connection ile yapılacak
	return &ICEConnection{
		Connected: false, // Bağlantı henüz kurulmadı (WebRTC peer connection ile kurulacak)
	}, nil
}

// Close ICE agent'ı kapatır
func (a *iceAgentImpl) Close() error {
	a.mu.Lock()
	defer a.mu.Unlock()

	if a.closed {
		return nil
	}

	a.closed = true

	if a.agent != nil {
		if err := a.agent.Close(); err != nil {
			return err
		}
		a.agent = nil
	}

	log.Println("✅ ICE agent kapatıldı")
	return nil
}

// parseICEURL STUN/TURN URL'sini ice.URL'ye çevirir
func parseICEURL(urlString string) (*ice.URL, error) {
	// Format: "stun:host:port" veya "turn:host:port"
	url, err := ice.ParseURL(urlString)
	if err != nil {
		return nil, fmt.Errorf("ICE URL parse edilemedi: %w", err)
	}

	return url, nil
}
