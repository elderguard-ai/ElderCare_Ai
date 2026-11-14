import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  /// Build-time default for physical phones (BLE needs a real device), e.g.
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.20:8000/api/v1
  static const String _buildDefault = String.fromEnvironment("API_BASE_URL");

  /// Address typed in Menu & Settings > Server Address; wins over the build default so a demo
  /// laptop on another network can be used without rebuilding the app.
  static String? _savedUrl;
  static const String _savedUrlKey = "server_url";

  static String get baseUrl {
    if (_savedUrl != null) return _savedUrl!;
    if (_buildDefault.isNotEmpty) return _buildDefault;
    if (kIsWeb) {
      return "http://localhost:8000/api/v1";
    }
    // Android emulator alias for host machine localhost
    if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:8000/api/v1";
    }
    return "http://localhost:8000/api/v1";
  }

  /// "host:port" shown to the user.
  static String get serverLabel {
    final uri = Uri.parse(baseUrl);
    return "${uri.host}:${uri.port}";
  }

  /// Unauthenticated health check, outside the versioned API.
  static String get healthUrl => Uri.parse(baseUrl).replace(path: "/health").toString();

  static const Duration timeoutDuration = Duration(seconds: 8);

  /// "192.168.1.20", "192.168.1.20:8000" or "http://host:8000" -> "http://host:8000/api/v1".
  /// Returns null when the input is not a usable address.
  static String? normalizeServerAddress(String input) {
    var text = input.trim();
    if (text.isEmpty) return null;
    if (!text.contains("://")) text = "http://$text";
    final uri = Uri.tryParse(text);
    if (uri == null || uri.host.isEmpty || (uri.scheme != "http" && uri.scheme != "https")) return null;
    final port = uri.hasPort ? uri.port : 8000;
    return "${uri.scheme}://${uri.host}:$port/api/v1";
  }

  static Future<void> loadSavedServer() async {
    final prefs = await SharedPreferences.getInstance();
    _savedUrl = prefs.getString(_savedUrlKey);
  }

  static Future<void> saveServer(String url) async {
    _savedUrl = url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedUrlKey, url);
  }
}
