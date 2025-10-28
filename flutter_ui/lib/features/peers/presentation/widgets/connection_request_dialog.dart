import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';

/// Bağlantı isteği dialog'u
class ConnectionRequestDialog extends ConsumerWidget {
  final String deviceId;
  final String deviceName;
  
  const ConnectionRequestDialog({
    Key? key,
    required this.deviceId,
    required this.deviceName,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(LucideIcons.link, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Bağlantı İsteği'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aşağıdaki cihaz size bağlanmak istiyor:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.monitor, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deviceName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deviceId.length > 20 
                          ? '${deviceId.substring(0, 20)}...' 
                          : deviceId,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Reddet
            ref.read(peerNotifierProvider.notifier).rejectConnection(deviceId);
            ref.read(pendingConnectionsProvider.notifier).removePendingConnection(deviceId);
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.x, size: 16),
              const SizedBox(width: 4),
              const Text('Reddet'),
            ],
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Onayla
            ref.read(peerNotifierProvider.notifier).acceptConnection(deviceId);
            ref.read(pendingConnectionsProvider.notifier).removePendingConnection(deviceId);
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.check, size: 16),
              const SizedBox(width: 4),
              const Text('Onayla'),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Pending connection snackbar gösterir
void showConnectionRequestSnackbar(
  BuildContext context,
  String deviceId,
  String deviceName,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(LucideIcons.bell, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bağlantı İsteği',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$deviceName bağlanmak istiyor'),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
        label: 'Göster',
        textColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ConnectionRequestDialog(
              deviceId: deviceId,
              deviceName: deviceName,
            ),
          );
        },
      ),
      duration: const Duration(seconds: 10),
    ),
  );
}

