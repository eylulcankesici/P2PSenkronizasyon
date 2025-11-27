import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/peer.pb.dart' as peer_pb;
import 'package:aether_desktop/generated/api/proto/peer.pbgrpc.dart';

/// Network mode enum
enum NetworkMode {
  local,
  wan,
}

/// Network mode provider (varsayılan: LOCAL)
final networkModeProvider = StateProvider<NetworkMode>((ref) => NetworkMode.local);

/// Peer listesi provider (keşfedilen peer'lar - LOCAL veya WAN)
final discoveredPeersProvider = FutureProvider<List<peer_pb.Peer>>((ref) async {
  final client = ref.watch(grpcClientProvider);
  final networkMode = ref.watch(networkModeProvider);
  
  try {
    final request = peer_pb.DiscoverPeersRequest();
    if (networkMode == NetworkMode.local) {
      request.lanOnly = true;
    } else {
      request.wanOnly = true;
    }
    
    final response = await client.peerService.discoverPeers(request);
    
    return response.peers;
  } catch (e) {
    print('Peer discovery hatası: $e');
    return [];
  }
});

/// Bağlı peer'lar provider
final connectedPeersProvider = FutureProvider<List<peer_pb.Peer>>((ref) async {
  final client = ref.watch(grpcClientProvider);
  
  try {
    final request = peer_pb.ListPeersRequest()..onlineOnly = true;
    final response = await client.peerService.listPeers(request);
    
    return response.peers;
  } catch (e) {
    print('Bağlı peer listesi hatası: $e');
    return [];
  }
});

/// Peer işlemleri notifier
class PeerNotifier extends StateNotifier<AsyncValue<void>> {
  PeerNotifier(this.ref) : super(const AsyncValue.data(null));
  
  final Ref ref;
  
  /// Peer'ları keşfet (yeniden) - Network mode'a göre
  Future<void> discoverPeers() async {
    state = const AsyncValue.loading();
    
    try {
      // Provider'ı invalidate et (yeniden yükle)
      // Bu otomatik olarak network mode'a göre doğru provider'ı çağıracak
      ref.invalidate(discoveredPeersProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Peer'a bağlan
  Future<void> connectToPeer(String peerId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.ConnectToPeerRequest()..peerId = peerId;
      final response = await client.peerService.connectToPeer(request);
      
      if (response.success) {
        // Bağlı peer listesini yenile
        ref.invalidate(connectedPeersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Peer bağlantısını kes
  Future<void> disconnectFromPeer(String peerId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.DisconnectFromPeerRequest()..peerId = peerId;
      final response = await client.peerService.disconnectFromPeer(request);
      
      if (response.success) {
        // Bağlı peer listesini yenile
        ref.invalidate(connectedPeersProvider);
        // Keşfedilen peer listesini de yenile (bağlantı kesildi, tekrar keşfedilebilir)
        ref.invalidate(discoveredPeersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Peer'ı güvenilir yap
  Future<void> trustPeer(String peerId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.TrustPeerRequest()..peerId = peerId;
      final response = await client.peerService.trustPeer(request);
      
      if (response.success) {
        ref.invalidate(discoveredPeersProvider);
        ref.invalidate(connectedPeersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Peer'ı güvenilmez yap
  Future<void> untrustPeer(String peerId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.UntrustPeerRequest()..peerId = peerId;
      final response = await client.peerService.untrustPeer(request);
      
      if (response.success) {
        ref.invalidate(discoveredPeersProvider);
        ref.invalidate(connectedPeersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Peer'ı kaldır
  Future<void> removePeer(String peerId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.RemovePeerRequest()..peerId = peerId;
      final response = await client.peerService.removePeer(request);
      
      if (response.success) {
        ref.invalidate(discoveredPeersProvider);
        ref.invalidate(connectedPeersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Peer detaylarını al
  Future<peer_pb.PeerInfoResponse?> getPeerInfo(String peerId) async {
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.GetPeerInfoRequest()..peerId = peerId;
      final response = await client.peerService.getPeerInfo(request);
      
      if (response.status.success) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      print('Peer info hatası: $e');
      return null;
    }
  }
  
  /// Bağlantı isteğini onayla
  Future<void> acceptConnection(String deviceId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.AcceptConnectionRequest()..deviceId = deviceId;
      final response = await client.peerService.acceptConnection(request);
      
      if (response.success) {
        // Bağlı peer listesini yenile
        ref.invalidate(connectedPeersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Bağlantı isteğini reddet
  Future<void> rejectConnection(String deviceId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.RejectConnectionRequest()..deviceId = deviceId;
      final response = await client.peerService.rejectConnection(request);
      
      if (response.success) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Invitation code oluştur (WAN için)
  Future<peer_pb.CreateInvitationResponse?> createInvitation({int expiryHours = 24}) async {
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.CreateInvitationRequest()..expiryHours = expiryHours;
      final response = await client.peerService.createInvitation(request);
      
      if (response.status.success) {
        return response;
      } else {
        throw Exception(response.status.message);
      }
    } catch (e) {
      print('Invitation code oluşturma hatası: $e');
      rethrow;
    }
  }

  /// Invitation code ile peer ekle (WAN için)
  Future<void> addPeerByInvitation(String invitationCode) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = peer_pb.AddPeerByInvitationRequest()..invitationCode = invitationCode;
      final response = await client.peerService.addPeerByInvitation(request);
      
      if (response.success) {
        // Keşfedilen peer listesini yenile
        ref.invalidate(discoveredPeersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final peerNotifierProvider = StateNotifierProvider<PeerNotifier, AsyncValue<void>>((ref) {
  return PeerNotifier(ref);
});

/// Pending connection model
class PendingConnection {
  final String deviceId;
  final String deviceName;
  final DateTime timestamp;
  
  PendingConnection({
    required this.deviceId,
    required this.deviceName,
    required this.timestamp,
  });
}

/// Pending connections provider (polling ile backend'den alır)
final pendingConnectionsProvider = FutureProvider<List<PendingConnection>>((ref) async {
  final client = ref.watch(grpcClientProvider);
  
  try {
    final response = await client.peerService.getPendingConnections(
      peer_pb.GetPendingConnectionsRequest(),
    );
    
    // Proto PendingConnection'ları Dart PendingConnection'a çevir
    return response.pendingConnections.map((pc) => PendingConnection(
      deviceId: pc.deviceId,
      deviceName: pc.deviceName,
      timestamp: DateTime.fromMillisecondsSinceEpoch(pc.timestamp.toInt() * 1000),
    )).toList();
  } catch (e) {
    print('Pending connections hatası: $e');
    return [];
  }
});

/// Pending connections state manager (UI için)
final pendingConnectionsNotifierProvider = StateNotifierProvider<PendingConnectionsNotifier, List<PendingConnection>>((ref) {
  return PendingConnectionsNotifier(ref);
});

class PendingConnectionsNotifier extends StateNotifier<List<PendingConnection>> {
  PendingConnectionsNotifier(this.ref) : super([]);
  
  final Ref ref;
  
  /// Pending connection ekle
  void addPendingConnection(String deviceId, String deviceName) {
    state = [
      ...state,
      PendingConnection(
        deviceId: deviceId,
        deviceName: deviceName,
        timestamp: DateTime.now(),
      ),
    ];
  }
  
  /// Pending connection kaldır
  void removePendingConnection(String deviceId) {
    state = state.where((p) => p.deviceId != deviceId).toList();
  }
  
  /// Tüm pending connections'ı temizle
  void clear() {
    state = [];
  }
}


