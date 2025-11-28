import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aether_desktop/data/providers/user_provider.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this.prefs) : super(_initialTheme(prefs));

  final SharedPreferences prefs;

  static ThemeMode _initialTheme(SharedPreferences prefs) {
    final isDark = prefs.getBool('isDarkMode') ?? true; // Default to dark
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme(bool isDark) async {
    await prefs.setBool('isDarkMode', isDark);
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
