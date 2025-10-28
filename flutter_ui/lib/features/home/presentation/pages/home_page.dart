import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aether_desktop/data/providers/folder_provider.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/data/providers/transfer_provider.dart';
import 'package:aether_desktop/generated/api/proto/common.pb.dart';
import 'package:aether_desktop/features/home/presentation/pages/folder_detail_page.dart';
import 'package:aether_desktop/features/peers/presentation/pages/peers_page.dart';
import 'package:aether_desktop/features/peers/presentation/widgets/connection_request_dialog.dart';
import 'package:aether_desktop/features/transfers/presentation/pages/transfers_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Connection request listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToPendingConnections();
    });
  }
  
  void _listenToPendingConnections() {
    // Polling ile pending connections'ı kontrol et (her 1 saniyede bir)
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      // Provider'ı invalidate et ve yeni veriyi al
      ref.invalidate(pendingConnectionsProvider);
      ref.read(pendingConnectionsProvider.future).then((connections) {
        if (!mounted) return;
        
        // Mevcut state'i al
        final currentState = ref.read(pendingConnectionsNotifierProvider);
        final currentIds = currentState.map((p) => p.deviceId).toSet();
        
        // Yeni connection request'leri bul
        for (final connection in connections) {
          if (!currentIds.contains(connection.deviceId)) {
            // Yeni request - state'e ekle ve dialog göster
            ref.read(pendingConnectionsNotifierProvider.notifier).addPendingConnection(
              connection.deviceId,
              connection.deviceName,
            );
            
            // Dialog göster
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => ConnectionRequestDialog(
                  deviceId: connection.deviceId,
                  deviceName: connection.deviceName,
                ),
              );
            }
          }
        }
      }).catchError((error) {
        print('Pending connections polling hatası: $error');
      });
    });
  }

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(LucideIcons.folder),
      selectedIcon: Icon(LucideIcons.folder),
      label: 'Klasörler',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.monitor),
      selectedIcon: Icon(LucideIcons.monitor),
      label: 'Peer\'lar',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.download),
      selectedIcon: Icon(LucideIcons.download),
      label: 'Transferler',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.settings),
      selectedIcon: Icon(LucideIcons.settings),
      label: 'Ayarlar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.cloud, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Aether'),
          ],
        ),
        actions: [
          _buildSyncStatusWidget(),
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {},
            tooltip: 'Bildirimler',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddFolderDialog,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Klasör Ekle'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildFoldersPage();
      case 1:
        return const PeersPage();
      case 2:
        return const TransfersPage();
      case 3:
        return _buildSettingsPage();
      default:
        return _buildFoldersPage();
    }
  }

  Widget _buildFoldersPage() {
    final foldersAsync = ref.watch(foldersProvider);
    
    return foldersAsync.when(
      data: (folders) {
        if (folders.isEmpty) {
          return _buildEmptyFolderState();
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FolderDetailPage(folder: folder),
                    ),
                  );
                },
                leading: Icon(
                  LucideIcons.folder,
                  color: folder.isActive ? Colors.blue : Colors.grey,
                ),
                title: Text(folder.localPath),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getSyncModeText(folder.syncMode),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Son tarama: ${folder.hasLastScanTime() ? _formatDateTime(folder.lastScanTime.toDateTime()) : "Henüz taranmadı"}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (!folder.isActive)
                      Text(
                        'Pasif',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: folder.isActive,
                      onChanged: (value) {
                        ref
                            .read(folderNotifierProvider.notifier)
                            .toggleFolderActive(folder.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.trash),
                      onPressed: () {
                        _confirmDeleteFolder(folder.id, folder.localPath);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Hata: $error'),
      ),
    );
  }
  
  Widget _buildEmptyFolderState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.folder,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz senkronize klasör yok',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Başlamak için sağ alttaki "Klasör Ekle" butonuna tıklayın',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }


  Widget _buildSyncStatusWidget() {
    final connectedPeersAsync = ref.watch(connectedPeersProvider);
    final activeTransfers = ref.watch(activeTransfersProvider);
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Connected peers count
          connectedPeersAsync.when(
            data: (peers) => _buildStatusBadge(
              icon: LucideIcons.monitor,
              count: peers.length,
              color: peers.isEmpty ? Colors.grey : Colors.green,
              tooltip: '${peers.length} peer bağlı',
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          // Active transfers count
          if (activeTransfers.isNotEmpty)
            _buildStatusBadge(
              icon: LucideIcons.download,
              count: activeTransfers.length,
              color: Colors.blue,
              tooltip: '${activeTransfers.length} aktif transfer',
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge({
    required IconData icon,
    required int count,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.settings,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Ayarlar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Yakında...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddFolderDialog() async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Senkronize edilecek klasörü seçin',
    );

    if (result == null || !mounted) {
      return;
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => _AddFolderDialog(folderPath: result),
    );
  }

  String _getSyncModeText(SyncMode mode) {
    switch (mode) {
      case SyncMode.SYNC_MODE_BIDIRECTIONAL:
        return '↔️ İki Yönlü';
      case SyncMode.SYNC_MODE_RECEIVE_ONLY:
        return '⬇️ Sadece Al';
      case SyncMode.SYNC_MODE_SEND_ONLY:
        return '⬆️ Sadece Gönder';
      default:
        return 'Bilinmiyor';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Az önce';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Future<void> _confirmDeleteFolder(String folderId, String folderPath) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klasörü Sil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bu klasörü senkronizasyondan kaldırmak istediğinizden emin misiniz?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                folderPath,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Not: Yerel dosyalarınız silinmeyecek, sadece senkronizasyon durur.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(folderNotifierProvider.notifier).deleteFolder(folderId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Klasör silindi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

class _AddFolderDialog extends ConsumerStatefulWidget {
  final String folderPath;

  const _AddFolderDialog({required this.folderPath});

  @override
  ConsumerState<_AddFolderDialog> createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends ConsumerState<_AddFolderDialog> {
  SyncMode _selectedMode = SyncMode.SYNC_MODE_BIDIRECTIONAL;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Klasör Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seçilen Klasör:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.folder, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.folderPath,
                    style: const TextStyle(fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Senkronizasyon Modu:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          RadioListTile<SyncMode>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('İki Yönlü'),
            subtitle: const Text('Dosyalar her iki yönde de senkronize edilir'),
            value: SyncMode.SYNC_MODE_BIDIRECTIONAL,
            groupValue: _selectedMode,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedMode = value);
              }
            },
          ),
          RadioListTile<SyncMode>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Sadece Al'),
            subtitle: const Text('Bu cihaz sadece dosya alır'),
            value: SyncMode.SYNC_MODE_RECEIVE_ONLY,
            groupValue: _selectedMode,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedMode = value);
              }
            },
          ),
          RadioListTile<SyncMode>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Sadece Gönder'),
            subtitle: const Text('Bu cihaz sadece dosya gönderir'),
            value: SyncMode.SYNC_MODE_SEND_ONLY,
            groupValue: _selectedMode,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedMode = value);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _addFolder,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Ekle'),
        ),
      ],
    );
  }

  Future<void> _addFolder() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(folderNotifierProvider.notifier).addFolder(
            widget.folderPath,
            _selectedMode,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Klasör başarıyla eklendi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}





