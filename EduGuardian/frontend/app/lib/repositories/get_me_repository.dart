import '../services/dio_client.dart';
import '../models/user_model.dart';

class GetMeRepository {
  final DioClient _dioClient = DioClient();

  Future<UserModel> getMe() async {
    try {
      final response = await _dioClient.dio.get('/users/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
