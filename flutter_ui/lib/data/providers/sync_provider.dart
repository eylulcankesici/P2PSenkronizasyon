import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/sync.pb.dart';
import 'package:aether_desktop/generated/api/proto/sync.pbgrpc.dart';

/// Sync işlemleri notifier
class SyncNotifier extends StateNotifier<AsyncValue<void>> {
  SyncNotifier(this.ref) : super(const AsyncValue.data(null));
  
  final Ref ref;
  
  /// Dosyayı peer'lara senkronize et
  Future<void> syncFile(String fileId, List<String> targetPeerIds) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(grpcClientProvider);
      
      final request = SyncFileRequest()
        ..fileId = fileId
        ..targetPeerIds.addAll(targetPeerIds);
      
      final response = await client.syncService.syncFile(request);
      
      if (response.status.success) {
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

/// Sync notifier provider
final syncNotifierProvider = StateNotifierProvider<SyncNotifier, AsyncValue<void>>((ref) {
  return SyncNotifier(ref);
});

