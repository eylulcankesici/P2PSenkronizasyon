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


