package lan

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"hash/crc32"

	"google.golang.org/protobuf/proto"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/domain/transport"
)

const (
	// Magic bytes: "AETH" in hex
	MagicByte1 = 0xAE
	MagicByte2 = 0x54
	MagicByte3 = 0x48
	MagicByte4 = 0x52
	
	// Protocol version
	ProtocolVersion = 0x0100 // 1.0
	
	// Message types
	MessageTypeHandshake      = 0x0001
	MessageTypeChunkRequest   = 0x0002
	MessageTypeChunkResponse  = 0x0003
	MessageTypeMetadata       = 0x0004
	MessageTypePing           = 0x0005
	MessageTypePong           = 0x0006
	MessageTypeConnectionRequest = 0x0007
	MessageTypeConnectionAccept = 0x0008
	MessageTypeConnectionReject = 0x0009
	
	// Frame sizes
	HeaderSize = 16 // Magic(4) + Version(2) + Type(2) + Length(4) + CRC(4)
	MaxPayloadSize = 10 * 1024 * 1024 // 10 MB
)

// Protocol Aether P2P binary protocol
// Frame format:
// +------+------+------+------+----------+
// | Magic| Ver  | Type | Len  | Payload  |
// | (4B) | (2B) | (2B) | (4B) | (var)    |
// +------+------+------+------+----------+
// | CRC32 (4B) - checksumof entire frame|
// +--------------------------------------+
type Protocol struct{}

// NewProtocol yeni protocol instance oluşturur
func NewProtocol() *Protocol {
	return &Protocol{}
}

// EncodeFrame mesajı binary frame'e encode eder
func (p *Protocol) EncodeFrame(messageType uint16, payload []byte) ([]byte, error) {
	if len(payload) > MaxPayloadSize {
		return nil, fmt.Errorf("payload çok büyük: %d > %d", len(payload), MaxPayloadSize)
	}
	
	buf := new(bytes.Buffer)
	
	// Magic bytes
	buf.WriteByte(MagicByte1)
	buf.WriteByte(MagicByte2)
	buf.WriteByte(MagicByte3)
	buf.WriteByte(MagicByte4)
	
	// Version
	binary.Write(buf, binary.BigEndian, ProtocolVersion)
	
	// Message type
	binary.Write(buf, binary.BigEndian, messageType)
	
	// Payload length
	binary.Write(buf, binary.BigEndian, uint32(len(payload)))
	
	// Payload
	buf.Write(payload)
	
	// CRC32 checksum (tüm frame üzerinden)
	crc := crc32.ChecksumIEEE(buf.Bytes())
	binary.Write(buf, binary.BigEndian, crc)
	
	return buf.Bytes(), nil
}

// DecodeFrame binary frame'i decode eder
func (p *Protocol) DecodeFrame(frame []byte) (messageType uint16, payload []byte, err error) {
	if len(frame) < HeaderSize {
		return 0, nil, fmt.Errorf("frame çok kısa: %d < %d", len(frame), HeaderSize)
	}
	
	buf := bytes.NewReader(frame)
	
	// Magic bytes kontrol
	magic := make([]byte, 4)
	buf.Read(magic)
	if magic[0] != MagicByte1 || magic[1] != MagicByte2 || 
	   magic[2] != MagicByte3 || magic[3] != MagicByte4 {
		return 0, nil, fmt.Errorf("geçersiz magic bytes")
	}
	
	// Version
	var version uint16
	binary.Read(buf, binary.BigEndian, &version)
	if version != ProtocolVersion {
		return 0, nil, fmt.Errorf("desteklenmeyen protocol version: 0x%04x", version)
	}
	
	// Message type
	binary.Read(buf, binary.BigEndian, &messageType)
	
	// Payload length
	var payloadLen uint32
	binary.Read(buf, binary.BigEndian, &payloadLen)
	
	if payloadLen > MaxPayloadSize {
		return 0, nil, fmt.Errorf("payload çok büyük: %d > %d", payloadLen, MaxPayloadSize)
	}
	
	// Payload
	payload = make([]byte, payloadLen)
	buf.Read(payload)
	
	// CRC32 checksum
	var receivedCRC uint32
	binary.Read(buf, binary.BigEndian, &receivedCRC)
	
	// CRC doğrulama
	calculatedCRC := crc32.ChecksumIEEE(frame[:len(frame)-4])
	if receivedCRC != calculatedCRC {
		return 0, nil, fmt.Errorf("CRC mismatch: received=0x%08x, calculated=0x%08x", receivedCRC, calculatedCRC)
	}
	
	return messageType, payload, nil
}

// EncodeChunkRequest chunk request mesajı oluşturur
func (p *Protocol) EncodeChunkRequest(chunkHash string) ([]byte, error) {
	req := &pb.ChunkRequest{
		ChunkHash: chunkHash,
	}
	
	payload, err := proto.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("protobuf marshal hatası: %w", err)
	}
	
	return p.EncodeFrame(MessageTypeChunkRequest, payload)
}

