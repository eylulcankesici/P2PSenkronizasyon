package entity

import (
	"time"
)

// PeerStatus peer'in durumunu temsil eder
type PeerStatus string

const (
	PeerStatusOnline  PeerStatus = "online"
	PeerStatusOffline PeerStatus = "offline"
	PeerStatusUnknown PeerStatus = "unknown"
)

// Peer ağdaki bir cihazı/peer'ı temsil eder
type Peer struct {
	DeviceID       string
	Name           string
	KnownAddresses []string   // Bilinen IP:Port adresleri
	IsTrusted      bool       // Güvenilir peer mi?
	LastSeen       time.Time  // Son görülme zamanı
	Status         PeerStatus
	PublicKey      string     // P2P kimlik doğrulama için
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

// NewPeer yeni bir Peer oluşturur
func NewPeer(deviceID, name string) *Peer {
	now := time.Now()
	return &Peer{
		DeviceID:       deviceID,
		Name:           name,
		KnownAddresses: make([]string, 0),
		IsTrusted:      false,
		Status:         PeerStatusUnknown,
		CreatedAt:      now,
		UpdatedAt:      now,
		LastSeen:       now,
	}
}

// Validate peer'in geçerliliğini kontrol eder
func (p *Peer) Validate() error {
	if p.DeviceID == "" {
		return ErrInvalidDeviceID
	}
	
	if p.Name == "" {
		return ErrInvalidPeerName
	}
	
	return nil
}

// UpdateLastSeen son görülme zamanını günceller
func (p *Peer) UpdateLastSeen() {
	p.LastSeen = time.Now()
	p.UpdatedAt = time.Now()
	p.Status = PeerStatusOnline
}

// MarkOffline peer'i offline olarak işaretler
func (p *Peer) MarkOffline() {
	p.Status = PeerStatusOffline
	p.UpdatedAt = time.Now()
}

// Trust peer'i güvenilir olarak işaretler
func (p *Peer) Trust() {
	p.IsTrusted = true
	p.UpdatedAt = time.Now()
}

// Untrust peer'i güvenilmez olarak işaretler
func (p *Peer) Untrust() {
	p.IsTrusted = false
	p.UpdatedAt = time.Now()
}

// AddAddress peer'a yeni bir adres ekler
func (p *Peer) AddAddress(address string) {
	for _, addr := range p.KnownAddresses {
		if addr == address {
			return // Zaten var
		}
	}
	p.KnownAddresses = append(p.KnownAddresses, address)
	p.UpdatedAt = time.Now()
}

// IsOnline peer'in online olup olmadığını kontrol eder
func (p *Peer) IsOnline() bool {
	return p.Status == PeerStatusOnline
}

// IsRecentlySeen peer'in son 5 dakika içinde görülüp görülmediğini kontrol eder
func (p *Peer) IsRecentlySeen(threshold time.Duration) bool {
	return time.Since(p.LastSeen) <= threshold
}




