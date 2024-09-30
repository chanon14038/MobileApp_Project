import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/dio_client.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    try {
      // Setting content-type to application/x-www-form-urlencoded
      final response = await _dioClient.dio.post(
        '/token',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        String token = response.data['access_token'];
        // Store token securely
        await _storage.write(key: 'token', value: token);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
