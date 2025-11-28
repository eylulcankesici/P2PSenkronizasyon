import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';

class ConfigureGrpcServerDialog extends ConsumerStatefulWidget {
  const ConfigureGrpcServerDialog({super.key});

  @override
  ConsumerState<ConfigureGrpcServerDialog> createState() =>
      _ConfigureGrpcServerDialogState();
}

class _ConfigureGrpcServerDialogState
    extends ConsumerState<ConfigureGrpcServerDialog> {
  late TextEditingController _hostController;
  late TextEditingController _portController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final config = ref.read(grpcConnectionConfigProvider);
    _hostController = TextEditingController(text: config.host);
    _portController = TextEditingController(text: config.port.toString());
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(LucideIcons.server),
          SizedBox(width: 8),
          Text('WAN Sunucu Ayarları'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Host / IP',
                hintText: 'example.com veya 192.168.1.10',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Host zorunlu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '50051',
              ),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0 || parsed > 65535) {
                  return 'Geçerli bir port girin';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final newHost = _hostController.text.trim();
              final newPort = int.parse(_portController.text.trim());
              ref.read(grpcConnectionConfigProvider.notifier).state =
                  GrpcConnectionConfig(host: newHost, port: newPort);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('WAN sunucusu güncellendi: $newHost:$newPort'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
