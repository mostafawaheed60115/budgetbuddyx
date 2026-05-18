import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';

class ApiClient {
  static const String _tokenKey = 'access_token';
  String? _token;

  Future<void> _loadToken() async {
    if (_token != null) return;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String?> getToken() async {
    await _loadToken();
    return _token;
  }

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Cookie'] = 'access_token=$_token';
    }
    return headers;
  }

  void _extractToken(http.Response response) {
    final setCookie = response.headers['set-cookie'];
    if (setCookie != null) {
      final match = RegExp(r'access_token=([^;]+)').firstMatch(setCookie);
      if (match != null) {
        saveToken(match.group(1)!);
      }
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: _headers(),
    );
    _extractToken(response);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    _extractToken(response);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> body) async {
    await _loadToken();
    final response = await http.patch(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    _extractToken(response);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, [Map<String, dynamic>? body]) async {
    await _loadToken();
    final response = await http.put(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    _extractToken(response);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    await _loadToken();
    final response = await http.delete(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: _headers(),
    );
    _extractToken(response);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body is List) {
        return {'data': body};
      }
      return body is Map<String, dynamic> ? body : {'data': body};
    } else {
      final message = body is Map ? (body['message'] ?? body['error'] ?? 'Unknown error') : 'Unknown error';
      throw ApiException(message.toString(), response.statusCode);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
