import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';

class AddPeerByInvitationDialog extends ConsumerStatefulWidget {
  const AddPeerByInvitationDialog({super.key});

  @override
  ConsumerState<AddPeerByInvitationDialog> createState() => _AddPeerByInvitationDialogState();
}

class _AddPeerByInvitationDialogState extends ConsumerState<AddPeerByInvitationDialog> {
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(LucideIcons.link, size: 24),
          SizedBox(width: 8),
          Text('Invitation Link Gir'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aşağıdaki alana invitation link\'i veya invitation code\'u yapıştırın:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Invitation Link veya Code',
                hintText: 'aether://invite?code=... veya invitation code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(LucideIcons.link),
              ),
              maxLines: 3,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 20, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'İpucu: Link\'i kopyalayıp buraya yapıştırabilirsiniz. Link otomatik olarak parse edilecektir.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _addPeer,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Bağlan'),
        ),
      ],
    );
  }

  Future<void> _addPeer() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen invitation link veya code girin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Link'ten code'u çıkar (aether://invite?code=... formatından)
    String invitationCode = text;
    if (text.startsWith('aether://invite?code=')) {
      invitationCode = text.substring('aether://invite?code='.length);
      // URL decode et (özel karakterler encode edilmiş olabilir)
      try {
        invitationCode = Uri.decodeComponent(invitationCode);
      } catch (e) {
        // URL decode başarısız olursa, orijinal string'i kullan
        print('URL decode hatası: $e');
      }
    } else if (text.contains('code=')) {
      // URL formatında ama farklı bir format olabilir
      try {
        final uri = Uri.parse(text);
        invitationCode = uri.queryParameters['code'] ?? text;
        // URL decode et
        invitationCode = Uri.decodeComponent(invitationCode);
      } catch (e) {
        // URI parse başarısız olursa, orijinal string'i kullan
        print('URI parse hatası: $e');
      }
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(peerNotifierProvider.notifier).addPeerByInvitation(invitationCode);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Peer başarıyla eklendi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

