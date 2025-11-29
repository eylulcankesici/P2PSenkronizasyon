import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/notification_provider.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/generated/api/proto/peer.pb.dart';

/// Peer bağlantı durumlarını izleyen ve bildirim gönderen sınıf
class PeerMonitor {
  final Ref ref;
  Timer? _pollingTimer;
  Set<String> _previousConnectedPeerIds = {};

  PeerMonitor(this.ref);

  /// İzlemeyi başlat
  void start() {
    // İlk durumu al
    _updatePreviousState();

    // Polling başlat (her 15 saniyede bir)
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      await _checkConnections();
    });
  }

  /// İzlemeyi durdur
  void stop() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Mevcut durumu kaydet
  void _updatePreviousState() {
    final peers = ref.read(connectedPeersProvider).valueOrNull ?? [];
    _previousConnectedPeerIds = peers.map((p) => p.deviceId).toSet();
  }

  /// Bağlantıları kontrol et
  Future<void> _checkConnections() async {
    try {
      // Listeyi yenile (backend'den al)
      // Not: connectedPeersProvider zaten home_page veya başka yerlerde invalidate ediliyor olabilir
      // ama burada emin olmak için refresh yapıyoruz.
      // Ancak sürekli refresh UI'ı yorabilir, bu yüzden sadece provider'ın mevcut değerini okuyup
      // arka planda refresh tetiklemek daha iyi olabilir.
      // Şimdilik invalidate ederek taze veri alalım.
      ref.invalidate(connectedPeersProvider);
      final currentPeers = await ref.read(connectedPeersProvider.future);
      final currentPeerIds = currentPeers.map((p) => p.deviceId).toSet();

      // Yeni bağlananları bul
      final newPeerIds = currentPeerIds.difference(_previousConnectedPeerIds);
      for (final id in newPeerIds) {
        final peer = currentPeers.firstWhere((p) => p.deviceId == id);
        _notifyConnected(peer);
      }

      // Bağlantısı kopanları bul
      final lostPeerIds = _previousConnectedPeerIds.difference(currentPeerIds);
      for (final id in lostPeerIds) {
        // Kopan peer'ın ismini bulmaya çalış (önceki listeden veya keşfedilenlerden)
        String peerName = 'Cihaz';
        // Keşfedilenlerde ara
        final discovered = ref.read(discoveredPeersProvider).valueOrNull ?? [];
        try {
          final peer = discovered.firstWhere((p) => p.deviceId == id);
          peerName = peer.name;
        } catch (_) {
           // Bulamazsak genel isim kullan
        }
        
        _notifyDisconnected(peerName);
      }

      // Durumu güncelle
      _previousConnectedPeerIds = currentPeerIds;
    } catch (e) {
      print('Peer monitor error: $e');
    }
  }

  void _notifyConnected(Peer peer) {
    final name = peer.name.isNotEmpty ? peer.name : 'Bilinmeyen Cihaz';
    ref.read(notificationsProvider.notifier).addNotification(
      title: 'Bağlantı Başarılı',
      message: '$name ile bağlantı kuruldu.',
      icon: LucideIcons.link,
      color: Colors.green,
    );
  }

  void _notifyDisconnected(String peerName) {
    ref.read(notificationsProvider.notifier).addNotification(
      title: 'Bağlantı Kesildi',
      message: '$peerName ile bağlantı sonlandırıldı.',
      icon: LucideIcons.unlink,
      color: Colors.orange,
    );
  }
}

final peerMonitorProvider = Provider<PeerMonitor>((ref) {
  final monitor = PeerMonitor(ref);
  // Provider dispose olduğunda timer'ı durdur
  ref.onDispose(() => monitor.stop());
  return monitor;
});
