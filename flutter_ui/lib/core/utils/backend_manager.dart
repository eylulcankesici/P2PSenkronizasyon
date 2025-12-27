
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class BackendProcessManager {
  Process? _process;

  Future<void> startBackend() async {
    if (_process != null) return;

    try {
      // Executable'ın bulunduğu dizini bul
      String executablePath = Platform.resolvedExecutable;
      String executableDir = p.dirname(executablePath);

      // Backend exe yolunu belirle (Release modunda aynı klasörde olması beklenir)
      String backendPath = p.join(executableDir, 'aether-backend.exe');
      
      if (kDebugMode) {
        // Debug modunda ise proje kök dizinindeki backend'i bulmaya çalışabiliriz
        // (Opsiyonel, debug modunda genelde manuel başlatılır)
        print('Debug mode: Backend expected at $backendPath');
      }

      if (await File(backendPath).exists()) {
        print('Starting backend: $backendPath');
        _process = await Process.start(
          backendPath,
          [],
          mode: ProcessStartMode.detached, // Detached modda başlat
        );
        print('Backend started with PID: ${_process?.pid}');
      } else {
        print('Backend executable not found at: $backendPath');
      }
    } catch (e) {
      print('Failed to start backend: $e');
    }
  }

  void stopBackend() {
    // Detached process'i kodla kapatmak zordur, genelde işletim sistemi kapatır 
    // veya backend kendi kendine kapanma logic'ine sahip olmalıdır (parent process takibi vs.)
    // Ancak simple case için kill deneyebiliriz.
    if (_process != null) {
      _process!.kill();
      _process = null;
    }
  }
}
