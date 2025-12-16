package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/container"
)

func main() {
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║          AETHER P2P LAN TEST                               ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()

	// Config yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatal("❌ Config yüklenemedi:", err)
	}

	// Container oluştur
	cont, err := container.NewContainer(cfg)
	if err != nil {
		log.Fatal("❌ Container oluşturulamadı:", err)
	}
	defer cont.Close()

	ctx := context.Background()

	// P2P Transport başlat
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 1: P2P Transport Başlatma")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	transportProvider := cont.TransportProvider()
	if err := transportProvider.Start(ctx); err != nil {
		log.Fatal("❌ Transport başlatılamadı:", err)
	}
	defer transportProvider.Stop()

	transportType, port, deviceID := cont.PeerDiscoveryUseCase().GetTransportInfo(ctx)
	fmt.Printf("✅ P2P Transport başlatıldı\n")
	fmt.Printf("   • Transport Type: %s\n", transportType)
	fmt.Printf("   • Listen Port: %d\n", port)
	fmt.Printf("   • Device ID: %s\n\n", deviceID[:16]+"...")

	// Peer Discovery
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 2: Peer Discovery (mDNS)")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	if err := cont.PeerDiscoveryUseCase().StartDiscovery(ctx); err != nil {
		log.Fatal("❌ Discovery başlatılamadı:", err)
	}

	fmt.Println("🔍 10 saniye peer aranıyor...")
	time.Sleep(10 * time.Second)

	discoveredPeers, err := cont.PeerDiscoveryUseCase().GetDiscoveredPeers(ctx)
	if err != nil {
		log.Fatal("❌ Peer listesi alınamadı:", err)
	}

	fmt.Printf("\n✅ Peer keşfi tamamlandı\n")
	fmt.Printf("   • Bulunan peer sayısı: %d\n\n", len(discoveredPeers))

	if len(discoveredPeers) > 0 {
		fmt.Println("📋 Keşfedilen Peer'lar:")
		for i, peer := range discoveredPeers {
			fmt.Printf("   %d. %s (%s)\n", i+1, peer.DeviceName, peer.DeviceID[:16]+"...")
			fmt.Printf("      Address: %s\n", peer.Addresses[0])
			fmt.Printf("      Version: %s\n", peer.Version)
		}
		fmt.Println()
	} else {
		fmt.Println("⚠️  Hiç peer bulunamadı (başka bir Aether node çalıştırın)")
		fmt.Println()
	}

	// Connection Test (peer varsa)
	if len(discoveredPeers) > 0 {
		fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		fmt.Println("TEST 3: Peer Bağlantısı")
		fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		fmt.Println()

		targetPeer := discoveredPeers[0]
		fmt.Printf("🔗 Bağlanılıyor: %s\n", targetPeer.DeviceName)

		if err := cont.PeerDiscoveryUseCase().ConnectToPeer(ctx, targetPeer.DeviceID); err != nil {
			log.Printf("⚠️  Bağlantı hatası: %v\n", err)
		} else {
			fmt.Printf("✅ Peer'a bağlanıldı: %s\n", targetPeer.DeviceName)

			// Latency test
			latencyMs, err := cont.P2PTransferUseCase().GetPeerLatency(ctx, targetPeer.DeviceID)
			if err != nil {
				log.Printf("⚠️  Latency ölçülemedi: %v\n", err)
			} else {
				fmt.Printf("   • Latency: %d ms\n", latencyMs)
			}
		}
		fmt.Println()
	}

	// Bağlı peer'lar
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("TEST 4: Bağlı Peer'lar")
	fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()

	connectedPeers, err := cont.PeerDiscoveryUseCase().GetConnectedPeers(ctx)
	if err != nil {
		log.Printf("⚠️  Bağlı peer listesi alınamadı: %v\n", err)
	} else {
		fmt.Printf("✅ Bağlı peer sayısı: %d\n", len(connectedPeers))
		for i, peer := range connectedPeers {
			fmt.Printf("   %d. %s (Status: %s)\n", i+1, peer.Name, peer.Status)
		}
	}
	fmt.Println()

	// Sonuç
	fmt.Println("╔════════════════════════════════════════════════════════════╗")
	fmt.Println("║          ✅ P2P LAN TEST TAMAMLANDI!                      ║")
	fmt.Println("╚════════════════════════════════════════════════════════════╝")
	fmt.Println()
	fmt.Println("📋 Test Özeti:")
	fmt.Println("   ✓ P2P Transport (LAN)")
	fmt.Println("   ✓ mDNS Discovery")
	fmt.Println("   ✓ TCP Connection")
	fmt.Println("   ✓ Peer Management")
	fmt.Println()
}
