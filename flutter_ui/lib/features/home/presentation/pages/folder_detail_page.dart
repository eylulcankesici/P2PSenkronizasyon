import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/file_provider.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/data/providers/sync_provider.dart';
import 'package:aether_desktop/generated/api/proto/folder.pb.dart';
import 'package:aether_desktop/generated/api/proto/common.pb.dart';
import 'package:aether_desktop/generated/api/proto/common.pbenum.dart';
import 'package:aether_desktop/generated/api/proto/sync.pb.dart';
import 'package:aether_desktop/generated/api/proto/file.pb.dart' as file_pb;
import 'package:aether_desktop/generated/api/proto/peer.pb.dart' as peer_pb;
import 'package:aether_desktop/core/services/local_settings_service.dart';

import 'package:aether_desktop/core/localization/app_strings.dart';
import 'package:aether_desktop/data/providers/language_provider.dart';

class FolderDetailPage extends ConsumerStatefulWidget {
  final Folder folder;

  const FolderDetailPage({
    super.key,
    required this.folder,
  });

  @override
  ConsumerState<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends ConsumerState<FolderDetailPage> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Local settings servisini başlat
    LocalSettingsService().init().then((_) {
      if (mounted) setState(() {});
    });

    // Otomatik yenileme: Her 2 saniyede bir dosya listesini güncelle
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Sadece mounted ise yenile
      if (mounted) {
        ref.invalidate(filesProvider(widget.folder.id));
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filesAsync = ref.watch(filesProvider(widget.folder.id));
    final currentLang = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('folder_detail', currentLang)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.folderSync),
            onPressed: () {
              _showSyncFolderDialog(context, ref);
            },
            tooltip: 'Tüm Klasörü Senkronize Et', // TODO: Localize
          ),
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () {
              ref.invalidate(filesProvider(widget.folder.id));
            },
            tooltip: 'Manuel Yenile (Otomatik: 2sn)', // TODO: Localize
          ),
        ],
      ),
      body: Column(
        children: [
          // Klasör bilgileri
          _buildFolderInfo(context, currentLang),
          const Divider(),
          
          // Dosya listesi
          Expanded(
            child: filesAsync.when(
              data: (files) => _buildFileList(context, ref, files, currentLang),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('${AppStrings.get('error', currentLang)}: ${error.toString()}'),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderInfo(BuildContext context, String lang) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.folder, size: 32, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.folder.localPath,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSyncModeText(widget.folder.syncMode, lang),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(
                  context,
                  icon: LucideIcons.clock,
                  label: AppStrings.get('last_scan', lang),
                  value: _formatDateTime(widget.folder.lastScanTime.toDateTime(), lang),
                ),
                _buildInfoChip(
                  context,
                  icon: widget.folder.isActive ? LucideIcons.checkCircle : LucideIcons.pauseCircle,
                  label: AppStrings.get('status', lang),
                  value: widget.folder.isActive 
                      ? AppStrings.get('active', lang) 
                      : AppStrings.get('inactive', lang),
                ),
              ],
            ),
            // Bağlı peerları listele
            Consumer(
              builder: (context, ref, child) => _buildConnectedPeersList(context, ref, lang),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectedPeersList(BuildContext context, WidgetRef ref, String lang) {
    final connectedPeersAsync = ref.watch(connectedPeersProvider);

    return connectedPeersAsync.when(
      data: (peers) {
        if (peers.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              AppStrings.get('no_connected_peers_folder', lang),
              style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 24),
            Text(
              '${AppStrings.get('connected', lang)} ${AppStrings.get('peers', lang)}:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[400]),
            ),
            const SizedBox(height: 8),
            ...peers.map((peer) {
              final savedMode = LocalSettingsService().getPeerSyncMode(widget.folder.id, peer.deviceId);
              final effectiveMode = savedMode ?? widget.folder.syncMode;
              final syncModeText = _getSyncModeText(effectiveMode, lang);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(LucideIcons.monitor, size: 14, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 13, color: Colors.red),
                          children: [
                            TextSpan(text: peer.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const TextSpan(text: '  '),
                            TextSpan(
                              text: syncModeText, 
                              style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w500)
                            ),
                            const TextSpan(text: ' : '),
                            TextSpan(
                              text: peer.deviceId.substring(0, 8), 
                              style: TextStyle(color: Colors.grey[600], fontFamily: 'monospace')
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
      loading: () => const SizedBox(height: 20, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      error: (_, __) => Text(AppStrings.get('error', lang), style: const TextStyle(color: Colors.red, fontSize: 12)),
    );
  }

  Widget _buildFileList(BuildContext context, WidgetRef ref, List files, String lang) {
    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.fileX, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(AppStrings.get('no_folders', lang)), // Reusing no_folders for now or add specific key
            const SizedBox(height: 8),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: files.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final file = files[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              _getFileIcon(file.relativePath),
              color: Theme.of(context).primaryColor,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.relativePath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            subtitle: Row(
              children: [
                const Icon(LucideIcons.hardDrive, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatFileSize(file.size.toInt())),
                const SizedBox(width: 16),
                const Icon(LucideIcons.clock, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatDateTime(file.modTime.toDateTime(), lang)),
              ],
            ),

          ),
        );
      },
    );
  }

  Future<void> _showDeleteFileDialog(BuildContext context, WidgetRef ref, file_pb.File file) async {
    bool deletePhysically = false;
    
    final confirmed = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppStrings.get('delete_file_title', ref.watch(languageProvider))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.get('delete_file_message', ref.watch(languageProvider))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  file.relativePath,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(
                  AppStrings.get('delete_physically', ref.watch(languageProvider)),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  AppStrings.get('delete_physically_subtitle', ref.watch(languageProvider)),
                  style: const TextStyle(fontSize: 11, color: Colors.red),
                ),
                value: deletePhysically,
                onChanged: (value) {
                  setDialogState(() {
                    deletePhysically = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              const SizedBox(height: 8),
              Text(
                deletePhysically
                    ? AppStrings.get('delete_warning', ref.watch(languageProvider))
                    : AppStrings.get('delete_info', ref.watch(languageProvider)),
                style: TextStyle(
                  fontSize: 12,
                  color: deletePhysically ? Colors.red : Colors.grey,
                  fontWeight: deletePhysically ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(AppStrings.get('cancel', ref.watch(languageProvider))),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop({
                'confirmed': true,
                'deletePhysically': deletePhysically,
              }),
              style: FilledButton.styleFrom(
                backgroundColor: deletePhysically ? Colors.red : Colors.orange,
              ),
              child: Text(deletePhysically 
                  ? AppStrings.get('delete_permanently', ref.watch(languageProvider)) 
                  : AppStrings.get('remove_from_app', ref.watch(languageProvider))),
            ),
          ],
        ),
      ),
    );

    if (confirmed != null && confirmed['confirmed'] == true) {
      final shouldDeletePhysically = confirmed['deletePhysically'] as bool? ?? false;
      
      await ref.read(fileNotifierProvider.notifier).deleteFile(
        file.id,
        widget.folder.id,
        deletePhysically: shouldDeletePhysically,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              shouldDeletePhysically
                  ? AppStrings.get('file_deleted_physically', ref.read(languageProvider))
                  : AppStrings.get('file_removed_app', ref.read(languageProvider)),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return LucideIcons.fileText;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return LucideIcons.image;
      case 'mp4':
      case 'mov':
      case 'avi':
        return LucideIcons.video;
      case 'mp3':
      case 'wav':
        return LucideIcons.music;
      case 'zip':
      case 'rar':
      case '7z':
        return LucideIcons.archive;
      case 'doc':
      case 'docx':
        return LucideIcons.fileType2;
      case 'xls':
      case 'xlsx':
        return LucideIcons.sheet;
      case 'ppt':
      case 'pptx':
        return LucideIcons.presentation;
      default:
        return LucideIcons.file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _getSyncModeText(SyncMode mode, String lang) {
    switch (mode) {
      case SyncMode.SYNC_MODE_BIDIRECTIONAL:
        return AppStrings.get('sync_bidirectional', lang);
      case SyncMode.SYNC_MODE_SEND_ONLY:
        return AppStrings.get('sync_send_only', lang);
      case SyncMode.SYNC_MODE_RECEIVE_ONLY:
        return AppStrings.get('sync_receive_only', lang);
      case SyncMode.SYNC_MODE_UNSPECIFIED:
        return AppStrings.get('sync_unspecified', lang);
      default:
        return AppStrings.get('unknown_status', lang);
    }
  }

  String _formatDateTime(DateTime? dateTime, String lang) {
    if (dateTime == null || dateTime.year == 1) {
      return AppStrings.get('unknown', lang);
    }
    
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 1) return AppStrings.get('just_now', lang);
    if (diff.inHours < 1) return '${diff.inMinutes} ${AppStrings.get('minutes_ago', lang)}';
    if (diff.inDays < 1) return '${diff.inHours} ${AppStrings.get('hours_ago', lang)}';
    if (diff.inDays < 7) return '${diff.inDays} ${AppStrings.get('days_ago', lang)}';
    
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _showSyncDialog(BuildContext context, WidgetRef ref, file_pb.File file) {
    final connectedPeersAsync = ref.read(connectedPeersProvider);
    
    connectedPeersAsync.whenData((peers) {
      if (peers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlı peer bulunamadı. Önce bir peer\'a bağlanın.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      showDialog(
        context: context,
        builder: (context) => _SyncPeerDialog(
          file: file,
          peers: peers,
        ),
      );
    });
  }
  
  void _showSyncFolderDialog(BuildContext context, WidgetRef ref) {
    final connectedPeersAsync = ref.read(connectedPeersProvider);
    
    connectedPeersAsync.whenData((peers) {
      if (peers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlı peer bulunamadı. Önce bir peer\'a bağlanın.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      showDialog(
        context: context,
        builder: (context) => _SyncFolderDialog(
          folder: widget.folder,
          peers: peers,
        ),
      );
    });
  }
}

class _SyncPeerDialog extends ConsumerStatefulWidget {
  final file_pb.File file;
  final List<peer_pb.Peer> peers;

  const _SyncPeerDialog({
    required this.file,
    required this.peers,
  });

  @override
  ConsumerState<_SyncPeerDialog> createState() => _SyncPeerDialogState();
}

class _SyncPeerDialogState extends ConsumerState<_SyncPeerDialog> {
  final Map<String, SyncMode> _senderModes = {}; // peerId -> sender sync mode
  final Map<String, SyncMode> _receiverModes = {}; // peerId -> receiver sync mode

  String _getCollectiveSyncMode() {
    if (_senderModes.isEmpty) return 'Seçim Yok';

    final firstSenderMode = _senderModes.values.first;
    final firstKey = _senderModes.keys.first;
    final firstReceiver = _receiverModes[firstKey];

    bool allSame = true;
    for (final deviceId in _senderModes.keys) {
      if (_senderModes[deviceId] != firstSenderMode || 
          _receiverModes[deviceId] != firstReceiver) {
        allSame = false;
        break;
      }
    }

    if (!allSame) return 'Karma (Farklı Modlar)';

    if (firstSenderMode == SyncMode.SYNC_MODE_BIDIRECTIONAL && 
        firstReceiver == SyncMode.SYNC_MODE_BIDIRECTIONAL) {
      return '↔️ Çift Yönlü';
    }
    
    if (firstSenderMode == SyncMode.SYNC_MODE_SEND_ONLY) {
       return '⬆️ Sadece Gönder';
    }
    
    if (firstSenderMode == SyncMode.SYNC_MODE_RECEIVE_ONLY) {
       return '⬇️ Sadece Al';
    }

    return '${_getSyncModeName(firstSenderMode)}';
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncNotifierProvider);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(LucideIcons.send, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text('Dosyayı Senkronize Et')),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dosya: ${widget.file.relativePath}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Boyut: ${_formatFileSize(widget.file.size.toInt())}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            // Seçili mod göstergesi
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    'Seçili Senkronizasyon Modu',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _getCollectiveSyncMode(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Peer Seç ve Sync Mode Belirle:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.peers.map((peer) {
                    final isSelected = _senderModes.containsKey(peer.deviceId);
                    final senderMode = _senderModes[peer.deviceId] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                    final receiverMode = _receiverModes[peer.deviceId] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _senderModes[peer.deviceId] = SyncMode.SYNC_MODE_BIDIRECTIONAL;
                                _receiverModes[peer.deviceId] = SyncMode.SYNC_MODE_BIDIRECTIONAL;
                              } else {
                                _senderModes.remove(peer.deviceId);
                                _receiverModes.remove(peer.deviceId);
                              }
                            });
                          },
                        ),
                        title: Text(peer.name),
                        subtitle: Text(peer.deviceId.substring(0, 8)),
                        initiallyExpanded: isSelected,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gönderici Sync Mode:',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                                SizedBox(height: 8),
                                ...SyncMode.values.where((m) => m != SyncMode.SYNC_MODE_UNSPECIFIED).map((mode) {
                                  return RadioListTile<SyncMode>(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_getSyncModeName(mode)),
                                    value: mode,
                                    groupValue: senderMode,
                                    onChanged: isSelected ? (value) {
                                      if (value != null) {
                                        setState(() {
                                          _senderModes[peer.deviceId] = value;
                                        });
                                      }
                                    } : null,
                                  );
                                }),
                                SizedBox(height: 16),
                                Text(
                                  'Alıcı Sync Mode:',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                                SizedBox(height: 8),
                                ...SyncMode.values.where((m) => m != SyncMode.SYNC_MODE_UNSPECIFIED).map((mode) {
                                  return RadioListTile<SyncMode>(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_getSyncModeName(mode)),
                                    value: mode,
                                    groupValue: receiverMode,
                                    onChanged: isSelected ? (value) {
                                      if (value != null) {
                                        setState(() {
                                          _receiverModes[peer.deviceId] = value;
                                        });
                                      }
                                    } : null,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (syncState.isLoading)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('Senkronize ediliyor...'),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: syncState.isLoading
              ? null
              : () => Navigator.pop(context),
          child: Text('İptal'),
        ),
        FilledButton(
          onPressed: syncState.isLoading || _senderModes.isEmpty
              ? null
              : () {
                  // Peer sync mode'larını oluştur
                  final peerSyncModes = _senderModes.entries.map((e) {
                    return PeerSyncMode()
                      ..peerId = e.key
                      ..senderMode = e.value
                      ..receiverMode = _receiverModes[e.key] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                  }).toList();
                  
                  // Dialog'u hemen kapat
                  Navigator.pop(context);
                  
                  // İşlemi başlat ve sonucu bekleme (fire and forget)
                  // Ancak kullanıcıya bilgi ver
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dosya senkronizasyonu başlatıldı takip etmek için transferler kısmına bakın'),
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  ref
                      .read(syncNotifierProvider.notifier)
                      .syncFile(widget.file.id, _senderModes.keys.toList(), peerSyncModes)
                      .then((_) {
                        // Başarılı olursa
                        // Not: Context artık geçerli olmayabilir, global notification kullanılabilir
                        // veya sessizce devam edilebilir.
                      })
                      .catchError((error) {
                        // Hata durumunda
                        print('Sync error: $error');
                      });
                },
          child: Text('Senkronize Et'),
        ),
      ],
    );
  }
  
  String _getSyncModeName(SyncMode mode) {
    switch (mode) {
      case SyncMode.SYNC_MODE_BIDIRECTIONAL:
        return 'İki Yönlü';
      case SyncMode.SYNC_MODE_SEND_ONLY:
        return 'Sadece Gönder';
      case SyncMode.SYNC_MODE_RECEIVE_ONLY:
        return 'Sadece Al';
      default:
        return 'Bilinmeyen';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Folder sync dialog - tüm folder'ı peer'lara gönderir
class _SyncFolderDialog extends ConsumerStatefulWidget {
  final Folder folder;
  final List<peer_pb.Peer> peers;

  const _SyncFolderDialog({
    required this.folder,
    required this.peers,
  });

  @override
  ConsumerState<_SyncFolderDialog> createState() => _SyncFolderDialogState();
}

class _SyncFolderDialogState extends ConsumerState<_SyncFolderDialog> {
  final Map<String, SyncMode> _senderModes = {}; // peerId -> sender sync mode
  final Map<String, SyncMode> _receiverModes = {}; // peerId -> receiver sync mode

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncNotifierProvider);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(LucideIcons.folderSync, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text('Klasörü Senkronize Et')),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Klasör: ${widget.folder.localPath}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Klasördeki TÜM dosyalar gönderilecek',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
            SizedBox(height: 16),
            Text(
              'Peer Seç ve Sync Mode Belirle:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.peers.map((peer) {
                    final isSelected = _senderModes.containsKey(peer.deviceId);
                    final senderMode = _senderModes[peer.deviceId] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                    final receiverMode = _receiverModes[peer.deviceId] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _senderModes[peer.deviceId] = SyncMode.SYNC_MODE_BIDIRECTIONAL;
                                _receiverModes[peer.deviceId] = SyncMode.SYNC_MODE_BIDIRECTIONAL;
                              } else {
                                _senderModes.remove(peer.deviceId);
                                _receiverModes.remove(peer.deviceId);
                              }
                            });
                          },
                        ),
                        title: Text(peer.name),
                        subtitle: Text(peer.deviceId.substring(0, 8)),
                        initiallyExpanded: isSelected,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gönderici Sync Mode:',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                                SizedBox(height: 8),
                                ...SyncMode.values.where((m) => m != SyncMode.SYNC_MODE_UNSPECIFIED).map((mode) {
                                  return RadioListTile<SyncMode>(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_getSyncModeName(mode)),
                                    value: mode,
                                    groupValue: senderMode,
                                    onChanged: isSelected ? (value) {
                                      if (value != null) {
                                        setState(() {
                                          _senderModes[peer.deviceId] = value;
                                        });
                                      }
                                    } : null,
                                  );
                                }),
                                SizedBox(height: 16),
                                Text(
                                  'Alıcı Sync Mode:',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                                SizedBox(height: 8),
                                ...SyncMode.values.where((m) => m != SyncMode.SYNC_MODE_UNSPECIFIED).map((mode) {
                                  return RadioListTile<SyncMode>(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_getSyncModeName(mode)),
                                    value: mode,
                                    groupValue: receiverMode,
                                    onChanged: isSelected ? (value) {
                                      if (value != null) {
                                        setState(() {
                                          _receiverModes[peer.deviceId] = value;
                                        });
                                      }
                                    } : null,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (syncState.isLoading)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('Klasör senkronize ediliyor takip etmek için transferler kısmına bakın'),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: syncState.isLoading
              ? null
              : () => Navigator.pop(context),
          child: Text('İptal'),
        ),
        FilledButton(
          onPressed: syncState.isLoading || _senderModes.isEmpty
              ? null
              : () {
                  // Peer sync mode'larını oluştur
                  final peerSyncModes = _senderModes.entries.map((e) {
                    return PeerSyncMode()
                      ..peerId = e.key
                      ..senderMode = e.value
                      ..receiverMode = _receiverModes[e.key] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                  }).toList();
                  
                  // Dialog'u hemen kapat
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Klasör senkronizasyonu başlatıldı...'),
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  ref
                      .read(syncNotifierProvider.notifier)
                      .syncFolder(widget.folder.id, _senderModes.keys.toList(), peerSyncModes)
                      .then((response) async {
                        // Seçilen modları local settings'e kaydet
                        for (final entry in _senderModes.entries) {
                          await LocalSettingsService().savePeerSyncMode(
                            widget.folder.id, 
                            entry.key, 
                            entry.value
                          );
                        }
                      })
                      .catchError((error) {
                        print('Sync error: $error');
                      });
                },
          child: Text('Klasörü Senkronize Et'),
        ),
      ],
    );
  }
  
  String _getSyncModeName(SyncMode mode) {
    switch (mode) {
      case SyncMode.SYNC_MODE_BIDIRECTIONAL:
        return 'İki Yönlü';
      case SyncMode.SYNC_MODE_SEND_ONLY:
        return 'Sadece Gönder';
      case SyncMode.SYNC_MODE_RECEIVE_ONLY:
        return 'Sadece Al';
      default:
        return 'Bilinmeyen';
    }
  }
}

