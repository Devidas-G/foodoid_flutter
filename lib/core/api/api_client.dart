import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiClient {
  ApiClient._private();
  static final ApiClient instance = ApiClient._private();

  final http.Client _client = http.Client();

  /// Request timeout
  Duration timeout = const Duration(seconds: 30);

  Uri _buildUri(String path) {
    var base = ApiConfig.baseUrl;
    if (path.startsWith('/')) path = path.substring(1);
    return Uri.parse(base + path);
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    final result = <String, String>{};
    result.addAll(ApiConfig.defaultHeaders());
    if (headers != null) result.addAll(headers);
    return result;
  }

  Future<http.Response> get(String path, {Map<String, String>? headers}) async {
    final uri = _buildUri(path);
    final h = _mergeHeaders(headers);
    return _client.get(uri, headers: h).timeout(timeout);
  }

  Future<http.Response> post(String path,
      {Map<String, String>? headers, Object? body}) async {
    final uri = _buildUri(path);
    final h = _mergeHeaders(headers);
    final bodyStr = body == null ? null : jsonEncode(body);
    return _client.post(uri, headers: h, body: bodyStr).timeout(timeout);
  }

  Future<http.Response> put(String path,
      {Map<String, String>? headers, Object? body}) async {
    final uri = _buildUri(path);
    final h = _mergeHeaders(headers);
    final bodyStr = body == null ? null : jsonEncode(body);
    return _client.put(uri, headers: h, body: bodyStr).timeout(timeout);
  }

  Future<http.Response> delete(String path,
      {Map<String, String>? headers, Object? body}) async {
    final uri = _buildUri(path);
    final h = _mergeHeaders(headers);
    final bodyStr = body == null ? null : jsonEncode(body);
    return _client
        .delete(uri, headers: h, body: bodyStr)
        .timeout(timeout);
  }

  void dispose() => _client.close();
}
