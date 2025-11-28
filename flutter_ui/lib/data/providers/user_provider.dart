import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class UserNotifier extends StateNotifier<String> {
  UserNotifier(this.prefs) : super(prefs.getString('nickname') ?? 'Nickname');

  final SharedPreferences prefs;

  Future<void> setNickname(String nickname) async {
    await prefs.setString('nickname', nickname);
    state = nickname;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserNotifier(prefs);
});

class ProfileImageNotifier extends StateNotifier<String?> {
  ProfileImageNotifier(this.prefs) : super(prefs.getString('profile_image'));

  final SharedPreferences prefs;

  Future<void> setImage(String path) async {
    await prefs.setString('profile_image', path);
    state = path;
  }

  Future<void> removeImage() async {
    await prefs.remove('profile_image');
    state = null;
  }
}

final profileImageProvider = StateNotifierProvider<ProfileImageNotifier, String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileImageNotifier(prefs);
});
