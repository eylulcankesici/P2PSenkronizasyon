package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	
	"github.com/aether/sync/internal/config"
	"github.com/aether/sync/internal/container"
	"github.com/aether/sync/internal/delivery/grpc"
)

func main() {
	log.Println("Aether başlatılıyor...")
	
	// Konfigürasyonu yükle
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("Konfigürasyon yüklenemedi: %v", err)
	}
	
	// Konfigürasyonu doğrula
	if err := cfg.Validate(); err != nil {
		log.Fatalf("Konfigürasyon geçersiz: %v", err)
	}
	
	log.Printf("Aether v%s (%s mode)", cfg.App.Version, cfg.App.Environment)
	log.Printf("Data dizini: %s", cfg.App.DataDir)
	
	// Dependency injection container'ı oluştur
	cont, err := container.NewContainer(cfg)
	if err != nil {
		log.Fatalf("Container oluşturulamadı: %v", err)
	}
	defer func() {
		if err := cont.Close(); err != nil {
			log.Printf("Container kapatılamadı: %v", err)
		}
	}()
	
	// Context oluştur
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	
	// Graceful shutdown için sinyal dinle
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)
	
	// gRPC sunucusunu oluştur ve başlat
	grpcAddr := fmt.Sprintf("%s:%d", cfg.GRPC.Host, cfg.GRPC.Port)
	grpcServer := grpc.NewServer(cont, grpcAddr)
	
	// gRPC sunucusunu goroutine'de başlat
	go func() {
		if err := grpcServer.Start(ctx); err != nil {
			log.Printf("gRPC sunucusu hatası: %v", err)
			cancel()
		}
	}()
	
	// P2P networking burada başlatılacak (henüz implement edilmedi)
	log.Println("P2P networking yakında başlatılacak...")
	
	// Başarıyla başlatıldı
	log.Println("✓ Aether başarıyla başlatıldı!")
	log.Println("Kapatmak için Ctrl+C'ye basın")
	
	// Shutdown sinyali bekle
	select {
	case sig := <-sigChan:
		log.Printf("Shutdown sinyali alındı: %v", sig)
	case <-ctx.Done():
		log.Println("Context iptal edildi")
	}
	
	log.Println("Aether kapatılıyor...")
	grpcServer.Stop()
}


