import '../services/dio_client.dart';

class GetMeRepository {
  final DioClient _dioClient = DioClient();

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _dioClient.dio.get('/users/me');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
