package lan

import (
	"bytes"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"hash/crc32"
	"log"
	"time"

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
	MessageTypeHandshake         = 0x0001
	MessageTypeChunkRequest      = 0x0002
	MessageTypeChunkResponse     = 0x0003
	MessageTypeMetadata          = 0x0004
	MessageTypePing              = 0x0005
	MessageTypePong              = 0x0006
	MessageTypeConnectionRequest = 0x0007
	MessageTypeConnectionAccept  = 0x0008
	MessageTypeConnectionReject  = 0x0009
	MessageTypeTransferCancel    = 0x000A // Transfer iptal bildirimi
	MessageTypeFileDelete        = 0x000B // Dosya silme bildirimi (peer-to-peer)
	MessageTypeFragment          = 0x000C // WebRTC için parçalanmış mesaj
	MessageTypeTransferFinish    = 0x000D // Transfer tamamlandı bildirimi
	MessageTypeTransferFinishAck = 0x000E // Transfer tamamlandı onayı
	MessageTypeFileRename        = 0x000F // Dosya yeniden adlandırma (peer-to-peer)
	MessageTypeFolderCreate      = 0x0010 // Klasör oluşturma (peer-to-peer)

	// Frame sizes
	HeaderSize     = 16               // Magic(4) + Version(2) + Type(2) + Length(4) + CRC(4)
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
	if err := binary.Write(buf, binary.BigEndian, uint16(ProtocolVersion)); err != nil {
		return nil, fmt.Errorf("version yazılamadı: %w", err)
	}

	// Message type
	if err := binary.Write(buf, binary.BigEndian, messageType); err != nil {
		return nil, fmt.Errorf("message type yazılamadı: %w", err)
	}

	// Payload length
	if err := binary.Write(buf, binary.BigEndian, uint32(len(payload))); err != nil {
		return nil, fmt.Errorf("payload length yazılamadı: %w", err)
	}

	// Payload
	if _, err := buf.Write(payload); err != nil {
		return nil, fmt.Errorf("payload yazılamadı: %w", err)
	}

	// CRC32 checksum (tüm frame üzerinden)
	crc := crc32.ChecksumIEEE(buf.Bytes())
	if err := binary.Write(buf, binary.BigEndian, crc); err != nil {
		return nil, fmt.Errorf("CRC yazılamadı: %w", err)
	}

	frame := buf.Bytes()

	// Debug: Encode edilen frame'in ilk byte'larını logla
	if messageType == MessageTypeConnectionRequest {
		debugLen := len(frame)
		if debugLen > 30 {
			debugLen = 30
		}
		log.Printf("🔧 Encode edilen frame (ilk %d byte): %x", debugLen, frame[:debugLen])
	}

	return frame, nil
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
		return 0, nil, fmt.Errorf("geçersiz magic bytes: %02x %02x %02x %02x", magic[0], magic[1], magic[2], magic[3])
	}

	// Version
	var version uint16
	binary.Read(buf, binary.BigEndian, &version)
	if version != uint16(ProtocolVersion) {
		// Debug: frame'in ilk birkaç byte'ını logla
		debugLen := len(frame)
		if debugLen > 20 {
			debugLen = 20
		}
		debugBytes := make([]byte, debugLen)
		copy(debugBytes, frame)
		return 0, nil, fmt.Errorf("desteklenmeyen protocol version: 0x%04x (expected: 0x%04x), frame start: %x", version, ProtocolVersion, debugBytes)
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

// EncodeChunkResponse chunk response mesajı oluşturur (pull-based için)
func (p *Protocol) EncodeChunkResponse(chunkHash string, chunkData []byte) ([]byte, error) {
	return p.EncodeChunkResponseWithFileInfo(chunkHash, chunkData, "", 0, 0, "", "", pb.SyncMode_SYNC_MODE_UNSPECIFIED, pb.SyncMode_SYNC_MODE_UNSPECIFIED)
}

// EncodeChunkResponseWithFileInfo chunk response mesajı oluşturur (push-based sync için)
func (p *Protocol) EncodeChunkResponseWithFileInfo(chunkHash string, chunkData []byte, fileID string, chunkIndex, totalChunks int, fileName, folderName string, senderSyncMode, receiverSyncMode pb.SyncMode) ([]byte, error) {
	resp := &pb.ChunkResponse{
		Status: &pb.Status{
			Success: true,
			Message: "OK",
			Code:    200,
		},
		ChunkHash:        chunkHash,
		ChunkData:        chunkData,
		ChunkSize:        int64(len(chunkData)),
		FileId:           fileID,
		ChunkIndex:       int32(chunkIndex),
		TotalChunks:      int32(totalChunks),
		FileName:         fileName,
		FolderName:       folderName,       // Folder adı eklendi (receiver için)
		SenderSyncMode:   senderSyncMode,   // Gönderen tarafın sync mode'u
		ReceiverSyncMode: receiverSyncMode, // Alıcı tarafın sync mode'u
	}

	// Log kapatıldı (spam önleme)
	// log.Printf("  🔧 Encode: FileId='%s', FileName='%s', FolderName='%s', ChunkIndex=%d, TotalChunks=%d", fileID, fileName, folderName, chunkIndex, totalChunks)

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

// connectionRequest connection request için basit struct
type connectionRequest struct {
	DeviceID   string `json:"device_id"`
	DeviceName string `json:"device_name"`
	Timestamp  int64  `json:"timestamp"`
}

// connectionResponse connection response için basit struct
type connectionResponse struct {
	Accepted   bool   `json:"accepted"`
	Message    string `json:"message"`
	DeviceID   string `json:"device_id"`
	DeviceName string `json:"device_name,omitempty"` // İsim eklendi
}

// EncodeConnectionRequest connection request mesajı oluşturur
func (p *Protocol) EncodeConnectionRequest(deviceID, deviceName string) ([]byte, error) {
	req := &connectionRequest{
		DeviceID:   deviceID,
		DeviceName: deviceName,
		Timestamp:  time.Now().Unix(),
	}

	payload, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("JSON marshal hatası: %w", err)
	}

	return p.EncodeFrame(MessageTypeConnectionRequest, payload)
}

// DecodeConnectionRequest connection request mesajını parse eder
// payload zaten DecodeFrame'den gelmiş olmalı (frame decode edilmiş değil)
func (p *Protocol) DecodeConnectionRequest(payload []byte) (string, string, error) {
	req := &connectionRequest{}
	if err := json.Unmarshal(payload, req); err != nil {
		return "", "", fmt.Errorf("JSON unmarshal hatası: %w", err)
	}

	return req.DeviceID, req.DeviceName, nil
}

// EncodeConnectionAccept connection accept mesajı oluşturur
func (p *Protocol) EncodeConnectionAccept(deviceID, deviceName string) ([]byte, error) {
	resp := &connectionResponse{
		Accepted:   true,
		Message:    "Bağlantı kabul edildi",
		DeviceID:   deviceID,
		DeviceName: deviceName,
	}

	payload, err := json.Marshal(resp)
	if err != nil {
		return nil, fmt.Errorf("JSON marshal hatası: %w", err)
	}

	return p.EncodeFrame(MessageTypeConnectionAccept, payload)
}

// DecodeConnectionAccept connection accept mesajını parse eder
func (p *Protocol) DecodeConnectionAccept(data []byte) (string, string, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return "", "", err
	}

	if messageType != MessageTypeConnectionAccept {
		return "", "", fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}

	resp := &connectionResponse{}
	if err := json.Unmarshal(payload, resp); err != nil {
		return "", "", fmt.Errorf("JSON unmarshal hatası: %w", err)
	}

	if !resp.Accepted {
		return "", "", fmt.Errorf("bağlantı reddedildi: %s", resp.Message)
	}

	return resp.DeviceID, resp.DeviceName, nil
}

