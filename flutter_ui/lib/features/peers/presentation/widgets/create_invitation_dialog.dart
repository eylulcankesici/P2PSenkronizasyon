import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/generated/api/proto/peer.pb.dart' as peer_pb;

class CreateInvitationDialog extends ConsumerStatefulWidget {
  const CreateInvitationDialog({super.key});

  @override
  ConsumerState<CreateInvitationDialog> createState() =>
      _CreateInvitationDialogState();
}

class _CreateInvitationDialogState
    extends ConsumerState<CreateInvitationDialog> {
  int _expiryHours = 24;
  bool _isLoading = false;
  peer_pb.CreateInvitationResponse? _invitationResponse;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(LucideIcons.link, size: 24),
          SizedBox(width: 8),
          Text('Invitation Link Oluştur'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: _invitationResponse == null
            ? _buildCreateForm()
            : _buildResultView(context),
      ),
      actions: _invitationResponse == null
          ? [
              TextButton(
                onPressed:
                    _isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: _isLoading ? null : _createInvitation,
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Link Oluştur'),
              ),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kapat'),
              ),
            ],
    );
  }

  Widget _buildCreateForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bu link ile başka kullanıcılar sizinle bağlantı kurabilir.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 24),
        const Text(
          'Geçerlilik Süresi:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _expiryHours,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: const [
            DropdownMenuItem(value: 1, child: Text('1 saat')),
            DropdownMenuItem(value: 6, child: Text('6 saat')),
            DropdownMenuItem(value: 24, child: Text('24 saat')),
            DropdownMenuItem(value: 168, child: Text('7 gün')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _expiryHours = value);
            }
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.alertTriangle, size: 20, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dikkat:\n• Link sadece belirtilen süre geçerli\n• Güvenlik için link\'i güvende tutun\n• Her peer için ayrı link oluşturun',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(BuildContext context) {
    final response = _invitationResponse!;
    final expiresAt =
        DateTime.fromMillisecondsSinceEpoch(response.expiresAt.toInt() * 1000);
    final now = DateTime.now();
    final remaining = expiresAt.difference(now);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(LucideIcons.checkCircle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Invitation link başarıyla oluşturuldu!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Link\'i paylaşmak için:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _copyLink(context, response.invitationLink),
                icon: const Icon(LucideIcons.copy, size: 16),
                label: const Text('Link\'i Kopyala'),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => _copyLink(context, response.invitationCode),
              icon: const Icon(LucideIcons.code, size: 16),
              label: const Text('Kod'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Link:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: SingleChildScrollView(
              child: SelectableText(
                response.invitationLink,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(LucideIcons.clock, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              'Geçerlilik: ${_formatDuration(remaining)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    ));
  }

  Future<void> _createInvitation() async {
    setState(() => _isLoading = true);

    try {
      final response =
          await ref.read(peerNotifierProvider.notifier).createInvitation(
                expiryHours: _expiryHours,
              );

      if (mounted) {
        setState(() {
          _invitationResponse = response;
          _isLoading = false;
        });
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

  void _copyLink(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Panoya kopyalandı!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} gün ${duration.inHours % 24} saat';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} saat ${duration.inMinutes % 60} dakika';
    } else {
      return '${duration.inMinutes} dakika';
    }
  }
}
