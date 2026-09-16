import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nioudem/src/core/config/api_config.dart';
import 'package:nioudem/src/core/network/api_exception.dart';
import 'package:nioudem/src/features/auth/models/auth_session.dart';

class AuthApi {
  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<AuthSession> createPin({
    required String phoneNumber,
    required String pin,
    required String pinConfirmation,
    String? firstName,
    String? lastName,
  }) async {
    final response = await _post('/auth/pin/create', {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'pin': pin,
      'pinConfirmation': pinConfirmation,
    });
    return AuthSession.fromJson(response['payload'] as Map<String, dynamic>);
  }

  Future<AuthSession> loginWithPin({
    required String phoneNumber,
    required String pin,
  }) async {
    final response = await _post('/auth/pin/login', {
      'phoneNumber': phoneNumber,
      'pin': pin,
    });
    return AuthSession.fromJson(response['payload'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded['message']?.toString() ?? 'Erreur serveur';
      throw ApiException(message);
    }
    return decoded;
  }
}
