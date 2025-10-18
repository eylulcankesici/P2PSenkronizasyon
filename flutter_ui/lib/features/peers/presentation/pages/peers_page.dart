import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/generated/api/proto/peer.pb.dart' as peer_pb;
import 'package:aether_desktop/generated/api/proto/common.pbenum.dart' as common_pb;

class PeersPage extends ConsumerStatefulWidget {
  const PeersPage({super.key});

  @override
  ConsumerState<PeersPage> createState() => _PeersPageState();
}

class _PeersPageState extends ConsumerState<PeersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P2P Bağlantılar'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () {
              ref.read(peerNotifierProvider.notifier).discoverPeers();
            },
            tooltip: 'Yenile',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(LucideIcons.search),
              text: 'Keşfedilen',
            ),
            Tab(
              icon: Icon(LucideIcons.link),
              text: 'Bağlı',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoveredPeersTab(),
          _buildConnectedPeersTab(),
        ],
      ),
    );
  }

  Widget _buildDiscoveredPeersTab() {
    final peersAsync = ref.watch(discoveredPeersProvider);

    return peersAsync.when(
      data: (peers) {
        if (peers.isEmpty) {
          return _buildEmptyState(
            icon: LucideIcons.search,
            title: 'Peer Bulunamadı',
            message: 'Aynı ağdaki diğer Aether cihazları otomatik olarak keşfedilir.',
            actionLabel: 'Yeniden Ara',
            onAction: () {
              ref.read(peerNotifierProvider.notifier).discoverPeers();
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(peerNotifierProvider.notifier).discoverPeers();
          },
          child: ListView.builder(
            itemCount: peers.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return _buildPeerCard(peers[index], isConnected: false);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Hata: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(discoveredPeersProvider);
              },
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedPeersTab() {
    final peersAsync = ref.watch(connectedPeersProvider);

    return peersAsync.when(
      data: (peers) {
        if (peers.isEmpty) {
          return _buildEmptyState(
            icon: LucideIcons.link2Off,
            title: 'Bağlı Peer Yok',
            message: 'Keşfedilen peer\'lara bağlanmak için "Keşfedilen" sekmesine gidin.',
          );
        }

        return ListView.builder(
          itemCount: peers.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return _buildPeerCard(peers[index], isConnected: true);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Hata: $error'),
      ),
    );
  }

  Widget _buildPeerCard(peer_pb.Peer peer, {required bool isConnected}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Peer icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.green.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    LucideIcons.monitor,
                    color: isConnected ? Colors.green : Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                // Peer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            peer.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (peer.isTrusted)
                            const Icon(
                              LucideIcons.shieldCheck,
                              size: 16,
                              color: Colors.green,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        peer.deviceId.substring(0, 16) + '...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (peer.knownAddresses.isNotEmpty)
                        Text(
                          peer.knownAddresses.first,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                // Status badge
                _buildStatusBadge(peer.status),
              ],
            ),
            const SizedBox(height: 12),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isConnected)
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(peerNotifierProvider.notifier)
                          .connectToPeer(peer.deviceId);
                    },
                    icon: const Icon(LucideIcons.link, size: 16),
                    label: const Text('Bağlan'),
                  ),
                if (isConnected)
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(peerNotifierProvider.notifier)
                          .disconnectFromPeer(peer.deviceId);
                    },
                    icon: const Icon(LucideIcons.link2Off, size: 16),
                    label: const Text('Bağlantıyı Kes'),
                  ),
                const SizedBox(width: 8),
                if (!peer.isTrusted)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(peerNotifierProvider.notifier).trustPeer(peer.deviceId);
                    },
                    icon: const Icon(LucideIcons.shieldCheck, size: 16),
                    label: const Text('Güven'),
                  ),
                if (peer.isTrusted)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(peerNotifierProvider.notifier).untrustPeer(peer.deviceId);
                    },
                    icon: const Icon(LucideIcons.shieldOff, size: 16),
                    label: const Text('Güveni Kaldır'),
                    style: TextButton.styleFrom(foregroundColor: Colors.orange),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(LucideIcons.moreVertical, size: 20),
                  onPressed: () {
                    _showPeerOptions(peer, isConnected);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(common_pb.PeerStatus status) {
    Color color;
    String text;
    IconData icon;

    if (status == common_pb.PeerStatus.PEER_STATUS_ONLINE) {
      color = Colors.green;
      text = 'Çevrimiçi';
      icon = LucideIcons.circle;
    } else if (status == common_pb.PeerStatus.PEER_STATUS_OFFLINE) {
      color = Colors.grey;
      text = 'Çevrimdışı';
      icon = LucideIcons.circle;
    } else if (status == common_pb.PeerStatus.PEER_STATUS_CONNECTING) {
      color = Colors.orange;
      text = 'Bağlanıyor';
      icon = LucideIcons.loader;
    } else {
      color = Colors.grey;
      text = 'Bilinmiyor';
      icon = LucideIcons.helpCircle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(LucideIcons.refreshCw),
                label: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPeerOptions(peer_pb.Peer peer, bool isConnected) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.info),
              title: const Text('Detayları Göster'),
              onTap: () {
                Navigator.pop(context);
                _showPeerDetails(peer);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2, color: Colors.red),
              title: const Text('Peer\'ı Kaldır', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmRemovePeer(peer);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPeerDetails(peer_pb.Peer peer) async {
    final peerInfo = await ref.read(peerNotifierProvider.notifier).getPeerInfo(peer.deviceId);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(peer.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Device ID', peer.deviceId),
            if (peer.knownAddresses.isNotEmpty)
              _buildDetailRow('IP Address', peer.knownAddresses.first),
            _buildDetailRow('Status', peer.status.toString()),
            _buildDetailRow('Trusted', peer.isTrusted ? 'Yes' : 'No'),
            if (peerInfo != null) ...[
              const Divider(height: 24),
              _buildDetailRow('Connection Type', peerInfo.connectionType),
              _buildDetailRow('Latency', '${peerInfo.latencyMs} ms'),
              _buildDetailRow('Shared Files', peerInfo.sharedFiles.toString()),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _confirmRemovePeer(peer_pb.Peer peer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Peer\'ı Kaldır'),
        content: Text('${peer.name} peer\'ını kaldırmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(peerNotifierProvider.notifier).removePeer(peer.deviceId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
  }
}

