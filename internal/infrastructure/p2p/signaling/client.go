package signaling

import (
	"encoding/json"
	"fmt"
	"log"
	"sync"
	"github.com/gorilla/websocket"
)

// SignalingClient signaling server client'ı
type SignalingClient struct {
	serverURL string
	conn      *websocket.Conn
	mu        sync.Mutex
	
	// Callbacks
	OnOffer     func(sdp string)
	OnAnswer    func(sdp string)
	OnCandidate func(candidate string)
	OnError     func(err error)
}

// NewSignalingClient yeni client oluşturur
func NewSignalingClient(serverURL string) *SignalingClient {
	return &SignalingClient{
		serverURL: serverURL,
	}
}

// Connect sunucuya bağlanır
func (c *SignalingClient) Connect() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	log.Printf("🔌 Signaling server'a bağlanılıyor: %s", c.serverURL)
	conn, _, err := websocket.DefaultDialer.Dial(c.serverURL, nil)
	if err != nil {
		return fmt.Errorf("bağlantı hatası: %w", err)
	}

	c.conn = conn
	
	// Mesaj dinlemeye başla
	go c.listen()
	
	return nil
}

// JoinRoom odaya katılır
func (c *SignalingClient) JoinRoom(roomID string) error {
	return c.send(MsgJoin, JoinPayload{RoomID: roomID}, roomID)
}

// SendOffer SDP offer gönderir
func (c *SignalingClient) SendOffer(sdp string) error {
	return c.send(MsgOffer, OfferPayload{SDP: sdp}, "")
}

// SendAnswer SDP answer gönderir
func (c *SignalingClient) SendAnswer(sdp string) error {
	return c.send(MsgAnswer, AnswerPayload{SDP: sdp}, "")
}

// SendCandidate ICE candidate gönderir
func (c *SignalingClient) SendCandidate(candidate string) error {
	return c.send(MsgCandidate, CandidatePayload{Candidate: candidate}, "")
}

// Close bağlantıyı kapatır
func (c *SignalingClient) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()
	
	if c.conn != nil {
		return c.conn.Close()
	}
	return nil
}

func (c *SignalingClient) send(msgType MessageType, payload interface{}, roomID string) error {
	c.mu.Lock()
	conn := c.conn
	c.mu.Unlock()

	if conn == nil {
		return fmt.Errorf("bağlantı yok")
	}

	data, err := json.Marshal(payload)
	if err != nil {
		return err
	}

	msg := Message{
		Type:    msgType,
		Payload: data,
		RoomID:  roomID,
	}

	return conn.WriteJSON(msg)
}

func (c *SignalingClient) listen() {
	defer c.Close()

	for {
		var msg Message
		err := c.conn.ReadJSON(&msg)
		if err != nil {
			log.Printf("⚠️ Signaling bağlantısı koptu: %v", err)
			if c.OnError != nil {
				c.OnError(err)
			}
			break
		}

		c.handleMessage(msg)
	}
}

func (c *SignalingClient) handleMessage(msg Message) {
	switch msg.Type {
	case MsgOffer:
		var payload OfferPayload
		if err := json.Unmarshal(msg.Payload, &payload); err == nil && c.OnOffer != nil {
			c.OnOffer(payload.SDP)
		}
	case MsgAnswer:
		var payload AnswerPayload
		if err := json.Unmarshal(msg.Payload, &payload); err == nil && c.OnAnswer != nil {
			c.OnAnswer(payload.SDP)
		}
	case MsgCandidate:
		var payload CandidatePayload
		if err := json.Unmarshal(msg.Payload, &payload); err == nil && c.OnCandidate != nil {
			c.OnCandidate(payload.Candidate)
		}
	case MsgError:
		var errorMsg string
		if err := json.Unmarshal(msg.Payload, &errorMsg); err == nil {
			log.Printf("❌ Signaling hatası: %s", errorMsg)
		}
	}
}
