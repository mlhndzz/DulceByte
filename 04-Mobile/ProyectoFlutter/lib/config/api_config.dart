import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _configuredUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_configuredUrl.trim().isNotEmpty) {
      return _normalize(_configuredUrl);
    }

    if (kIsWeb) {
      return 'http://localhost:5080';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5080';
    }

    return 'http://localhost:5080';
  }

  static String _normalize(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }
}
