import 'package:grpc/grpc.dart';
import 'package:aether_desktop/generated/api/proto/folder.pbgrpc.dart';
import 'package:aether_desktop/generated/api/proto/auth.pbgrpc.dart';
import 'package:aether_desktop/generated/api/proto/file.pbgrpc.dart';
import 'package:aether_desktop/generated/api/proto/peer.pbgrpc.dart';
import 'package:aether_desktop/generated/api/proto/sync.pbgrpc.dart';
import 'package:aether_desktop/generated/api/proto/p2p.pbgrpc.dart';

/// Aether gRPC Client
/// Go backend ile iletişim kuran ana servis
class AetherGrpcClient {
  late ClientChannel _channel;

  // Service clients
  late FolderServiceClient folderService;
  late AuthServiceClient authService;
  late FileServiceClient fileService;
  late PeerServiceClient peerService;
  late SyncServiceClient syncService;
  late TransferServiceClient transferService;

  bool _isConnected = false;
  String? _currentHost;
  int? _currentPort;

  /// Backend'e bağlan
  Future<void> connect({
    String host = 'localhost',
    int port = 50051,
  }) async {
    // Eğer aynı host:port'a bağlıysak, yeniden bağlanma
    if (_isConnected && _currentHost == host && _currentPort == port) {
      return;
    }

    // Eski bağlantıyı kapat
    if (_isConnected) {
      await disconnect();
    }

    try {
      _channel = ClientChannel(
        host,
        port: port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );

      // Service client'larını oluştur
      folderService = FolderServiceClient(_channel);
      authService = AuthServiceClient(_channel);
      fileService = FileServiceClient(_channel);
      peerService = PeerServiceClient(_channel);
      syncService = SyncServiceClient(_channel);
      transferService = TransferServiceClient(_channel);

      _currentHost = host;
      _currentPort = port;
      _isConnected = true;

      print('✓ gRPC client bağlandı: $host:$port');
    } catch (e) {
      _isConnected = false;
      _currentHost = null;
      _currentPort = null;
      print('❌ gRPC bağlantı hatası: $e');
      rethrow;
    }
  }

  /// Backend bağlantısını kontrol et
  bool get isConnected => _isConnected;

  /// Backend bağlantısını kapat
  Future<void> disconnect() async {
    if (_isConnected) {
      await _channel.shutdown();
      _isConnected = false;
      print('gRPC client bağlantısı kapatıldı');
    }
  }
}
