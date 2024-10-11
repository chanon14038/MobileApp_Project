import 'dart:typed_data';

import 'package:dio/dio.dart';

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

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // ทำการเรียก API ที่เปลี่ยนรหัสผ่าน
    // สมมติว่าใช้แพ็กเกจ Dio หรือ Http
    final response = await _dioClient.dio.put(
      '/users/change_password',
      data: {
        "current_password": currentPassword,
        "new_password": newPassword,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to change password");
    }
  }

  Future<void> uploadImage(Uint8List imageData) async {
    try {
      // Create FormData for multipart file upload
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(imageData, filename: 'profile_image.png'), // You can set any filename
      });

      final response = await _dioClient.dio.put(
        '/users/imageProfile',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to upload image");
      }
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }
}
