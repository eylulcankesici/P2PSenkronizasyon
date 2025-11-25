import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/file.pb.dart';

/// Belirli bir klasördeki dosyaları getiren provider
final filesProvider = FutureProvider.family<List<File>, String>((ref, folderId) async {
  final client = ref.watch(grpcClientProvider);
  
  try {
    final request = ListFilesRequest()..folderId = folderId;
    final response = await client.fileService.listFiles(request);
    
    return response.files;
  } catch (e) {
    print('Dosyalar yüklenirken hata: $e');
    return [];
  }
});

/// Dosya işlemleri provider
class FileNotifier extends StateNotifier<AsyncValue<void>> {
  FileNotifier(this.ref) : super(const AsyncValue.data(null));
  
  final Ref ref;
  
  /// Dosya sil
  /// [deletePhysically] true ise bilgisayardan tamamen kaldırılır, false ise sadece uygulamadan kaldırılır
  Future<void> deleteFile(String fileId, String folderId, {bool deletePhysically = false}) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = DeleteFileRequest()
        ..fileId = fileId
        ..deletePhysically = deletePhysically;
      final response = await client.fileService.deleteFile(request);
      
      if (response.success) {
        // Dosya listesini yenile
        ref.invalidate(filesProvider(folderId));
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
}

final fileNotifierProvider = StateNotifierProvider<FileNotifier, AsyncValue<void>>((ref) {
  return FileNotifier(ref);
});

