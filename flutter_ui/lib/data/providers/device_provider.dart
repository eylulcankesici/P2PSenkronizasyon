import 'package:flutter_riverpod/flutter_riverpod.dart';

// Device ID provider - şimdilik hardcoded
final deviceIdProvider = Provider<String>((ref) {
  // TODO: Backend'den gerçek device ID'yi al
  // Şimdilik test için sabit bir ID
  return 'fc7e42e4-a23f-7427-9cce-ffaa3c10b426';
});

// Device name provider
final deviceNameProvider = Provider<String>((ref) {
  // TODO: Backend'den gerçek device name'i al
  return 'Aether Node';
});
