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

    return Scaffold(
      appBar: AppBar(
        title: Text('Klasör Detayı'),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.folderSync),
            onPressed: () {
              _showSyncFolderDialog(context, ref);
            },
            tooltip: 'Tüm Klasörü Senkronize Et',
          ),
          IconButton(
            icon: Icon(LucideIcons.refreshCw),
            onPressed: () {
              ref.invalidate(filesProvider(widget.folder.id));
            },
            tooltip: 'Manuel Yenile (Otomatik: 2sn)',
          ),
        ],
      ),
      body: Column(
        children: [
          // Klasör bilgileri
          _buildFolderInfo(context),
          Divider(),
          
          // Dosya listesi
          Expanded(
            child: filesAsync.when(
              data: (files) => _buildFileList(context, ref, files),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Dosyalar yüklenirken hata oluştu'),
                    SizedBox(height: 8),
                    Text(error.toString(), style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderInfo(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.folder, size: 32, color: Theme.of(context).primaryColor),
                SizedBox(width: 12),
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
                      SizedBox(height: 4),
                      Text(
                        _getSyncModeText(widget.folder.syncMode),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(
                  context,
                  icon: LucideIcons.clock,
                  label: 'Son Tarama',
                  value: _formatDateTime(widget.folder.lastScanTime.toDateTime()),
                ),
                _buildInfoChip(
                  context,
                  icon: widget.folder.isActive ? LucideIcons.checkCircle : LucideIcons.pauseCircle,
                  label: 'Durum',
                  value: widget.folder.isActive ? 'Aktif' : 'Pasif',
                ),
              ],
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
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildFileList(BuildContext context, WidgetRef ref, List files) {
    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.fileX, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Bu klasörde dosya bulunamadı'),
            SizedBox(height: 8),
            Text(
              'Klasör boş olabilir veya henüz taranmamış olabilir',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: files.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final file = files[index];
        return Card(
          margin: EdgeInsets.only(bottom: 8),
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
                // Sync bilgilerini göster (dosya yolunun altında)
                Consumer(
                  builder: (context, ref, child) {
                    final fileInfoAsync = ref.watch(fileInfoProvider(file.id));
                    return fileInfoAsync.when(
                      data: (fileInfo) {
                        if (fileInfo == null || fileInfo.syncInfo.isEmpty) {
                          return SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: fileInfo.syncInfo.map((syncInfo) {
                              // Gönderen bilgisi
                              final senderName = syncInfo.senderDeviceName.isEmpty 
                                  ? syncInfo.senderDeviceId.substring(0, 8) 
                                  : syncInfo.senderDeviceName;
                              // Alıcı bilgisi - receiverDeviceName kullan, boşsa receiverDeviceId'den çıkar
                              final receiverName = syncInfo.receiverDeviceName.isEmpty 
                                  ? (syncInfo.receiverDeviceId.isEmpty 
                                      ? 'Bilinmeyen' 
                                      : syncInfo.receiverDeviceId.substring(0, 8))
                                  : syncInfo.receiverDeviceName;
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.userCheck, size: 10, color: Colors.blue),
                                    SizedBox(width: 4),
                                    Text(
                                      'Gönderen: $senderName',
                                      style: TextStyle(fontSize: 10, color: Colors.blue.shade700),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(LucideIcons.user, size: 10, color: Colors.green),
                                    SizedBox(width: 4),
                                    Text(
                                      'Alan: $receiverName',
                                      style: TextStyle(fontSize: 10, color: Colors.green.shade700),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                      loading: () => SizedBox.shrink(),
                      error: (_, __) => SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Icon(LucideIcons.hardDrive, size: 12, color: Colors.grey),
                SizedBox(width: 4),
                Text(_formatFileSize(file.size.toInt())),
                SizedBox(width: 16),
                Icon(LucideIcons.clock, size: 12, color: Colors.grey),
                SizedBox(width: 4),
                Text(_formatDateTime(file.modTime.toDateTime())),
              ],
            ),
            trailing: PopupMenuButton(
              icon: Icon(LucideIcons.moreVertical),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(LucideIcons.send, size: 16),
                      SizedBox(width: 8),
                      Text('Senkronize Et'),
                    ],
                  ),
                  onTap: () {
                    // PopupMenu kapandıktan sonra dialog'u göster
                    Future.delayed(Duration(milliseconds: 100), () {
                      _showSyncDialog(context, ref, file);
                    });
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(LucideIcons.info, size: 16),
                      SizedBox(width: 8),
                      Text('Detaylar'),
                    ],
                  ),
                  onTap: () {
                    // TODO: Dosya detay sayfası
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(LucideIcons.download, size: 16),
                      SizedBox(width: 8),
                      Text('İndir'),
                    ],
                  ),
                  onTap: () {
                    // TODO: Dosya indirme
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Sil', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    // PopupMenu kapandıktan sonra dialog'u göster
                    Future.delayed(Duration(milliseconds: 100), () {
                      _showDeleteFileDialog(context, ref, file);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteFileDialog(BuildContext context, WidgetRef ref, file_pb.File file) {
    bool deletePhysically = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Dosyayı Sil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dosya: ${file.relativePath}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Boyut: ${_formatFileSize(file.size.toInt())}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: const Text(
                  'Bilgisayarımdan tamamen kaldır',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'İşaretlenirse dosya bilgisayardan silinir',
                  style: TextStyle(fontSize: 11, color: Colors.red),
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
              SizedBox(height: 8),
              Text(
                deletePhysically
                    ? '⚠️ UYARI: Dosya bilgisayardan silinecek!'
                    : 'ℹ️ Dosya sadece uygulamadan kaldırılacak, fiziksel dosya korunacak.',
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                await ref.read(fileNotifierProvider.notifier).deleteFile(
                  file.id,
                  file.folderId,
                  deletePhysically: deletePhysically,
                );
                
                if (context.mounted) {
                  final fileState = ref.read(fileNotifierProvider);
                  if (!fileState.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          deletePhysically
                              ? 'Dosya bilgisayardan tamamen silindi'
                              : 'Dosya uygulamadan kaldırıldı (fiziksel dosya korundu)',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hata: ${fileState.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: deletePhysically ? Colors.red : Colors.orange,
              ),
              child: Text(deletePhysically ? 'Tamamen Sil' : 'Uygulamadan Kaldır'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String path) {
    final ext = path.toLowerCase().split('.').last;
    
    switch (ext) {
      case 'txt':
      case 'doc':
      case 'docx':
      case 'pdf':
        return LucideIcons.fileText;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return LucideIcons.fileImage;
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov':
        return LucideIcons.fileVideo;
      case 'mp3':
      case 'wav':
      case 'flac':
        return LucideIcons.fileAudio;
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return LucideIcons.fileArchive;
      default:
        return LucideIcons.file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _getSyncModeText(SyncMode mode) {
    switch (mode) {
      case SyncMode.SYNC_MODE_BIDIRECTIONAL:
        return '📡 Çift Yönlü Senkronizasyon';
      case SyncMode.SYNC_MODE_SEND_ONLY:
        return '⬆️ Sadece Gönder';
      case SyncMode.SYNC_MODE_RECEIVE_ONLY:
        return '⬇️ Sadece Al';
      default:
        return 'Bilinmiyor';
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null || dateTime.year == 1) {
      return 'Henüz taranmadı';
    }
    
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inHours < 1) return '${diff.inMinutes} dakika önce';
    if (diff.inDays < 1) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    
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
              : () async {
                  // Peer sync mode'larını oluştur
                  final peerSyncModes = _senderModes.entries.map((e) {
                    return PeerSyncMode()
                      ..peerId = e.key
                      ..senderMode = e.value
                      ..receiverMode = _receiverModes[e.key] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                  }).toList();
                  
                  await ref
                      .read(syncNotifierProvider.notifier)
                      .syncFile(widget.file.id, _senderModes.keys.toList(), peerSyncModes);
                  
                  if (mounted) {
                    final newState = ref.read(syncNotifierProvider);
                    if (!newState.hasError) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Dosya başarıyla senkronize edildi'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Hata: ${newState.error}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
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
                    Text('Klasör senkronize ediliyor...'),
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
              : () async {
                  // Peer sync mode'larını oluştur
                  final peerSyncModes = _senderModes.entries.map((e) {
                    return PeerSyncMode()
                      ..peerId = e.key
                      ..senderMode = e.value
                      ..receiverMode = _receiverModes[e.key] ?? SyncMode.SYNC_MODE_BIDIRECTIONAL;
                  }).toList();
                  
                  final response = await ref
                      .read(syncNotifierProvider.notifier)
                      .syncFolder(widget.folder.id, _senderModes.keys.toList(), peerSyncModes);
                  
                  if (mounted && response != null) {
                    final newState = ref.read(syncNotifierProvider);
                    if (!newState.hasError) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Klasör başarıyla senkronize edildi\n'
                            '${response.syncedFiles}/${response.totalFiles} dosya gönderildi'
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 4),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Hata: ${newState.error}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
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

