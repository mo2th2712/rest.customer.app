import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefs {
  static const _key = 'onboarding_done';

  static Future<bool> isDone() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_key) ?? false;
  }

  static Future<void> setDone() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_key, true);
  }
}
