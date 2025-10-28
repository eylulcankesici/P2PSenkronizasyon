import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/file_provider.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/data/providers/sync_provider.dart';
import 'package:aether_desktop/generated/api/proto/folder.pb.dart';
import 'package:aether_desktop/generated/api/proto/common.pb.dart';
import 'package:aether_desktop/generated/api/proto/file.pb.dart' as file_pb;
import 'package:aether_desktop/generated/api/proto/peer.pb.dart' as peer_pb;

class FolderDetailPage extends ConsumerWidget {
  final Folder folder;

  const FolderDetailPage({
    super.key,
    required this.folder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(filesProvider(folder.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Klasör Detayı'),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.refreshCw),
            onPressed: () {
              ref.invalidate(filesProvider(folder.id));
            },
            tooltip: 'Yenile',
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
                        folder.localPath,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _getSyncModeText(folder.syncMode),
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
                  value: _formatDateTime(folder.lastScanTime.toDateTime()),
                ),
                _buildInfoChip(
                  context,
                  icon: folder.isActive ? LucideIcons.checkCircle : LucideIcons.pauseCircle,
                  label: 'Durum',
                  value: folder.isActive ? 'Aktif' : 'Pasif',
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
            title: Text(
              file.relativePath,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
              ],
            ),
          ),
        );
      },
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
  final Set<String> _selectedPeerIds = {};

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncNotifierProvider);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(LucideIcons.send, size: 20),
          SizedBox(width: 8),
          Text('Dosyayı Senkronize Et'),
        ],
      ),
      content: Column(
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
            'Peer Seç:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.peers.map((peer) {
                  final isSelected = _selectedPeerIds.contains(peer.deviceId);
                  
                  return CheckboxListTile(
                    title: Text(peer.name),
                    subtitle: Text(peer.deviceId.substring(0, 8)),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedPeerIds.add(peer.deviceId);
                        } else {
                          _selectedPeerIds.remove(peer.deviceId);
                        }
                      });
                    },
                    dense: true,
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
      actions: [
        TextButton(
          onPressed: syncState.isLoading
              ? null
              : () => Navigator.pop(context),
          child: Text('İptal'),
        ),
        FilledButton(
          onPressed: syncState.isLoading || _selectedPeerIds.isEmpty
              ? null
              : () async {
                  await ref
                      .read(syncNotifierProvider.notifier)
                      .syncFile(widget.file.id, _selectedPeerIds.toList());
                  
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

