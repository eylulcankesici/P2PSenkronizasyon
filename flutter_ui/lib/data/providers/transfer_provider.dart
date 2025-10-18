import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/p2p.pb.dart';

/// Transfer durumu modeli
class TransferState {
  final String fileId;
  final String fileName;
  final String peerId;
  final String peerName;
  final int totalChunks;
  final int completedChunks;
  final int totalBytes;
  final int transferredBytes;
  final bool isComplete;
  final bool isFailed;
  final String? errorMessage;
  final DateTime startTime;
  final DateTime? endTime;
  
  TransferState({
    required this.fileId,
    required this.fileName,
    required this.peerId,
    required this.peerName,
    this.totalChunks = 0,
    this.completedChunks = 0,
    this.totalBytes = 0,
    this.transferredBytes = 0,
    this.isComplete = false,
    this.isFailed = false,
    this.errorMessage,
    DateTime? startTime,
    this.endTime,
  }) : startTime = startTime ?? DateTime.now();
  
  double get progress {
    if (totalChunks == 0) return 0;
    return completedChunks / totalChunks;
  }
  
  double get progressPercentage => progress * 100;
  
  Duration get elapsed => DateTime.now().difference(startTime);
  
  String get speedText {
    if (transferredBytes == 0 || elapsed.inSeconds == 0) return '0 KB/s';
    
    final bytesPerSecond = transferredBytes / elapsed.inSeconds;
    
    if (bytesPerSecond < 1024) {
      return '${bytesPerSecond.toStringAsFixed(0)} B/s';
    } else if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
  }
  
  String get statusText {
    if (isFailed) return 'Başarısız';
    if (isComplete) return 'Tamamlandı';
    return 'Transfer ediliyor...';
  }
  
  TransferState copyWith({
    int? completedChunks,
    int? transferredBytes,
    bool? isComplete,
    bool? isFailed,
    String? errorMessage,
    DateTime? endTime,
  }) {
    return TransferState(
      fileId: fileId,
      fileName: fileName,
      peerId: peerId,
      peerName: peerName,
      totalChunks: totalChunks,
      completedChunks: completedChunks ?? this.completedChunks,
      totalBytes: totalBytes,
      transferredBytes: transferredBytes ?? this.transferredBytes,
      isComplete: isComplete ?? this.isComplete,
      isFailed: isFailed ?? this.isFailed,
      errorMessage: errorMessage ?? this.errorMessage,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

/// Aktif transferler notifier
class TransferNotifier extends StateNotifier<Map<String, TransferState>> {
  TransferNotifier(this.ref) : super({});
  
  final Ref ref;
  
  /// Dosya transferi başlat
  Future<void> requestFileFromPeer({
    required String peerId,
    required String peerName,
    required String fileId,
    required String fileName,
    required int totalBytes,
  }) async {
    // Transfer state'i oluştur
    final transfer = TransferState(
      fileId: fileId,
      fileName: fileName,
      peerId: peerId,
      peerName: peerName,
      totalBytes: totalBytes,
    );
    
    // State'e ekle
    state = {...state, fileId: transfer};
    
    try {
      final client = ref.read(grpcClientProvider);
      
      // Backend'e request gönder (placeholder - gerçek API implementasyonu gerekli)
      // final response = await client.p2pService.requestFile(...);
      
      // Simüle edilmiş progress güncellemesi
      // Gerçek implementasyonda backend'den stream olarak gelecek
      await _simulateTransfer(fileId);
      
    } catch (e) {
      // Hata durumunda state'i güncelle
      _updateTransfer(
        fileId,
        isFailed: true,
        errorMessage: e.toString(),
        endTime: DateTime.now(),
      );
    }
  }
  
  /// Transfer progress güncelle
  void _updateTransfer(
    String fileId, {
    int? completedChunks,
    int? transferredBytes,
    bool? isComplete,
    bool? isFailed,
    String? errorMessage,
    DateTime? endTime,
  }) {
    final current = state[fileId];
    if (current == null) return;
    
    state = {
      ...state,
      fileId: current.copyWith(
        completedChunks: completedChunks,
        transferredBytes: transferredBytes,
        isComplete: isComplete,
        isFailed: isFailed,
        errorMessage: errorMessage,
        endTime: endTime,
      ),
    };
  }
  
  /// Transfer'ı sil (history'den kaldır)
  void removeTransfer(String fileId) {
    final newState = Map<String, TransferState>.from(state);
    newState.remove(fileId);
    state = newState;
  }
  
  /// Tüm tamamlanan transferleri temizle
  void clearCompleted() {
    state = Map.fromEntries(
      state.entries.where((entry) => !entry.value.isComplete),
    );
  }
  
  /// Simüle edilmiş transfer (test için)
  Future<void> _simulateTransfer(String fileId) async {
    final transfer = state[fileId];
    if (transfer == null) return;
    
    // 10 chunk olduğunu varsay
    final totalChunks = 10;
    final chunkSize = transfer.totalBytes ~/ totalChunks;
    
    for (int i = 1; i <= totalChunks; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _updateTransfer(
        fileId,
        completedChunks: i,
        transferredBytes: i * chunkSize,
        isComplete: i == totalChunks,
        endTime: i == totalChunks ? DateTime.now() : null,
      );
      
      // Eğer state'ten silinmişse dur
      if (!state.containsKey(fileId)) break;
    }
  }
}

final transferNotifierProvider = 
    StateNotifierProvider<TransferNotifier, Map<String, TransferState>>((ref) {
  return TransferNotifier(ref);
});

/// Aktif transferler provider
final activeTransfersProvider = Provider<List<TransferState>>((ref) {
  final transfers = ref.watch(transferNotifierProvider);
  return transfers.values
      .where((t) => !t.isComplete && !t.isFailed)
      .toList()
    ..sort((a, b) => b.startTime.compareTo(a.startTime));
});

/// Tamamlanan transferler provider
final completedTransfersProvider = Provider<List<TransferState>>((ref) {
  final transfers = ref.watch(transferNotifierProvider);
  return transfers.values
      .where((t) => t.isComplete)
      .toList()
    ..sort((a, b) => b.startTime.compareTo(a.startTime));
});

/// Başarısız transferler provider
final failedTransfersProvider = Provider<List<TransferState>>((ref) {
  final transfers = ref.watch(transferNotifierProvider);
  return transfers.values
      .where((t) => t.isFailed)
      .toList()
    ..sort((a, b) => b.startTime.compareTo(a.startTime));
});


