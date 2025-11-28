import 'dart:async';
import 'dart:io';
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
import 'package:aether_desktop/features/home/presentation/widgets/connected_peers_widget.dart';
import 'package:aether_desktop/core/theme/app_theme.dart';
import 'package:aether_desktop/data/providers/user_provider.dart';
import 'package:aether_desktop/data/providers/theme_provider.dart';
import 'package:aether_desktop/data/providers/language_provider.dart';
import 'package:aether_desktop/core/localization/app_strings.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  Timer? _foldersRefreshTimer;
  late TextEditingController _nicknameController;
  
  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: ref.read(userProvider));
    // Connection request listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToPendingConnections();
      _startFoldersRefreshTimer();
      // Start Peer Monitor
      ref.read(peerMonitorProvider).start();
      // Start Transfer Polling
      ref.read(transferNotifierProvider);
    });
  }
  
  @override
  void dispose() {
    _foldersRefreshTimer?.cancel();
    _nicknameController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(LucideIcons.cloud, color: Colors.lightBlue.shade300),
            const SizedBox(width: 8),
            Text('Aether', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue.shade300)),
          ],
        ),
        actions: [
          const ConnectedPeersWidget(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.bell),
                onPressed: () {
                  // Show notifications
                  showDialog(
                    context: context,
                    builder: (context) => Stack(
                      children: [
                        Positioned(
                          top: 60,
                          right: 10,
                          child: _buildNotificationDropdown(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (ref.watch(unreadNotificationCountProvider) > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildFoldersPage(),
          const PeersPage(),
          const TransfersPage(),
          _buildProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: _getIndicatorColor(_selectedIndex),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.white);
            }
            return null; // Use default
          }),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(
                color: _getIndicatorColor(_selectedIndex),
                fontWeight: FontWeight.bold,
              );
            }
            return null;
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(LucideIcons.folder),
              selectedIcon: const Icon(LucideIcons.folderOpen),
              label: AppStrings.get('folders', ref.watch(languageProvider)),
            ),
            NavigationDestination(
              icon: const Icon(LucideIcons.monitor),
              selectedIcon: const Icon(LucideIcons.monitor),
              label: AppStrings.get('peers', ref.watch(languageProvider)),
            ),
            NavigationDestination(
              icon: const Icon(LucideIcons.arrowRightLeft),
              selectedIcon: const Icon(LucideIcons.arrowRightLeft),
              label: AppStrings.get('transfers', ref.watch(languageProvider)),
            ),
            NavigationDestination(
              icon: const Icon(LucideIcons.user),
              selectedIcon: const Icon(LucideIcons.userCheck),
              label: AppStrings.get('profile', ref.watch(languageProvider)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIndicatorColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Folders - Yellow/Amber
      case 1:
        return Colors.blue; // Peers - Blue
      case 2:
        return Colors.orange; // Transfers - Orange
      case 3:
        return Colors.purpleAccent; // Profile - Purple
      default:
        return Theme.of(context).primaryColor;
    }
  }

  Widget _buildFoldersPage() {
    final foldersAsync = ref.watch(foldersProvider);

    return foldersAsync.when(
      data: (folders) {
        if (folders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.folder, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  AppStrings.get('no_folders', ref.watch(languageProvider)),
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showAddFolderDialog,
                  icon: const Icon(LucideIcons.plus),
                  label: Text(AppStrings.get('add_folder', ref.watch(languageProvider))),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  LucideIcons.folder,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                title: Text(
                  folder.localPath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          folder.isActive ? LucideIcons.checkCircle : LucideIcons.pauseCircle,
                          size: 14,
                          color: folder.isActive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          folder.isActive 
                              ? AppStrings.get('active', ref.watch(languageProvider))
                              : AppStrings.get('inactive', ref.watch(languageProvider)),
                          style: TextStyle(
                            fontSize: 12,
                            color: folder.isActive ? Colors.green : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(LucideIcons.refreshCw, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          _getSyncModeText(folder.syncMode, ref.watch(languageProvider)),
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(LucideIcons.trash2, color: Colors.red),
                  onPressed: () => _confirmDeleteFolder(folder.id, folder.localPath),
                  tooltip: AppStrings.get('delete', ref.watch(languageProvider)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FolderDetailPage(folder: folder),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('${AppStrings.get('error', ref.watch(languageProvider))}: $error'),
      ),
    );
  }

  Widget _buildProfilePage() {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final currentLang = ref.watch(languageProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: ref.watch(profileImageProvider) != null
                          ? FileImage(File(ref.watch(profileImageProvider)!))
                          : null,
                      child: ref.watch(profileImageProvider) == null
                          ? Text(
                              ref.watch(userProvider).isNotEmpty
                                  ? ref.watch(userProvider)[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showProfileOptions,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          LucideIcons.pencil,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('profile', currentLang),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '${Platform.localHostname} (${Platform.operatingSystem})',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              // Auth Buttons
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Login logic
                    },
                    child: Text(AppStrings.get('login', currentLang)),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      // Signup logic
                    },
                    child: Text(AppStrings.get('signup', currentLang)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Nickname Section
          Text(
            AppStrings.get('nickname', currentLang),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    hintText: AppStrings.get('enter_nickname', currentLang),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    prefixIcon: const Icon(LucideIcons.user, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _saveNickname,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                ),
                child: Text(AppStrings.get('save', currentLang)),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Appearance Section
          Text(
            AppStrings.get('appearance', currentLang),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark ? LucideIcons.moon : LucideIcons.sun,
                      color: isDark ? Colors.blue : Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      isDark 
                          ? AppStrings.get('dark_mode', currentLang)
                          : AppStrings.get('light_mode', currentLang),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Switch(
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Language Section
          Text(
            AppStrings.get('language', currentLang),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLanguageOption('tr', 'Türkçe', currentLang == 'tr'),
              const SizedBox(width: 16),
              _buildLanguageOption('en', 'English', currentLang == 'en'),
              const SizedBox(width: 16),
              _buildLanguageOption('de', 'Deutsch', currentLang == 'de'),
            ],
          ),
          const SizedBox(height: 32),

          // Subscription Section
          Text(
            AppStrings.get('subscription', currentLang),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTierBadge('Basic', true),
              const SizedBox(width: 16),
              _buildTierBadge('Plus', false),
              const SizedBox(width: 16),
              _buildTierBadge('Pro', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return InkWell(
      onTap: () {
        ref.read(languageProvider.notifier).setLanguage(code);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              code.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.green : unselectedColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.green : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierBadge(String name, bool isActive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark ? Colors.grey[400] : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? LucideIcons.checkCircle : LucideIcons.circle,
            size: 16,
            color: isActive ? Colors.green : unselectedColor,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.green : unselectedColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showProfileOptions() async {
    final hasImage = ref.read(profileImageProvider) != null;
    final currentLang = ref.read(languageProvider);

    if (!hasImage) {
      // If no image, directly pick one (or show just one option, but direct pick is better UX usually, 
      // but user asked for "Profil fotoğrafı yükle" option specifically if I follow strictly)
      // User said: "ona basınca seçenek açılsın... 'Profil fotoğrafı yükle' yazsın"
      // So I should show a bottom sheet/dialog even if no image.
      
      await showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(LucideIcons.upload),
                title: Text(AppStrings.get('upload_profile_photo', currentLang)),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage();
                },
              ),
            ],
          ),
        ),
      );
    } else {
      // If image exists: "Profil fotoğrafını sil" and "Profil fotoğrafını değiştir"
      await showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(LucideIcons.refreshCw),
                title: Text(AppStrings.get('change_profile_photo', currentLang)),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage();
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.trash2, color: Colors.red),
                title: Text(AppStrings.get('remove_profile_photo', currentLang), style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(profileImageProvider.notifier).removeImage();
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Profil fotoğrafı seçin',
    );

    if (result != null && result.files.single.path != null) {
      ref.read(profileImageProvider.notifier).setImage(result.files.single.path!);
    }
  }

  void _saveNickname() {
    final newNickname = _nicknameController.text;
    ref.read(userProvider.notifier).setNickname(newNickname);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.get('name_saved', ref.read(languageProvider))),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
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

  String _getSyncModeText(SyncMode mode, String lang) {
    switch (mode) {
      case SyncMode.SYNC_MODE_BIDIRECTIONAL:
        return '↔️ ${AppStrings.get('sync_bidirectional', lang)}';
      case SyncMode.SYNC_MODE_RECEIVE_ONLY:
        return '⬇️ ${AppStrings.get('sync_receive_only', lang)}';
      case SyncMode.SYNC_MODE_SEND_ONLY:
        return '⬆️ ${AppStrings.get('sync_send_only', lang)}';
      case SyncMode.SYNC_MODE_UNSPECIFIED:
        return '❓ ${AppStrings.get('sync_unspecified', lang)}';
      default:
        return AppStrings.get('unknown_status', lang);
    }
  }

  String _formatDateTime(DateTime dateTime, String lang) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return AppStrings.get('just_now', lang);
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} ${AppStrings.get('minutes_ago', lang)}';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ${AppStrings.get('hours_ago', lang)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${AppStrings.get('days_ago', lang)}';
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
          title: Text(AppStrings.get('delete_folder_title', ref.watch(languageProvider))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.get('delete_folder_message', ref.watch(languageProvider))),
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
      
      await ref.read(folderNotifierProvider.notifier).deleteFolder(
        folderId,
        deletePhysically: shouldDeletePhysically,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              shouldDeletePhysically
                  ? AppStrings.get('folder_deleted_physically', ref.read(languageProvider))
                  : AppStrings.get('folder_removed_app', ref.read(languageProvider)),
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
                  Text(
                    AppStrings.get('notifications', ref.watch(languageProvider)), // You might need to add 'notifications' key
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    child: Text(AppStrings.get('clear', ref.watch(languageProvider)), style: const TextStyle(fontSize: 12)), // You might need to add 'clear' key
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
                            AppStrings.get('no_notifications', ref.watch(languageProvider)),
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
                                        _formatDateTime(notification.timestamp, ref.watch(languageProvider)),
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
      title: Text(AppStrings.get('add_folder', ref.watch(languageProvider))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.get('selected_folder', ref.watch(languageProvider)),
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
            AppStrings.get('sync_mode_selection_info', ref.watch(languageProvider)),
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
          child: Text(AppStrings.get('cancel', ref.watch(languageProvider))),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _addFolder,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppStrings.get('add', ref.watch(languageProvider))),
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
          SnackBar(
            content: Text(AppStrings.get('folder_added_success', ref.read(languageProvider))),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.get('error', ref.read(languageProvider))}: $e'),
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





