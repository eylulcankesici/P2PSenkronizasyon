import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/file_provider.dart';
import 'package:aether_desktop/generated/api/proto/folder.pb.dart';
import 'package:aether_desktop/generated/api/proto/common.pb.dart';

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
              data: (files) => _buildFileList(context, files),
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

  Widget _buildFileList(BuildContext context, List files) {
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
}

