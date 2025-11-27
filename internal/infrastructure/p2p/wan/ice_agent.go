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
	}

	if len(iceURLs) == 0 {
		log.Println("⚠️ Hiç STUN/TURN server yok, sadece host candidate'lar kullanılacak")
	}

	// ICE agent config
	config := &ice.AgentConfig{
		NetworkTypes: []ice.NetworkType{ice.NetworkTypeUDP4}, // Şimdilik sadece UDP4
		Urls:         iceURLs,
		CandidateTypes: []ice.CandidateType{
			ice.CandidateTypeHost,        // Local IP
			ice.CandidateTypeServerReflexive, // STUN
			ice.CandidateTypeRelay,       // TURN
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

	// ICECandidate'ları ice.Candidate'a çevir ve ekle
	// NOT: Gerçek implementasyonda SDP formatından parse edilecek
	// Şimdilik basit bir placeholder

	log.Printf("📥 %d remote candidate ayarlandı", len(candidates))
	return nil
}

// StartConnection remote peer ile ICE connection başlatır
func (a *iceAgentImpl) StartConnection(ctx context.Context, remoteCandidates []ICECandidate) (*ICEConnection, error) {
	a.mu.Lock()
	defer a.mu.Unlock()

	if a.closed || a.agent == nil {
		return nil, fmt.Errorf("ICE agent hazır değil")
	}

	// ICE connection oluştur
	// NOT: Gerçek implementasyonda remote candidate'lar kullanılacak
	// Şimdilik placeholder

	log.Println("🔌 ICE connection başlatılıyor...")

	// Placeholder connection
	return &ICEConnection{
		Connected: false,
	}, fmt.Errorf("ICE connection implementasyonu yakında eklenecek")
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

