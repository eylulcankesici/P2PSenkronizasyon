# 🌐 Aether P2P Ağ Mimarisi

## 🎯 Genel Bakış

Aether P2P sistemi **2 aşamalı** bir yaklaşımla tasarlanmıştır:

### **Aşama 1: LAN (Local Area Network)** ✅ ŞİMDİ
- mDNS/Bonjour ile peer keşfi
- Direkt TCP bağlantıları
- Şifrelenmemiş transfer (local güvenli)
- Basit NAT traversal gerekmez

### **Aşama 2: WAN (Wide Area Network)** 🔮 GELECEK
- STUN/TURN sunucuları
- NAT traversal (hole punching)
- TLS/DTLS şifreleme
- Relay server desteği
- WebRTC data channels

---

## 🏗️ SOLID Prensiplerine Uygun Mimari

### **1. Transport Abstraction Layer** (Interface Segregation + Dependency Inversion)

```
┌─────────────────────────────────────────────────────────┐
│            Transport Interface (Abstract)               │
│  • Discovery                                            │
│  • Connection                                           │
│  • DataTransfer                                         │
└─────────────────────────────────────────────────────────┘
                        │
        ┌───────────────┴────────────────┐
        │                                │
┌───────▼──────────┐          ┌──────────▼─────────┐
│  LAN Transport   │          │  WAN Transport     │
│  (Şimdi)         │          │  (Gelecek)         │
│                  │          │                    │
│  • mDNS          │          │  • STUN/TURN       │
│  • TCP           │          │  • WebRTC          │
│  • No encryption │          │  • TLS/DTLS        │
└──────────────────┘          └────────────────────┘
```

### **2. Katman Yapısı**

```
┌────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                      │
│  gRPC API: PeerService, P2PDataService                     │
└────────────────────────────────────────────────────────────┘
                         │
┌────────────────────────▼───────────────────────────────────┐
│                    APPLICATION LAYER                       │
│  Use Cases:                                                │
│  • PeerDiscoveryUseCase                                    │
│  • ChunkTransferUseCase                                    │
│  • SyncCoordinationUseCase                                 │
└────────────────────────────────────────────────────────────┘
                         │
┌────────────────────────▼───────────────────────────────────┐
│                      DOMAIN LAYER                          │
│  Interfaces:                                               │
│  • TransportProvider (Discovery, Connection, Transfer)     │
│  • PeerRepository                                          │
│  • ChunkRepository                                         │
└────────────────────────────────────────────────────────────┘
                         │
┌────────────────────────▼───────────────────────────────────┐
│                 INFRASTRUCTURE LAYER                       │
│  LAN Implementation:                                       │
│  • LANDiscoveryService (mDNS)                             │
│  • TCPConnectionManager                                    │
│  • ChunkTransferProtocol                                   │
└────────────────────────────────────────────────────────────┘
```

---

## 🔌 Transport Interface Design

### **TransportProvider Interface**

```go
type TransportProvider interface {
    // Discovery
    StartDiscovery(ctx context.Context) error
    StopDiscovery() error
    GetDiscoveredPeers() []*DiscoveredPeer
    
    // Connection
    Connect(ctx context.Context, peer *DiscoveredPeer) (Connection, error)
    Disconnect(conn Connection) error
    GetConnections() []Connection
    
    // Lifecycle
    Start(ctx context.Context) error
    Stop() error
    GetTransportType() TransportType
}

type Connection interface {
    // Data Transfer
    SendChunk(ctx context.Context, chunkHash string, data []byte) error
    RequestChunk(ctx context.Context, chunkHash string) ([]byte, error)
    SendMetadata(ctx context.Context, metadata *FileMetadata) error
    
    // Connection Info
    GetPeerID() string
    GetAddress() string
    GetLatency() time.Duration
    IsConnected() bool
    
    // Lifecycle
    Close() error
}
```

---

## 📡 LAN Transport Implementation

### **1. mDNS Discovery (Zeroconf)**

**Service Name**: `_aether._tcp.local.`

**TXT Records**:
```
device_id=7f29eb76-16d2-46d4-a372-8f429ae65563
device_name=Aether Desktop
version=1.0.0
port=50052
```

**Go Library**: `github.com/hashicorp/mdns`

### **2. TCP Connection Protocol**

**Protocol Stack**:
```
Application Layer:  Protobuf Messages
Transport Layer:    TCP (port 50052-50100)
Network Layer:      IPv4/IPv6
```

**Message Format**:
```
┌────────────────────────────────────────┐
│ Magic Bytes (4 bytes): 0xAE 0x54 0x48 0x52 │
├────────────────────────────────────────┤
│ Version (2 bytes): 0x01 0x00          │
├────────────────────────────────────────┤
│ Message Type (2 bytes)                │
├────────────────────────────────────────┤
│ Payload Length (4 bytes)              │
├────────────────────────────────────────┤
│ Protobuf Payload (variable)           │
├────────────────────────────────────────┤
│ Checksum (4 bytes): CRC32             │
└────────────────────────────────────────┘
```

**Message Types**:
- `0x0001`: Handshake
- `0x0002`: ChunkRequest
- `0x0003`: ChunkResponse
- `0x0004`: FileMetadata
- `0x0005`: Ping
- `0x0006`: Pong

### **3. Connection Flow**

