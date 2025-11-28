import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/features/peers/presentation/widgets/create_invitation_dialog.dart';
import 'package:aether_desktop/features/peers/presentation/widgets/add_peer_by_invitation_dialog.dart';
import 'package:aether_desktop/features/peers/presentation/widgets/configure_grpc_server_dialog.dart';
import 'package:aether_desktop/generated/api/proto/peer.pb.dart' as peer_pb;
import 'package:aether_desktop/generated/api/proto/common.pbenum.dart'
    as common_pb;
import 'package:aether_desktop/data/providers/user_provider.dart';
import 'package:aether_desktop/data/providers/language_provider.dart';
import 'package:aether_desktop/core/localization/app_strings.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';

class PeersPage extends ConsumerStatefulWidget {
  const PeersPage({super.key});

  @override
  ConsumerState<PeersPage> createState() => _PeersPageState();
}

class _PeersPageState extends ConsumerState<PeersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Peer listelerini düzenli olarak yenile (her 2 saniyede bir)
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;

      if (_tabController.index == 0) {
        // Keşfedilen sekmesinde ise
        ref.read(peerNotifierProvider.notifier).discoverPeers();
      } else if (_tabController.index == 1) {
        // Bağlı sekmesinde ise
        ref.invalidate(connectedPeersProvider);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final networkMode = ref.watch(networkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                AppStrings.get('p2p_connections', ref.watch(languageProvider))),
            Text(
              '${AppStrings.get('this_device', ref.watch(languageProvider))}: ${ref.watch(userProvider)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () {
              ref.read(peerNotifierProvider.notifier).discoverPeers();
            },
            tooltip: AppStrings.get('refresh', ref.watch(languageProvider)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.search),
                  const SizedBox(width: 8),
                  // Network mode dropdown
                  PopupMenuButton<NetworkMode>(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          networkMode == NetworkMode.local ? 'LOCAL' : 'WAN',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Icon(LucideIcons.chevronDown, size: 16),
                      ],
                    ),
                    onSelected: (mode) {
                      ref.read(networkModeProvider.notifier).state = mode;
                      // Provider'ı yenile
                      ref.invalidate(discoveredPeersProvider);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<NetworkMode>(
                        value: NetworkMode.local,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.network,
                              size: 16,
                              color: networkMode == NetworkMode.local
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            const Text('LOCAL'),
                            if (networkMode == NetworkMode.local) ...[
                              const Spacer(),
                              Icon(
                                LucideIcons.check,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuItem<NetworkMode>(
                        value: NetworkMode.wan,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.globe,
                              size: 16,
                              color: networkMode == NetworkMode.wan
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            const Text('WAN'),
                            if (networkMode == NetworkMode.wan) ...[
                              const Spacer(),
                              Icon(
                                LucideIcons.check,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              text: 'Keşfedilen',
            ),
            const Tab(
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
    final networkMode = ref.watch(networkModeProvider);

    // LOCAL veya WAN moduna göre farklı içerik göster
    if (networkMode == NetworkMode.local) {
      return _buildLocalDiscoveryTab();
    } else {
      return _buildWANDiscoveryTab();
    }
  }

  Widget _buildLocalDiscoveryTab() {
    final peersAsync = ref.watch(discoveredPeersProvider);
    final connectedPeersAsync = ref.watch(connectedPeersProvider);

    return peersAsync.when(
      data: (peers) {
        // Bağlı peer'ların ID'lerini al
        final connectedIds =
            connectedPeersAsync.valueOrNull?.map((p) => p.deviceId).toSet() ??
                {};

        // Zaten bağlı olan peer'ları filtrele
        final availablePeers = peers
            .where((peer) => !connectedIds.contains(peer.deviceId))
            .toList();

        if (availablePeers.isEmpty) {
          return _buildEmptyState(
            icon: LucideIcons.search,
            title:
                AppStrings.get('no_peers_found', ref.watch(languageProvider)),
            message:
                AppStrings.get('no_peers_message', ref.watch(languageProvider)),
            actionLabel:
                AppStrings.get('search_again', ref.watch(languageProvider)),
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
            itemCount: availablePeers.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return _buildPeerCard(availablePeers[index], isConnected: false);
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

  Widget _buildWANDiscoveryTab() {
    final peersAsync = ref.watch(discoveredPeersProvider);
    final connectedPeersAsync = ref.watch(connectedPeersProvider);
    final grpcConfig = ref.watch(grpcConnectionConfigProvider);
    final grpcConnected = ref.watch(grpcConnectionStateProvider);

    return peersAsync.when(
      data: (peers) {
        // Bağlı peer'ların ID'lerini al
        final connectedIds =
            connectedPeersAsync.valueOrNull?.map((p) => p.deviceId).toSet() ??
                {};

        // Zaten bağlı olan peer'ları filtrele
        final availablePeers = peers
            .where((peer) => !connectedIds.contains(peer.deviceId))
            .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      grpcConnected
                          ? LucideIcons.checkCircle
                          : LucideIcons.alertTriangle,
                      color: grpcConnected ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WAN gRPC Sunucusu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${grpcConfig.host}:${grpcConfig.port}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (!grpcConnected)
                            const Text(
                              'Bağlantı kurulamadı, ayarları kontrol edin.',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.orange),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const ConfigureGrpcServerDialog(),
                        );
                      },
                      icon: const Icon(LucideIcons.settings2, size: 16),
                      label: const Text('Sunucu Ayarları'),
                    ),
                  ],
                ),
              ),
            ),
            // WAN butonları (Invitation oluştur / Invitation gir)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CreateInvitationDialog(),
                        );
                      },
                      icon: const Icon(LucideIcons.link),
                      label: const Text('Yeni Bağlantı Oluştur'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const AddPeerByInvitationDialog(),
                        );
                      },
                      icon: const Icon(LucideIcons.link),
                      label: const Text('Invitation Link Gir'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Peer listesi veya boş durum
            Expanded(
              child: availablePeers.isEmpty
                  ? _buildEmptyState(
                      icon: LucideIcons.globe,
                      title: 'WAN Peer Bulunamadı',
                      message:
                          'WAN üzerinden bağlanmak için invitation link oluşturun veya bir invitation link ile bağlanın.',
                      actionLabel: null,
                      onAction: null,
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref
                            .read(peerNotifierProvider.notifier)
                            .discoverPeers();
                      },
                      child: ListView.builder(
                        itemCount: availablePeers.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          return _buildPeerCard(availablePeers[index],
                              isConnected: false);
                        },
                      ),
                    ),
            ),
          ],
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
            title: AppStrings.get(
                'no_connected_peers', ref.watch(languageProvider)),
            message: AppStrings.get(
                'no_connected_message', ref.watch(languageProvider)),
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
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.blue.withValues(alpha: 0.1),
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
                        '${peer.deviceId.substring(0, 16)}...',
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
                    onPressed: () async {
                      await ref
                          .read(peerNotifierProvider.notifier)
                          .connectToPeer(peer.deviceId);
                      // Bağlı peer listesini yenile
                      if (mounted) {
                        ref.invalidate(connectedPeersProvider);
                      }
                    },
                    icon: const Icon(LucideIcons.link, size: 16),
                    label: Text(
                        AppStrings.get('connect', ref.watch(languageProvider))),
                  ),
                if (isConnected)
                  TextButton.icon(
                    onPressed: () {
                      _confirmDisconnect(peer);
                    },
                    icon: const Icon(LucideIcons.link2Off, size: 16),
                    label: Text(AppStrings.get(
                        'disconnect', ref.watch(languageProvider))),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                const SizedBox(width: 8),
                if (!peer.isTrusted)
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(peerNotifierProvider.notifier)
                          .trustPeer(peer.deviceId);
                    },
                    icon: const Icon(LucideIcons.shieldCheck, size: 16),
                    label: Text(
                        AppStrings.get('trust', ref.watch(languageProvider))),
                  ),
                if (peer.isTrusted)
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(peerNotifierProvider.notifier)
                          .untrustPeer(peer.deviceId);
                    },
                    icon: const Icon(LucideIcons.shieldOff, size: 16),
                    label: Text(
                        AppStrings.get('untrust', ref.watch(languageProvider))),
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
      text = AppStrings.get('online', ref.watch(languageProvider));
      icon = LucideIcons.circle;
    } else if (status == common_pb.PeerStatus.PEER_STATUS_OFFLINE) {
      color = Colors.grey;
      text = AppStrings.get('offline', ref.watch(languageProvider));
      icon = LucideIcons.circle;
    } else if (status == common_pb.PeerStatus.PEER_STATUS_CONNECTING) {
      color = Colors.orange;
      text = AppStrings.get('connecting', ref.watch(languageProvider));
      icon = LucideIcons.loader;
    } else {
      color = Colors.grey;
      text = AppStrings.get('unknown', ref.watch(languageProvider));
      icon = LucideIcons.helpCircle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
              title: Text(
                  AppStrings.get('show_details', ref.watch(languageProvider))),
              onTap: () {
                Navigator.pop(context);
                _showPeerDetails(peer);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2, color: Colors.red),
              title: Text(
                  AppStrings.get('remove_peer', ref.watch(languageProvider)),
                  style: const TextStyle(color: Colors.red)),
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
    final peerInfo = await ref
        .read(peerNotifierProvider.notifier)
        .getPeerInfo(peer.deviceId);

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
            child: Text(AppStrings.get('close', ref.watch(languageProvider))),
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
        title: Text(AppStrings.get(
            'remove_confirm_title', ref.watch(languageProvider))),
        content: Text(
            '${peer.name} ${AppStrings.get('remove_confirm_message', ref.watch(languageProvider))}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get('cancel', ref.watch(languageProvider))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(peerNotifierProvider.notifier).removePeer(peer.deviceId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppStrings.get('remove', ref.watch(languageProvider))),
          ),
        ],
      ),
    );
  }

  void _confirmDisconnect(peer_pb.Peer peer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get(
            'disconnect_confirm_title', ref.watch(languageProvider))),
        content: Text(
            '${AppStrings.get('disconnect_confirm_message', ref.watch(languageProvider))} ${peer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get('cancel', ref.watch(languageProvider))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(peerNotifierProvider.notifier)
                  .disconnectFromPeer(peer.deviceId);
              // Bağlı peer listesini yenile
              if (mounted) {
                ref.invalidate(connectedPeersProvider);
                // Keşfedilen peer listesini de yenile
                ref.invalidate(discoveredPeersProvider);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppStrings.get(
                'disconnect',
                ref.watch(
                    languageProvider))), // 'Kes' yerine 'Bağlantıyı Kes' (Disconnect) kullanıldı
          ),
        ],
      ),
    );
  }
}
