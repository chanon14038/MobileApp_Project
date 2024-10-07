import '../services/dio_client.dart';
import '../models/user_model.dart';

class UserRepository {
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

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String subject, // เพิ่ม subject
    required String phoneNumber,
    required String email,
    required String advisorRoom, // เพิ่ม advisorRoom
  }) async {
    try {
      final response = await _dioClient.dio.put(
        '/users/update', // Endpoint สำหรับการอัปเดตโปรไฟล์
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'subject': subject, // ส่ง subject
          'phone_number': phoneNumber,
          'email': email,
          'advisor_room': advisorRoom, // ส่ง advisorRoom
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
