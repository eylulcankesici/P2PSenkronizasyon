import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aether_desktop/data/providers/folder_provider.dart';
import 'package:aether_desktop/data/providers/peer_provider.dart';
import 'package:aether_desktop/data/providers/transfer_provider.dart';
import 'package:aether_desktop/data/providers/notification_provider.dart';
import 'package:aether_desktop/generated/api/proto/common.pb.dart';
import 'package:aether_desktop/features/home/presentation/pages/folder_detail_page.dart';
import 'package:aether_desktop/features/peers/presentation/pages/peers_page.dart';
import 'package:aether_desktop/features/peers/presentation/widgets/connection_request_dialog.dart';
import 'package:aether_desktop/features/transfers/presentation/pages/transfers_page.dart';
import 'package:aether_desktop/features/home/presentation/managers/peer_monitor.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  Timer? _foldersRefreshTimer;
  
  @override
  void initState() {
    super.initState();
    // Connection request listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToPendingConnections();
      _startFoldersRefreshTimer();
      // Start Peer Monitor
      ref.read(peerMonitorProvider).start();
    });
  }
  
  @override
  void dispose() {
    _foldersRefreshTimer?.cancel();
    super.dispose();
  }
  
  /// Klasörler sekmesini periyodik olarak yenile (dosya alma işlemleri için)
  void _startFoldersRefreshTimer() {
    // Her 5 saniyede bir klasörleri yenile (dosya alma işlemlerini algılamak için)
    _foldersRefreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      // Klasörler sekmesinde isek ve klasörler provider'ı varsa yenile
      if (_selectedIndex == 0) {
        ref.invalidate(foldersProvider);
      }
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
                barrierDismissible: false,
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

  bool _isNotificationDropdownOpen = false;

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
          Consumer(
            builder: (context, ref, child) {
              final unreadCount = ref.watch(unreadNotificationCountProvider);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.bell),
                    onPressed: () {
                      setState(() {
                        _isNotificationDropdownOpen = !_isNotificationDropdownOpen;
                      });
                    },
                    tooltip: 'Bildirimler',
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Main Content
          GestureDetector(
            onTap: () {
              if (_isNotificationDropdownOpen) {
                setState(() {
                  _isNotificationDropdownOpen = false;
                });
              }
            },
            behavior: HitTestBehavior.translucent,
            child: _buildBody(),
          ),
          
          // Notification Dropdown Overlay
          if (_isNotificationDropdownOpen)
            Positioned(
              top: 0,
              right: 8,
              child: _buildNotificationDropdown(),
            ),
        ],
      ),
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
            _isNotificationDropdownOpen = false; // Close dropdown on nav change
          });
          
          // Klasörler sekmesine geçildiğinde klasörleri yenile
          if (index == 0) {
            ref.invalidate(foldersProvider);
          }
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
      case SyncMode.SYNC_MODE_UNSPECIFIED:
        return '❓ Henüz Belirlenmemiş';
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
    bool deletePhysically = false;
    
    final confirmed = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text(
                  'Bilgisayarımdan tamamen kaldır',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'İşaretlenirse klasör ve tüm dosyalar bilgisayardan silinir',
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
              const SizedBox(height: 8),
              Text(
                deletePhysically
                    ? '⚠️ UYARI: Klasör ve tüm içeriği bilgisayardan silinecek!'
                    : 'ℹ️ Klasör sadece uygulamadan kaldırılacak, dosyalar korunacak.',
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
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop({
                'confirmed': true,
                'deletePhysically': deletePhysically,
              }),
              style: FilledButton.styleFrom(
                backgroundColor: deletePhysically ? Colors.red : Colors.orange,
              ),
              child: Text(deletePhysically ? 'Tamamen Sil' : 'Uygulamadan Kaldır'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != null && confirmed['confirmed'] == true) {
      final shouldDeletePhysically = confirmed['deletePhysically'] as bool? ?? false;
      
      await ref.read(folderNotifierProvider.notifier).deleteFolder(
        folderId,
        deletePhysically: shouldDeletePhysically,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              shouldDeletePhysically
                  ? 'Klasör bilgisayardan tamamen silindi'
                  : 'Klasör uygulamadan kaldırıldı (dosyalar korundu)',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Widget _buildNotificationDropdown() {
    return Card(
      elevation: 8,
      color: const Color(0xFF1E293B), // Koyu mavi/gri tonu (Slate 800)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 350,
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bildirimler',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).clearAll();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Temizle', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: Consumer(
                builder: (context, ref, child) {
                  final notifications = ref.watch(notificationsProvider);
                  
                  if (notifications.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.bellOff, size: 32, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'Bildirim yok',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Dismissible(
                        key: Key(notification.id),
                        onDismissed: (_) {
                          ref.read(notificationsProvider.notifier).removeNotification(notification.id);
                        },
                        background: Container(color: Colors.red),
                        child: InkWell(
                          onTap: () {
                            ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                          },
                          child: Container(
                            color: notification.isRead ? null : Colors.blue.withOpacity(0.05),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: notification.color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(notification.icon, color: notification.color, size: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.title,
                                        style: TextStyle(
                                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        notification.message,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDateTime(notification.timestamp),
                                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFolderDialog extends ConsumerStatefulWidget {
  final String folderPath;

  const _AddFolderDialog({required this.folderPath});

  @override
  ConsumerState<_AddFolderDialog> createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends ConsumerState<_AddFolderDialog> {
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
          const SizedBox(height: 16),
          Text(
            'Senkronizasyon modu, dosyayı gönderirken seçilebilir.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
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
      // Henüz senkronizasyon modu belirlenmemiş (senkronizasyon modu gönderirken seçilecek)
      await ref.read(folderNotifierProvider.notifier).addFolder(
            widget.folderPath,
            SyncMode.SYNC_MODE_UNSPECIFIED,
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





