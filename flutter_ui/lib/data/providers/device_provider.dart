import 'package:flutter_riverpod/flutter_riverpod.dart';

// Device ID provider - Backend'den gerçek ID almak için placeholder
final deviceIdProvider = Provider<String>((ref) {
  // TODO: Backend'den gerçek device ID'yi al (ConfigService gerekiyor)
  // Şimdilik boş döndür - UI'da gösterilmeyecek
  return '';
});

// Device name provider
final deviceNameProvider = Provider<String>((ref) {
  // TODO: Backend'den gerçek device name'i al
  return 'Aether Node';
});