```
Peer A                          Peer B
  │                               │
  │────── mDNS Announce ─────────▶│
  │                               │
  │◀───── mDNS Response ──────────│
  │                               │
  │────── TCP SYN ───────────────▶│
  │◀───── TCP SYN-ACK ───────────│
  │────── TCP ACK ───────────────▶│
  │                               │
  │────── Handshake (DeviceID) ──▶│
  │◀───── Handshake OK ───────────│
  │                               │
  │────── ChunkRequest ──────────▶│
  │◀───── ChunkResponse ──────────│
  │                               │
```

---

## 🔐 Security Model

### **LAN (Aşama 1)**
- ✅ Local network içinde güvenli kabul edilir
- ✅ Device ID doğrulaması
- ✅ Checksum ile veri bütünlüğü
- ❌ Şifreleme YOK (local network overhead'i önlemek için)

### **WAN (Aşama 2 - Gelecek)**
- 🔒 TLS 1.3 şifreleme
- 🔒 Peer certificate doğrulaması
- 🔒 End-to-end chunk encryption (optional)
- 🔒 Replay attack koruması

---

## 🎯 SOLID Prensipleri Uygulaması

### **S - Single Responsibility Principle**
- `LANDiscoveryService`: Sadece mDNS keşif
- `TCPConnectionManager`: Sadece TCP bağlantı yönetimi
- `ChunkTransferProtocol`: Sadece chunk transfer protokolü
- `PeerDiscoveryUseCase`: Sadece peer keşif iş mantığı

### **O - Open/Closed Principle**
```go
// Mevcut kod değişmeden yeni transport eklenebilir
transports := []TransportProvider{
    NewLANTransport(config),        // Şimdi
    NewWANTransport(config),        // Gelecekte eklenecek
    NewRelayTransport(config),      // Gelecekte eklenecek
}
```

### **L - Liskov Substitution Principle**
```go
// Her transport implementation aynı interface'i karşılar
var transport TransportProvider
if config.IsLAN() {
    transport = NewLANTransport(config)
} else {
    transport = NewWANTransport(config)
}
// Kullanım her iki durumda da aynı
```

### **I - Interface Segregation Principle**
```go
// Büyük interface yerine küçük interface'ler
type Discovery interface { ... }
type ConnectionManager interface { ... }
type DataTransfer interface { ... }

// Tam özellikli transport
type TransportProvider interface {
    Discovery
    ConnectionManager
    DataTransfer
}
```

### **D - Dependency Inversion Principle**
```go
// Use case, concrete implementation değil interface'e bağımlı
type ChunkTransferUseCase struct {
    transport TransportProvider  // Interface
    chunkRepo repository.ChunkRepository // Interface
}
```

---

## 🚀 Implementation Roadmap

### **Phase 1: LAN Foundation** (Şimdi) ✅
- [x] TransportProvider interface
- [x] LANDiscoveryService (mDNS)
- [x] TCPConnectionManager
- [x] ChunkTransferProtocol
- [x] PeerDiscoveryUseCase
- [x] ChunkTransferUseCase
- [x] gRPC Handlers
- [x] Integration Tests

### **Phase 2: WAN Support** (Gelecek) 🔮
- [ ] STUN/TURN client
- [ ] NAT traversal
- [ ] WebRTC data channels
- [ ] TLS encryption
- [ ] Relay server fallback
- [ ] Performance optimization

---

## 📊 Performance Targets

### **LAN**
- Discovery time: < 2 seconds
- Connection latency: < 10 ms
- Chunk transfer: > 100 MB/s (Gigabit LAN)
- Max concurrent peers: 10

### **WAN (Future)**
- Discovery time: < 5 seconds
- Connection latency: < 100 ms
- Chunk transfer: > 10 MB/s (depends on bandwidth)
- Max concurrent peers: 5

---

## 🧪 Testing Strategy

### **Unit Tests**
- Transport interface mocking
- Protocol encoding/decoding
- Connection state machine

### **Integration Tests**
- Local loopback (127.0.0.1)
- LAN simulation (2+ devices)
- Chunk transfer end-to-end

### **E2E Tests**
- Multi-device sync
- Network interruption recovery
- Large file transfer (> 1 GB)

---

## 📚 Dependencies

### **LAN**
- `github.com/hashicorp/mdns` - mDNS discovery
- `github.com/google/uuid` - Device ID generation
- Standard `net` package - TCP sockets

### **WAN (Future)**
- `github.com/pion/webrtc/v3` - WebRTC
- `github.com/pion/stun` - STUN client
- `github.com/pion/turn` - TURN client
- `crypto/tls` - TLS encryption

---

## 🎓 Key Design Decisions

1. **Interface-first design**: Tüm transport'lar aynı interface
2. **Protocol buffer messages**: Efficient binary serialization
3. **TCP over UDP**: LAN'da güvenilirlik > hız
4. **No encryption in LAN**: Performance optimization
5. **Device ID as identity**: UUID-based peer identification
6. **Chunk-level transfer**: Fine-grained sync control

---

## 🔄 Future Extensions

- [ ] BitTorrent-style piece selection algorithm
- [ ] Bandwidth management (QoS)
- [ ] Multi-path transfer (bonding)
- [ ] IPv6 support
- [ ] Mobile platform support (iOS/Android)
- [ ] Browser-based WebRTC peer

---

**Mimari Prensibi**: "Write for LAN, extend to WAN" 🚀

