import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';

/// Generic API client wrapper providing basic GET/POST with JSON handling.
/// Expected server response format:
/// { "success": true|false, "message": "...", "data": {...} }
class ApiClient {
  final String baseUrl;

  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? API_BASE_URL;

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final String finalUrl = '${baseUrl}${path.startsWith('/') ? path : '/$path'}';
    try {
      final response = await http
          .post(Uri.parse(finalUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body))
          .timeout(apiTimeout);
      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) return decoded;
          return {'success': false, 'message': 'Invalid JSON response', 'body': response.body};
        } catch (e) {
          return {'success': false, 'message': 'Failed to decode JSON', 'error': e.toString(), 'body': response.body};
        }
      } else {
        return {'success': false, 'message': 'Network or server error', 'code': response.statusCode, 'body': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception during network call', 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> get(String path, Map<String, String>? params) async {
    final query = (params != null && params.isNotEmpty)
        ? '?${params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';
    final String finalUrl = '${baseUrl}${path.startsWith('/') ? path : '/$path'}$query';
    try {
      final response = await http.get(Uri.parse(finalUrl)).timeout(apiTimeout);
      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) return decoded;
          return {'success': false, 'message': 'Invalid JSON response', 'body': response.body};
        } catch (e) {
          return {'success': false, 'message': 'Failed to decode JSON', 'error': e.toString(), 'body': response.body};
        }
      } else {
        return {'success': false, 'message': 'Network or server error', 'code': response.statusCode, 'body': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception during network call', 'error': e.toString()};
    }
  }
}
