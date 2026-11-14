import 'package:shared_preferences/shared_preferences.dart';

/// The signed-in account, kept on the phone so the app opens straight to the user's home screen.
class AuthSession {
  static const _tokenKey = "auth_token";
  static const _roleKey = "auth_role";
  static const _nameKey = "auth_name";

  static String? token;
  static String? role; // "elderly" | "caregiver"
  static String? fullName;

  static bool get isSignedIn => token != null;
  static bool get isCaregiver => role == "caregiver";

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    role = prefs.getString(_roleKey);
    fullName = prefs.getString(_nameKey);
  }

  /// [tokenResponse] is the backend's login/register response.
  static Future<void> save(Map<String, dynamic> tokenResponse) async {
    token = tokenResponse["access_token"] as String;
    role = tokenResponse["role"] as String;
    fullName = tokenResponse["full_name"] as String?;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token!);
    await prefs.setString(_roleKey, role!);
    if (fullName != null) await prefs.setString(_nameKey, fullName!);
  }

  static Future<void> clear() async {
    token = null;
    role = null;
    fullName = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_nameKey);
  }
}