// EncodeConnectionReject connection reject mesajı oluşturur
func (p *Protocol) EncodeConnectionReject(reason string) ([]byte, error) {
	resp := &connectionResponse{
		Accepted: false,
		Message:  reason,
	}

	payload, err := json.Marshal(resp)
	if err != nil {
		return nil, fmt.Errorf("JSON marshal hatası: %w", err)
	}

	return p.EncodeFrame(MessageTypeConnectionReject, payload)
}

// EncodeTransferCancel transfer iptal bildirimi oluşturur
func (p *Protocol) EncodeTransferCancel(fileID, reason string) ([]byte, error) {
	notif := &pb.TransferCancelNotification{
		FileId: fileID,
		Reason: reason,
	}

	payload, err := proto.Marshal(notif)
	if err != nil {
		return nil, fmt.Errorf("protobuf marshal hatası: %w", err)
	}

	return p.EncodeFrame(MessageTypeTransferCancel, payload)
}

// DecodeTransferCancel transfer iptal bildirimi parse eder
func (p *Protocol) DecodeTransferCancel(data []byte) (string, string, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return "", "", err
	}

	if messageType != MessageTypeTransferCancel {
		return "", "", fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}

	notif := &pb.TransferCancelNotification{}
	if err := proto.Unmarshal(payload, notif); err != nil {
		return "", "", fmt.Errorf("protobuf unmarshal hatası: %w", err)
	}

	return notif.FileId, notif.Reason, nil
}

// DecodeConnectionReject connection reject mesajını parse eder
func (p *Protocol) DecodeConnectionReject(data []byte) (string, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return "", err
	}

	if messageType != MessageTypeConnectionReject {
		return "", fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}

	resp := &connectionResponse{}
	if err := json.Unmarshal(payload, resp); err != nil {
		return "", fmt.Errorf("JSON unmarshal hatası: %w", err)
	}

	return resp.Message, nil
}

