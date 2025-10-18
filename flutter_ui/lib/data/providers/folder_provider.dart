import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/folder.pb.dart';
import 'package:aether_desktop/generated/api/proto/common.pb.dart';

/// Klasör listesi provider
final foldersProvider = FutureProvider<List<Folder>>((ref) async {
  final client = ref.watch(grpcClientProvider);
  
  try {
    final response = await client.folderService.listFolders(
      ListFoldersRequest(activeOnly: false),
    );
    
    return response.folders;
  } catch (e) {
    print('Klasörler yüklenirken hata: $e');
    return [];
  }
});

/// Klasör ekleme provider
class FolderNotifier extends StateNotifier<AsyncValue<void>> {
  FolderNotifier(this.ref) : super(const AsyncValue.data(null));
  
  final Ref ref;
  
  /// Yeni klasör ekle
  Future<void> addFolder(String path, SyncMode syncMode) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final response = await client.folderService.createFolder(
        CreateFolderRequest(
          localPath: path,
          syncMode: syncMode,
        ),
      );
      
      if (response.status.success) {
        // Klasör listesini yenile
        ref.invalidate(foldersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.status.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Klasör sil
  Future<void> deleteFolder(String folderId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final response = await client.folderService.deleteFolder(
        DeleteFolderRequest(id: folderId),
      );
      
      if (response.success) {
        // Klasör listesini yenile
        ref.invalidate(foldersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Klasör aktif/pasif durumunu değiştir
  Future<void> toggleFolderActive(String folderId) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final response = await client.folderService.toggleFolderActive(
        ToggleFolderActiveRequest(id: folderId),
      );
      
      if (response.status.success) {
        // Klasör listesini yenile
        ref.invalidate(foldersProvider);
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.status.message,
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final folderNotifierProvider = StateNotifierProvider<FolderNotifier, AsyncValue<void>>((ref) {
  return FolderNotifier(ref);
});

