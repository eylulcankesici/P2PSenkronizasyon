import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aether_desktop/data/providers/user_provider.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier(this.prefs) : super(prefs.getString('language') ?? 'tr');

  final SharedPreferences prefs;

  Future<void> setLanguage(String languageCode) async {
    await prefs.setString('language', languageCode);
    state = languageCode;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LanguageNotifier(prefs);
});
