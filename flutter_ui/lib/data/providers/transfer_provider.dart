import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aether_desktop/data/providers/folder_provider.dart';
import 'package:aether_desktop/data/services/grpc_provider.dart';
import 'package:aether_desktop/generated/api/proto/p2p.pbgrpc.dart' as pb;

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
  final bool isCancelled;
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
    this.isCancelled = false,
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
    if (isCancelled) return 'İptal edildi';
    if (isFailed) return 'Başarısız';
    if (isComplete) return 'Tamamlandı';
    return 'Transfer ediliyor...';
  }
  
  TransferState copyWith({
    int? completedChunks,
    int? transferredBytes,
    bool? isComplete,
    bool? isFailed,
    bool? isCancelled,
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
      isCancelled: isCancelled ?? this.isCancelled,
      errorMessage: errorMessage ?? this.errorMessage,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

/// Aktif transferler notifier
class TransferNotifier extends StateNotifier<Map<String, TransferState>> {
  TransferNotifier(this.ref) : super({}) {
    // Backend'den transferleri yükle
    _loadTransfers();
    // Gerçek zamanlı güncelleme için polling başlat
    _startPolling();
  }
  
  final Ref ref;
  Timer? _pollingTimer;
  
  /// Backend'den transferleri yükle
  Future<void> _loadTransfers() async {
    try {
      final client = ref.read(grpcClientProvider);
      if (!client.isConnected) return;
      
      final request = pb.ListTransfersRequest();
      final response = await client.transferService.listTransfers(request);
      
      if (response.status.success) {
        final transfers = <String, TransferState>{};
        for (final transferProto in response.transfers) {
          final transfer = _fromProto(transferProto);
          transfers[transfer.fileId] = transfer;
        }
        // State'i güncelle - CANCELLED transfer'ler de dahil
        // activeTransfersProvider filtresi zaten CANCELLED transfer'leri filtreler
        // State'i tamamen değiştir (referans değişimi için)
        state = Map<String, TransferState>.from(transfers);
      }
    } catch (e) {
      print('❌ Transferler yüklenemedi: $e');
    }
  }
  
  /// Proto mesajından TransferState oluştur
  TransferState _fromProto(pb.TransferInfo proto) {
    return TransferState(
      fileId: proto.fileId,
      fileName: proto.fileName,
      peerId: proto.peerId,
      peerName: proto.peerName,
      totalChunks: proto.totalChunks.toInt(),
      completedChunks: proto.completedChunks.toInt(),
      totalBytes: proto.totalBytes.toInt(),
      transferredBytes: proto.transferredBytes.toInt(),
      isComplete: proto.state == pb.TransferState.TRANSFER_STATE_COMPLETED,
      isFailed: proto.state == pb.TransferState.TRANSFER_STATE_FAILED,
      isCancelled: proto.state == pb.TransferState.TRANSFER_STATE_CANCELLED,
      errorMessage: proto.errorMessage.isEmpty ? null : proto.errorMessage,
      startTime: proto.startTime.toDateTime(),
      endTime: proto.hasEndTime() ? proto.endTime.toDateTime() : null,
    );
  }
  
  /// Gerçek zamanlı güncelleme için polling başlat
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _loadTransfers();
    });
    
    // Provider dispose olduğunda timer'ı iptal et
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });
  }
  
  /// Transfer'ları yeniden yükle
  Future<void> refresh() async {
    await _loadTransfers();
  }
  
  /// Dosya transferi başlat
  /// Not: Bu metod artık backend'den transfer durumunu otomatik olarak çeker
  /// Transfer durumu backend'de otomatik olarak başlatılır (dosya gönderme/alma sırasında)
  /// Bu metod sadece UI'da gösterim için kullanılır
  Future<void> requestFileFromPeer({
    required String peerId,
    required String peerName,
    required String fileId,
    required String fileName,
    required int totalBytes,
  }) async {
    // Transfer durumunu backend'den yükle
    // Transfer durumu dosya gönderme/alma sırasında otomatik olarak backend'de oluşturulur
    await _loadTransfers();
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
    
    final wasComplete = current.isComplete;
    final nowComplete = isComplete ?? false;
    
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
    
    // Transfer tamamlandığında klasörler sekmesini yenile (dosya alındıktan sonra)
    if (!wasComplete && nowComplete) {
      ref.invalidate(foldersProvider);
    }
  }
  
  /// Transfer'ı iptal et
  Future<void> cancelTransfer(String fileId) async {
    try {
      final client = ref.read(grpcClientProvider);
      if (!client.isConnected) return;
      
      final request = pb.CancelTransferRequest()..fileId = fileId;
      await client.transferService.cancelTransfer(request);
      
      // Transfer'ları yeniden yükle
      await _loadTransfers();
    } catch (e) {
      print('❌ Transfer iptal edilemedi: $e');
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
      .where((t) => !t.isComplete && !t.isFailed && !t.isCancelled)
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
      .where((t) => t.isFailed || t.isCancelled)
      .toList()
    ..sort((a, b) => b.startTime.compareTo(a.startTime));
});


