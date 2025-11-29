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
    String invitationCode = text.trim();
    
    // Boşlukları ve yeni satırları temizle
    invitationCode = invitationCode.replaceAll(RegExp(r'\s+'), '');
    
    // URL formatından code'u çıkar
    if (text.contains('aether://invite?code=') || text.contains('code=')) {
      try {
        // Önce URL parse et
        final uri = Uri.tryParse(text);
        if (uri != null && uri.queryParameters.containsKey('code')) {
          // Query parameter'dan al
          invitationCode = uri.queryParameters['code']!;
        } else {
          // Manuel parse (aether://invite?code=... formatından)
          final codeIndex = text.indexOf('code=');
          if (codeIndex != -1) {
            invitationCode = text.substring(codeIndex + 5);
            // Fragment veya başka parametreler varsa kes
            final fragmentIndex = invitationCode.indexOf('#');
            if (fragmentIndex != -1) {
              invitationCode = invitationCode.substring(0, fragmentIndex);
            }
            final paramIndex = invitationCode.indexOf('&');
            if (paramIndex != -1) {
              invitationCode = invitationCode.substring(0, paramIndex);
            }
          }
        }
        
        // URL decode et (sadece bir kez, çünkü backend de temizleyecek)
        // Eğer zaten decode edilmişse, tekrar decode etmeye çalışmayalım
        try {
          final decoded = Uri.decodeComponent(invitationCode);
          // Eğer decode sonrası farklıysa ve geçerli base64 karakterler içeriyorsa kullan
          if (decoded != invitationCode && 
              RegExp(r'^[A-Za-z0-9\-_+/=]+$').hasMatch(decoded)) {
            invitationCode = decoded;
          }
        } catch (e) {
          // URL decode başarısız olursa, orijinal string'i kullan
          print('URL decode hatası: $e');
        }
      } catch (e) {
        // URL parse başarısız olursa, orijinal string'i kullan
        print('URL parse hatası: $e');
      }
    }
    
    // Son temizlik: boşluklar, yeni satırlar ve geçersiz karakterler
    invitationCode = invitationCode.trim().replaceAll(RegExp(r'\s+'), '');
    
    // Base64 karakterlerini kontrol et (sadece geçerli karakterler)
    invitationCode = invitationCode.replaceAll(RegExp(r'[^A-Za-z0-9\-_+/=]'), '');

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

