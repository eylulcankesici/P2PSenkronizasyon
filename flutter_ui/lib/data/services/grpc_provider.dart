import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_client.dart';

/// Aether gRPC Client Provider
/// Global olarak erişilebilir gRPC client instance
final grpcClientProvider = Provider<AetherGrpcClient>((ref) {
  final client = AetherGrpcClient();
  
  // Uygulama başladığında otomatik bağlan
  client.connect(
    host: 'localhost',
    port: 50051,
  );
  
  // Provider dispose olduğunda bağlantıyı kapat
  ref.onDispose(() {
    client.disconnect();
  });
  
  return client;
});

/// Bağlantı durumu provider'ı
final grpcConnectionStateProvider = StateProvider<bool>((ref) {
  final client = ref.watch(grpcClientProvider);
  return client.isConnected;
});