// DecodeChunkRequest chunk request mesajını parse eder
func (p *Protocol) DecodeChunkRequest(data []byte) (string, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return "", err
	}
	
	if messageType != MessageTypeChunkRequest {
		return "", fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}
	
	req := &pb.ChunkRequest{}
	if err := proto.Unmarshal(payload, req); err != nil {
		return "", fmt.Errorf("protobuf unmarshal hatası: %w", err)
	}
	
	return req.ChunkHash, nil
}

// EncodeChunkResponse chunk response mesajı oluşturur
func (p *Protocol) EncodeChunkResponse(chunkHash string, chunkData []byte) ([]byte, error) {
	resp := &pb.ChunkResponse{
		Status: &pb.Status{
			Success: true,
			Message: "OK",
			Code:    200,
		},
		ChunkHash: chunkHash,
		ChunkData: chunkData,
		ChunkSize: int64(len(chunkData)),
	}
	
	payload, err := proto.Marshal(resp)
	if err != nil {
		return nil, fmt.Errorf("protobuf marshal hatası: %w", err)
	}
	
	return p.EncodeFrame(MessageTypeChunkResponse, payload)
}

// DecodeChunkResponse chunk response mesajını parse eder
func (p *Protocol) DecodeChunkResponse(data []byte) (string, []byte, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return "", nil, err
	}
	
	if messageType != MessageTypeChunkResponse {
		return "", nil, fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}
	
	resp := &pb.ChunkResponse{}
	if err := proto.Unmarshal(payload, resp); err != nil {
		return "", nil, fmt.Errorf("protobuf unmarshal hatası: %w", err)
	}
	
	if !resp.Status.Success {
		return "", nil, fmt.Errorf("chunk response error: %s", resp.Status.Message)
	}
	
	return resp.ChunkHash, resp.ChunkData, nil
}

// EncodeMetadata metadata mesajı oluşturur
func (p *Protocol) EncodeMetadata(metadata *transport.FileMetadata) ([]byte, error) {
	req := &pb.FileMetadataRequest{
		FileId: metadata.FileID,
	}
	
	payload, err := proto.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("protobuf marshal hatası: %w", err)
	}
	
	return p.EncodeFrame(MessageTypeMetadata, payload)
}

// DecodeMetadata metadata mesajını parse eder
func (p *Protocol) DecodeMetadata(data []byte) (*transport.FileMetadata, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return nil, err
	}
	
	if messageType != MessageTypeMetadata {
		return nil, fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}
	
	req := &pb.FileMetadataRequest{}
	if err := proto.Unmarshal(payload, req); err != nil {
		return nil, fmt.Errorf("protobuf unmarshal hatası: %w", err)
	}
	
	// FileMetadata'yı oluştur (basitleştirilmiş)
	metadata := &transport.FileMetadata{
		FileID: req.FileId,
	}
	
	return metadata, nil
}

// EncodePing ping mesajı oluşturur
func (p *Protocol) EncodePing(deviceID string) ([]byte, error) {
	req := &pb.PingRequest{
		DeviceId:  deviceID,
		Timestamp: 0, // Client tarafında set edilecek
	}
	
	payload, err := proto.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("protobuf marshal hatası: %w", err)
	}
	
	return p.EncodeFrame(MessageTypePing, payload)
}

// DecodePing ping mesajını parse eder
func (p *Protocol) DecodePing(data []byte) (string, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return "", err
	}
	
	if messageType != MessageTypePing {
		return "", fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}
	
	req := &pb.PingRequest{}
	if err := proto.Unmarshal(payload, req); err != nil {
		return "", fmt.Errorf("protobuf unmarshal hatası: %w", err)
	}
	
	return req.DeviceId, nil
}

// EncodePong pong mesajı oluşturur
func (p *Protocol) EncodePong(deviceID string, latencyMs int64) ([]byte, error) {
	resp := &pb.PingResponse{
		Status: &pb.Status{
			Success: true,
			Message: "Pong",
			Code:    200,
		},
		Timestamp: 0,
		LatencyMs: latencyMs,
	}
	
	payload, err := proto.Marshal(resp)
	if err != nil {
		return nil, fmt.Errorf("protobuf marshal hatası: %w", err)
	}
	
	return p.EncodeFrame(MessageTypePong, payload)
}

// DecodePong pong mesajını parse eder
func (p *Protocol) DecodePong(data []byte) (int64, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return 0, err
	}
	
	if messageType != MessageTypePong {
		return 0, fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}
	
	resp := &pb.PingResponse{}
	if err := proto.Unmarshal(payload, resp); err != nil {
		return 0, fmt.Errorf("protobuf unmarshal hatası: %w", err)
	}
	
	return resp.LatencyMs, nil
}



