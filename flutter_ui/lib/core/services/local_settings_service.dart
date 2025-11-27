import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:aether_desktop/generated/api/proto/common.pbenum.dart';

class LocalSettingsService {
  static final LocalSettingsService _instance = LocalSettingsService._internal();
  
  factory LocalSettingsService() {
    return _instance;
  }
  
  LocalSettingsService._internal();
  
  Map<String, dynamic> _settings = {};
  bool _initialized = false;
  
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      final file = await _getSettingsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        _settings = json.decode(content);
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
    
    _initialized = true;
  }
  
  Future<File> _getSettingsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/aether_settings.json');
  }
  
  Future<void> _saveSettings() async {
    try {
      final file = await _getSettingsFile();
      await file.writeAsString(json.encode(_settings));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }
  
  // Sync Mode Persistence
  // Structure: { "sync_modes": { "folderId": { "peerId": "mode_string" } } }
  
  Future<void> savePeerSyncMode(String folderId, String peerId, SyncMode mode) async {
    if (!_initialized) await init();
    
    if (!_settings.containsKey('sync_modes')) {
      _settings['sync_modes'] = {};
    }
    
    if (!_settings['sync_modes'].containsKey(folderId)) {
      _settings['sync_modes'][folderId] = {};
    }
    
    _settings['sync_modes'][folderId][peerId] = mode.name;
    await _saveSettings();
  }
  
  SyncMode? getPeerSyncMode(String folderId, String peerId) {
    if (!_initialized) return null;
    
    try {
      if (_settings.containsKey('sync_modes') && 
          _settings['sync_modes'].containsKey(folderId) &&
          _settings['sync_modes'][folderId].containsKey(peerId)) {
        
        final modeName = _settings['sync_modes'][folderId][peerId];
        return SyncMode.values.firstWhere(
          (e) => e.name == modeName, 
          orElse: () => SyncMode.SYNC_MODE_UNSPECIFIED
        );
      }
    } catch (e) {
      print('Error getting sync mode: $e');
    }
    
    return null;
  }
}
