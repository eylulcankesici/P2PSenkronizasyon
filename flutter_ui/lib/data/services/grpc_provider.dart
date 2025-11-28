import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_client.dart';

/// Aether gRPC Client Provider
/// Global olarak erişilebilir gRPC client instance
class GrpcConnectionConfig {
  final String host;
  final int port;

  const GrpcConnectionConfig({required this.host, required this.port});
}

final grpcConnectionConfigProvider = StateProvider<GrpcConnectionConfig>((ref) {
  return const GrpcConnectionConfig(host: 'localhost', port: 50051);
});

final grpcClientProvider = Provider<AetherGrpcClient>((ref) {
  final client = AetherGrpcClient();
  final config = ref.watch(grpcConnectionConfigProvider);
  client.connect(
    host: config.host,
    port: config.port,
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