// EncodeFileDelete dosya silme bildirimini encode eder
func (p *Protocol) EncodeFileDelete(fileID string) ([]byte, error) {
	deleteMsg := struct {
		FileID string `json:"file_id"`
	}{
		FileID: fileID,
	}

	payload, err := json.Marshal(deleteMsg)
	if err != nil {
		return nil, fmt.Errorf("JSON marshal hatası: %w", err)
	}

	frame, err := p.EncodeFrame(MessageTypeFileDelete, payload)
	if err == nil {
		log.Printf("🗑️ EncodeFileDelete frame: %x (len=%d)", frame, len(frame))
	} else {
		log.Printf("⚠️ EncodeFileDelete hatası: %v", err)
	}
	return frame, err
}

// DecodeFileDelete dosya silme bildirimini parse eder
func (p *Protocol) DecodeFileDelete(data []byte) (string, error) {
	messageType, payload, err := p.DecodeFrame(data)
	if err != nil {
		return "", err
	}

	if messageType != MessageTypeFileDelete {
		return "", fmt.Errorf("beklenmeyen message type: 0x%04x", messageType)
	}

	deleteMsg := struct {
		FileID string `json:"file_id"`
	}{}

	if err := json.Unmarshal(payload, &deleteMsg); err != nil {
		return "", fmt.Errorf("JSON unmarshal hatası: %w", err)
	}

	return deleteMsg.FileID, nil
}

// DecodeConnectionRequestPayload connection request payload'ını parse eder
func (p *Protocol) DecodeConnectionRequestPayload(payload []byte) (string, string, error) {
	req := &connectionRequest{}
	if err := json.Unmarshal(payload, req); err != nil {
		return "", "", fmt.Errorf("JSON unmarshal hatası: %w", err)
	}

	return req.DeviceID, req.DeviceName, nil
}

// DecodeConnectionAcceptPayload connection accept payload'ını parse eder
func (p *Protocol) DecodeConnectionAcceptPayload(payload []byte) (string, string, error) {
	resp := &connectionResponse{}
	if err := json.Unmarshal(payload, resp); err != nil {
		return "", "", fmt.Errorf("JSON unmarshal hatası: %w", err)
	}

	if !resp.Accepted {
		return "", "", fmt.Errorf("bağlantı reddedildi: %s", resp.Message)
	}

	return resp.DeviceID, resp.DeviceName, nil
}

// DecodeConnectionRejectPayload connection reject payload'ını parse eder
func (p *Protocol) DecodeConnectionRejectPayload(payload []byte) (string, error) {
	resp := &connectionResponse{}
	if err := json.Unmarshal(payload, resp); err != nil {
		return "", fmt.Errorf("JSON unmarshal hatası: %w", err)
	}

	return resp.Message, nil
}

// DecodeTransferFinishAck transfer finish ack mesajını decode eder
func (p *Protocol) DecodeTransferFinishAck(payload []byte) (string, error) {
	msg := struct {
		FileID string `json:"file_id"`
	}{}

	if err := json.Unmarshal(payload, &msg); err != nil {
		return "", fmt.Errorf("transfer finish ack unmarshal hatası: %w", err)
	}

	return msg.FileID, nil
}

// EncodeFileRename dosya yeniden adlandırma mesajını encode eder
func (p *Protocol) EncodeFileRename(fileID, oldPath, newPath string) ([]byte, error) {
	msg := struct {
		FileID  string `json:"file_id"`
		OldPath string `json:"old_path"`
		NewPath string `json:"new_path"`
	}{
		FileID:  fileID,
		OldPath: oldPath,
		NewPath: newPath,
	}

	payload, err := json.Marshal(msg)
	if err != nil {
		return nil, fmt.Errorf("file rename marshal hatası: %w", err)
	}

	return p.EncodeFrame(MessageTypeFileRename, payload)
}

// DecodeFileRename dosya yeniden adlandırma mesajını decode eder
func (p *Protocol) DecodeFileRename(payload []byte) (string, string, string, error) {
	msg := struct {
		FileID  string `json:"file_id"`
		OldPath string `json:"old_path"`
		NewPath string `json:"new_path"`
	}{}

	if err := json.Unmarshal(payload, &msg); err != nil {
		return "", "", "", fmt.Errorf("file rename unmarshal hatası: %w", err)
	}

	return msg.FileID, msg.OldPath, msg.NewPath, nil
}

// EncodeFolderCreate klasör oluşturma mesajını encode eder
func (p *Protocol) EncodeFolderCreate(payload []byte) ([]byte, error) {
	return p.EncodeFrame(MessageTypeFolderCreate, payload)
}

// DecodeFolderCreate klasör oluşturma mesajını decode eder
func (p *Protocol) DecodeFolderCreate(payload []byte) (FolderCreatePayload, error) {
	var msg FolderCreatePayload
	if err := json.Unmarshal(payload, &msg); err != nil {
		return msg, fmt.Errorf("folder create payload decode edilemedi: %w", err)
	}
	return msg, nil
}

// FolderCreatePayload klasör oluşturma mesajı içeriği
type FolderCreatePayload struct {
	FolderID     string `json:"folder_id"`
	RelativePath string `json:"relative_path"`
}
