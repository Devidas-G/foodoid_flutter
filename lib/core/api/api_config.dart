import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Base URL used throughout the app. Prefer loading from dotenv at runtime.
  // Example .env: API_BASE_URL=https://stone-of-righteousness.vercel.app/
  static String get baseUrl => dotenv.env['API_BASE_URL'] ??
      'https://stone-of-righteousness.vercel.com/';

  // API key required by the backend. Set at app startup from secure storage
  // or environment. Keep empty by default.
  static String apiKey = '';

  // Default headers for requests. Merge/add per-request headers as needed.
  static Map<String, String> defaultHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (apiKey.isNotEmpty) {
      // Use api-key header; change to 'Authorization' if your backend expects it.
      headers['api-key'] = apiKey;
    }
    return headers;
  }
}
