package signaling

import "encoding/json"

// MessageType mesaj tipleri
type MessageType string

const (
	MsgJoin      MessageType = "join"
	MsgOffer     MessageType = "offer"
	MsgAnswer    MessageType = "answer"
	MsgCandidate MessageType = "candidate"
	MsgError     MessageType = "error"
)

// Message signaling mesajı
type Message struct {
	Type    MessageType     `json:"type"`
	Payload json.RawMessage `json:"payload,omitempty"`
	RoomID  string          `json:"roomId,omitempty"`
}

// JoinPayload odaya katılma verisi
type JoinPayload struct {
	RoomID string `json:"roomId"`
}

// OfferPayload SDP offer verisi
type OfferPayload struct {
	SDP string `json:"sdp"`
}

// AnswerPayload SDP answer verisi
type AnswerPayload struct {
	SDP string `json:"sdp"`
}

// CandidatePayload ICE candidate verisi
type CandidatePayload struct {
	Candidate string `json:"candidate"` // JSON stringified candidate
}
