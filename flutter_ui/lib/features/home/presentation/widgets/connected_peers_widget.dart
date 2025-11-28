import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/generated/api/proto/peer.pb.dart';

class ConnectedPeersWidget extends ConsumerWidget {
  const ConnectedPeersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectedPeersAsync = ref.watch(connectedPeersProvider);

    return connectedPeersAsync.when(
      data: (peers) {
        if (peers.isEmpty) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...peers.map((peer) => _buildPeerChip(context, peer)),
            const SizedBox(width: 8),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPeerChip(BuildContext context, Peer peer) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.link, size: 12, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            peer.name.isNotEmpty ? peer.name : 'Unknown',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
