  
  try {
    final request = DiscoverPeersRequest()..lanOnly = true;
    final response = await client.peerService.discoverPeers(request);
    
    return response.peers;
  } catch (e) {
    print('Peer discovery hatası: $e');
    return [];
  }
});

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
      
      final request = ConnectToPeerRequest()..peerId = peerId;
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
      
      final request = DisconnectFromPeerRequest()..peerId = peerId;
      final response = await client.peerService.disconnectFromPeer(request);
      
      if (response.success) {
        // Bağlı peer listesini yenile
        ref.invalidate(connectedPeersProvider);
        // Keşfedilen peer listesini de yenile (bağlantı kesildi, tekrar keşfedilebilir)
        ref.invalidate(discoveredPeersProvider);
        state = const AsyncValue.data(null);
        
        // Bildirim gönder
        ref.read(notificationsProvider.notifier).addNotification(
          title: 'Bağlantı Kesildi',
          message: 'Cihaz ile bağlantı sonlandırıldı.',
          icon: LucideIcons.unlink,
          color: Colors.orange,
        );
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
      
      final request = TrustPeerRequest()..peerId = peerId;
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
      
      final request = UntrustPeerRequest()..peerId = peerId;
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
      
      final request = RemovePeerRequest()..peerId = peerId;
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
  Future<PeerInfoResponse?> getPeerInfo(String peerId) async {
    try {
      final client = ref.read(grpcClientProvider);
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = AcceptConnectionRequest()..deviceId = deviceId;
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
      
      final request = RejectConnectionRequest()..deviceId = deviceId;
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
      GetPendingConnectionsRequest(),
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


