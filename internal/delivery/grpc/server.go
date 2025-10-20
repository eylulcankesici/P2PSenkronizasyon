package grpc

import (
	"context"
	"fmt"
	"log"
	"net"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/keepalive"
	"google.golang.org/grpc/reflection"

	pb "github.com/aether/sync/api/proto"
	"github.com/aether/sync/internal/container"
)

// Server gRPC sunucusunu temsil eder
type Server struct {
	grpcServer *grpc.Server
	container  *container.Container
	address    string
}

// NewServer yeni bir gRPC server oluşturur
func NewServer(cont *container.Container, address string) *Server {
	// gRPC server seçenekleri
	opts := []grpc.ServerOption{
		grpc.UnaryInterceptor(loggingInterceptor),
		grpc.KeepaliveParams(keepalive.ServerParameters{
			MaxConnectionIdle: 5 * time.Minute,
			Time:              1 * time.Minute,
			Timeout:           20 * time.Second,
		}),
	}

	// gRPC sunucusu oluştur
	grpcServer := grpc.NewServer(opts...)

	// Service handler'larını kaydet
	pb.RegisterFolderServiceServer(grpcServer, NewFolderHandler(cont))
	pb.RegisterAuthServiceServer(grpcServer, NewAuthHandler(cont))
	pb.RegisterFileServiceServer(grpcServer, NewFileHandler(cont))
	pb.RegisterPeerServiceServer(grpcServer, NewPeerHandler(cont))
	pb.RegisterSyncServiceServer(grpcServer, NewSyncHandler(cont))
	pb.RegisterChunkServiceServer(grpcServer, NewChunkHandler(cont))
	pb.RegisterP2PDataServiceServer(grpcServer, NewP2PDataHandler(cont))
	// pb.RegisterConfigServiceServer(grpcServer, NewConfigHandler(cont))

	// Reflection API'yi etkinleştir (development için)
	reflection.Register(grpcServer)

	return &Server{
		grpcServer: grpcServer,
		container:  cont,
		address:    address,
	}
}

// Start sunucuyu başlatır
func (s *Server) Start(ctx context.Context) error {
	lis, err := net.Listen("tcp", s.address)
	if err != nil {
		return fmt.Errorf("failed to listen on %s: %w", s.address, err)
	}

	log.Printf("✓ gRPC sunucusu %s üzerinde dinleniyor", s.address)

	// Graceful shutdown için goroutine
	go func() {
		<-ctx.Done()
		log.Println("gRPC sunucusu kapatılıyor...")
		s.grpcServer.GracefulStop()
	}()

	// Sunucuyu başlat (blocking)
	if err := s.grpcServer.Serve(lis); err != nil {
		return fmt.Errorf("failed to serve: %w", err)
	}

	return nil
}

// Stop sunucuyu durdurur
func (s *Server) Stop() {
	if s.grpcServer != nil {
		s.grpcServer.GracefulStop()
	}
}

// loggingInterceptor her gRPC çağrısını loglar
func loggingInterceptor(
	ctx context.Context,
	req interface{},
	info *grpc.UnaryServerInfo,
	handler grpc.UnaryHandler,
) (interface{}, error) {
	start := time.Now()
	
	// Handler'ı çağır
	resp, err := handler(ctx, req)
	
	// Log
	duration := time.Since(start)
	if err != nil {
		log.Printf("❌ %s - %v - %v", info.FullMethod, duration, err)
	} else {
		log.Printf("✓ %s - %v", info.FullMethod, duration)
	}
	
	return resp, err
}



