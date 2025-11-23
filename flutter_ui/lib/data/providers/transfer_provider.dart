import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/providers/folder_provider.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/sync.pb.dart';
import 'package:aether_desktop/generated/api/proto/sync.pbgrpc.dart';

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
      
      // Backend'e request gönder
      final request = RequestFileFromPeerRequest()
        ..fileId = fileId
        ..peerId = peerId;
      
      final response = await client.syncService.requestFileFromPeer(request);
      
      if (!response.status.success) {
        throw Exception(response.status.message);
      }
      
      // Transfer progress'ini dinle (totalChunks bilgisini almak için önce status'u kontrol et)
      _loadInitialTransferStatus(fileId);
      _watchTransferProgress(fileId);
      
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
  
  /// İlk transfer durumunu yükle
  Future<void> _loadInitialTransferStatus(String fileId) async {
    try {
      final client = ref.read(grpcClientProvider);
      final request = GetTransferStatusRequest()..fileId = fileId;
      final response = await client.syncService.getTransferStatus(request);
      
      if (response.status.success && response.transferStatus != null) {
        final status = response.transferStatus!;
        _updateTransfer(
          fileId,
          totalChunks: status.totalChunks.toInt(),
          completedChunks: status.completedChunks.toInt(),
          transferredBytes: status.transferredBytes.toInt(),
          isComplete: status.isComplete,
          isFailed: status.isFailed,
          errorMessage: status.errorMessage.isEmpty ? null : status.errorMessage,
          endTime: status.endTime != null 
              ? DateTime.fromMillisecondsSinceEpoch(status.endTime.seconds.toInt() * 1000)
              : null,
        );
      }
    } catch (e) {
      // Hata durumunda sessizce devam et
      print('Transfer status yüklenemedi: $e');
    }
  }
  
  /// Transfer progress'ini dinle
  void _watchTransferProgress(String fileId) {
    final client = ref.read(grpcClientProvider);
    
    final request = WatchTransferProgressRequest()..fileId = fileId;
    
    // Stream'i dinle
    client.syncService.watchTransferProgress(request).listen(
      (update) {
        _updateTransfer(
          fileId,
          totalChunks: update.totalChunks.toInt(),
          completedChunks: update.completedChunks.toInt(),
          transferredBytes: update.transferredBytes.toInt(),
          isComplete: update.isComplete,
          isFailed: update.isFailed,
          errorMessage: update.errorMessage.isEmpty ? null : update.errorMessage,
          endTime: update.isComplete || update.isFailed ? DateTime.now() : null,
        );
      },
      onError: (error) {
        _updateTransfer(
          fileId,
          isFailed: true,
          errorMessage: error.toString(),
          endTime: DateTime.now(),
        );
      },
    );
  }
  
  /// Transfer progress güncelle
  void _updateTransfer(
    String fileId, {
    int? completedChunks,
    int? totalChunks,
    int? transferredBytes,
    bool? isComplete,
    bool? isFailed,
    String? errorMessage,
    DateTime? endTime,
  }) {
    final current = state[fileId];
    if (current == null) return;
    
    final wasComplete = current.isComplete;
    final nowComplete = isComplete ?? false;
    
    // Yeni transfer state oluştur
    final updatedTransfer = TransferState(
      fileId: current.fileId,
      fileName: current.fileName,
      peerId: current.peerId,
      peerName: current.peerName,
      totalChunks: totalChunks ?? current.totalChunks,
      completedChunks: completedChunks ?? current.completedChunks,
      totalBytes: current.totalBytes,
      transferredBytes: transferredBytes ?? current.transferredBytes,
      isComplete: isComplete ?? current.isComplete,
      isFailed: isFailed ?? current.isFailed,
      errorMessage: errorMessage ?? current.errorMessage,
      startTime: current.startTime,
      endTime: endTime ?? current.endTime,
    );
    
    state = {
      ...state,
      fileId: updatedTransfer,
    };
    
    // Transfer tamamlandığında klasörler sekmesini yenile (dosya alındıktan sonra)
    if (!wasComplete && nowComplete) {
      ref.invalidate(foldersProvider);
    }
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


