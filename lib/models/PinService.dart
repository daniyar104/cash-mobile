import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  static const _pinKey = 'user_pin';

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  Future<String?> getSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  Future<bool> isPinSet() async {
    final pin = await getSavedPin();
    return pin != null;
  }

  Future<void> clearPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
  }
}
