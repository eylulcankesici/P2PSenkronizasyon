package main

import (
	"encoding/json"
	"log"
	"net/http"
	"sync"

	"github.com/gorilla/websocket"
)

// Message signaling mesajı
type Message struct {
	Type    string          `json:"type"`              // "join", "offer", "answer", "candidate", "error"
	Payload json.RawMessage `json:"payload,omitempty"` // Mesaj içeriği
	RoomID  string          `json:"roomId,omitempty"`  // Oda ID
	From    string          `json:"from,omitempty"`    // Gönderen ID
}

// Client bağlı kullanıcı
type Client struct {
	conn *websocket.Conn
	room *Room
	id   string
}

// Room sohbet odası
type Room struct {
	id      string
	clients map[*Client]bool
	mu      sync.Mutex
}

var (
	upgrader = websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true // Her yerden bağlantıya izin ver (CORS)
		},
	}
	rooms = make(map[string]*Room)
	mu    sync.Mutex
)

func main() {
	http.HandleFunc("/ws", handleWebSocket)

	log.Println("🚀 Signaling Server başlatılıyor...")
	log.Println("👂 Port 8080 dinleniyor")

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("❌ Sunucu hatası:", err)
	}
}

func handleWebSocket(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("⚠️ WebSocket upgrade hatası:", err)
		return
	}

	client := &Client{
		conn: conn,
		id:   r.RemoteAddr, // Basit ID (gerçekte UUID olmalı)
	}

	defer func() {
		client.conn.Close()
		if client.room != nil {
			leaveRoom(client)
		}
	}()

	log.Printf("🔌 Yeni bağlantı: %s", client.id)

	for {
		var msg Message
		err := conn.ReadJSON(&msg)
		if err != nil {
			log.Printf("⚠️ Okuma hatası (%s): %v", client.id, err)
			break
		}

		handleMessage(client, msg)
	}
}

func handleMessage(client *Client, msg Message) {
	switch msg.Type {
	case "join":
		joinRoom(client, msg.RoomID)
	case "offer", "answer", "candidate", "ready":
		broadcastToRoom(client, msg)
	default:
		log.Printf("⚠️ Bilinmeyen mesaj tipi: %s", msg.Type)
	}
}

func joinRoom(client *Client, roomID string) {
	mu.Lock()
	room, exists := rooms[roomID]
	if !exists {
		room = &Room{
			id:      roomID,
			clients: make(map[*Client]bool),
		}
		rooms[roomID] = room
		log.Printf("🏠 Yeni oda oluşturuldu: %s", roomID)
	}
	mu.Unlock()

	room.mu.Lock()
	// Odaya en fazla 2 kişi girebilir
	if len(room.clients) >= 2 {
		log.Printf("⛔ Oda dolu: %s", roomID)
		sendError(client, "Oda dolu")
		room.mu.Unlock()
		return
	}

	room.clients[client] = true
	client.room = room
	room.mu.Unlock()

	log.Printf("👤 %s odaya katıldı: %s", client.id, roomID)

	// Başarı mesajı gönder (opsiyonel)
	// sendToClient(client, Message{Type: "joined", RoomID: roomID})
}

func leaveRoom(client *Client) {
	room := client.room
	if room == nil {
		return
	}

	room.mu.Lock()
	delete(room.clients, client)
	empty := len(room.clients) == 0
	room.mu.Unlock()

	log.Printf("👋 %s odadan ayrıldı: %s", client.id, room.id)

	if empty {
		mu.Lock()
		delete(rooms, room.id)
		mu.Unlock()
		log.Printf("🗑️ Oda silindi: %s", room.id)
	}
}

func broadcastToRoom(sender *Client, msg Message) {
	room := sender.room
	if room == nil {
		return
	}

	room.mu.Lock()
	defer room.mu.Unlock()

	for client := range room.clients {
		if client != sender {
			err := client.conn.WriteJSON(msg)
			if err != nil {
				log.Printf("⚠️ Gönderme hatası (%s): %v", client.id, err)
				client.conn.Close()
				delete(room.clients, client)
			} else {
				log.Printf("📨 Mesaj iletildi (%s -> %s): %s", sender.id, client.id, msg.Type)
			}
		}
	}
}

func sendError(client *Client, errorMsg string) {
	msg := Message{
		Type:    "error",
		Payload: json.RawMessage(`"` + errorMsg + `"`),
	}
	client.conn.WriteJSON(msg)
}
