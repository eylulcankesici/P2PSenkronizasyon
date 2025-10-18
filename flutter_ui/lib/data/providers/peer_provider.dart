import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/peer.pb.dart';

/// Peer listesi provider (keşfedilen peer'lar)
final discoveredPeersProvider = FutureProvider<List<Peer>>((ref) async {
  final client = ref.watch(grpcClientProvider);
  
  try {
    final response = await client.peerService.discoverPeers(
      DiscoverPeersRequest(lanOnly: true),
    );
    
    return response.peers;
  } catch (e) {
    print('Peer discovery hatası: $e');
    return [];
  }
});

/// Bağlı peer'lar provider
final connectedPeersProvider = FutureProvider<List<Peer>>((ref) async {
  final client = ref.watch(grpcClientProvider);
  
  try {
    final response = await client.peerService.listPeers(
      ListPeersRequest(onlineOnly: true),
    );
    
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
  
  /// Peer'ları keşfet (yeniden)
  Future<void> discoverPeers() async {
    state = const AsyncValue.loading();
    
    try {
      // Provider'ı invalidate et (yeniden yükle)
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
      
      final response = await client.peerService.connectToPeer(
        ConnectToPeerRequest(peerId: peerId),
      );
      
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
      
      final response = await client.peerService.disconnectFromPeer(
        DisconnectFromPeerRequest(peerId: peerId),
      );
      
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
  
  /// Peer'ı güvenilir yap
  Future<void> trustPeer(String peerId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final response = await client.peerService.trustPeer(
        TrustPeerRequest(peerId: peerId),
      );
      
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
      
      final response = await client.peerService.untrustPeer(
        UntrustPeerRequest(peerId: peerId),
      );
      
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
      
      final response = await client.peerService.removePeer(
        RemovePeerRequest(peerId: peerId),
      );
      
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
  Future<PeerInfoResponse?> getPeerInfo(String peerId) async {
    try {
      final client = ref.read(grpcClientProvider);
      
      final response = await client.peerService.getPeerInfo(
        GetPeerInfoRequest(peerId: peerId),
      );
      
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
}

final peerNotifierProvider = StateNotifierProvider<PeerNotifier, AsyncValue<void>>((ref) {
  return PeerNotifier(ref);
});


