import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aether_desktop/data/providers/transfer_provider.dart';

class TransfersPage extends ConsumerStatefulWidget {
  const TransfersPage({super.key});

  @override
  ConsumerState<TransfersPage> createState() => _TransfersPageState();
}

class _TransfersPageState extends ConsumerState<TransfersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosya Transferleri'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: () {
              ref.read(transferNotifierProvider.notifier).clearCompleted();
            },
            tooltip: 'Tamamlananları Temizle',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(LucideIcons.download),
              text: 'Aktif',
            ),
            Tab(
              icon: Icon(LucideIcons.checkCircle),
              text: 'Tamamlandı',
            ),
            Tab(
              icon: Icon(LucideIcons.xCircle),
              text: 'Başarısız',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTransfersTab(),
          _buildCompletedTransfersTab(),
          _buildFailedTransfersTab(),
        ],
      ),
    );
  }

  Widget _buildActiveTransfersTab() {
    final activeTransfers = ref.watch(activeTransfersProvider);

    if (activeTransfers.isEmpty) {
      return _buildEmptyState(
        icon: LucideIcons.download,
        title: 'Aktif Transfer Yok',
        message: 'Dosya transferleri burada görünecek.',
      );
    }

    return ListView.builder(
      itemCount: activeTransfers.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return _buildTransferCard(activeTransfers[index], showProgress: true);
      },
    );
  }

  Widget _buildCompletedTransfersTab() {
    final completedTransfers = ref.watch(completedTransfersProvider);

    if (completedTransfers.isEmpty) {
      return _buildEmptyState(
        icon: LucideIcons.checkCircle,
        title: 'Tamamlanan Transfer Yok',
        message: 'Tamamlanan transferler burada görünecek.',
      );
    }

    return ListView.builder(
      itemCount: completedTransfers.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return _buildTransferCard(completedTransfers[index]);
      },
    );
  }

  Widget _buildFailedTransfersTab() {
    final failedTransfers = ref.watch(failedTransfersProvider);

    if (failedTransfers.isEmpty) {
      return _buildEmptyState(
        icon: LucideIcons.checkCircle,
        title: 'Başarısız Transfer Yok',
        message: 'Başarısız transferler burada görünecek.',
      );
    }

    return ListView.builder(
      itemCount: failedTransfers.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return _buildTransferCard(failedTransfers[index]);
      },
    );
  }

  Widget _buildTransferCard(TransferState transfer, {bool showProgress = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // File icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getStatusColor(transfer).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getFileIcon(transfer.fileName),
                    color: _getStatusColor(transfer),
                  ),
                ),
                const SizedBox(width: 16),
                // Transfer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transfer.fileName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.monitor,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            transfer.peerName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            _getStatusIcon(transfer),
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            transfer.statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action button
                if (!transfer.isComplete && !transfer.isFailed)
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20),
                    onPressed: () {
                      ref.read(transferNotifierProvider.notifier).removeTransfer(transfer.fileId);
                    },
                    tooltip: 'İptal',
                  ),
                if (transfer.isComplete || transfer.isFailed)
                  IconButton(
                    icon: const Icon(LucideIcons.trash2, size: 20),
                    onPressed: () {
                      ref.read(transferNotifierProvider.notifier).removeTransfer(transfer.fileId);
                    },
                    tooltip: 'Kaldır',
                  ),
              ],
            ),
            if (showProgress && !transfer.isComplete) ...[
              const SizedBox(height: 12),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: transfer.progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(transfer)),
                ),
              ),
              const SizedBox(height: 8),
              // Progress details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${transfer.progressPercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${transfer.completedChunks}/${transfer.totalChunks} chunks',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    transfer.speedText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            if (transfer.isComplete || transfer.isFailed) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatBytes(transfer.totalBytes),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (transfer.endTime != null)
                    Text(
                      _formatDuration(transfer.elapsed),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
            if (transfer.isFailed && transfer.errorMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.alertCircle, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        transfer.errorMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TransferState transfer) {
    if (transfer.isFailed) return Colors.red;
    if (transfer.isComplete) return Colors.green;
    return Colors.blue;
  }

  IconData _getStatusIcon(TransferState transfer) {
    if (transfer.isFailed) return LucideIcons.xCircle;
    if (transfer.isComplete) return LucideIcons.checkCircle;
    return LucideIcons.download;
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
      case 'avi':
      case 'mov':
        return LucideIcons.video;
      case 'mp3':
      case 'wav':
      case 'flac':
        return LucideIcons.music;
      case 'zip':
      case 'rar':
      case '7z':
        return LucideIcons.fileArchive;
      default:
        return LucideIcons.file;
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
  }
}


