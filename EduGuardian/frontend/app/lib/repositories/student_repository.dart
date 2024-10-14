import 'package:dio/dio.dart';
import '../services/dio_client.dart';
import '../models/student.dart';

class StudentRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Student>> getStudents() async {
    try {
      final response = await _dioClient.dio.get('/students/advisor');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data; // Ensure this is a List
        return data.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch students'); // Handle other non-200 responses here
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Student not found'); // Handle 404 error specifically
      } else {
        throw Exception(
            'Failed to fetch students: ${e.message}'); // General error handling
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch students: $e'); // Catch any other exceptions
    }
  }

  Future<Student> getOneStudent(String studentId) async {
    try {
      final response = await _dioClient.dio.get('/students/$studentId');
      if (response.statusCode == 200) {
        return Student.fromJson(response.data); // Convert data to Student
      } else {
        throw Exception('Failed to fetch student');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Student not found');
      } else {
        throw Exception('Failed to fetch student: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch student: $e');
    }
  }

  // เพิ่มนักเรียนใหม่
  Future<Student> addStudent(Student student) async {
    try {
      final response = await _dioClient.dio.post(
        '/students', // Endpoint สำหรับเพิ่มนักเรียน
        data: student.toJson(), // ส่งข้อมูลในรูปแบบ JSON
      );
      if (response.statusCode == 200) {
        return Student.fromJson(response.data); // Return นักเรียนที่ถูกเพิ่ม
      } else {
        throw Exception('Failed to add student');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid data provided');
      } else {
        throw Exception('Failed to add student: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  Future<void> updateStudent(String studentId, String firstName, String lastName, String classroom) async {
    try {
      final response = await _dioClient.dio.put(
        '/students/$studentId',
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "classroom": classroom,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update student');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Student not found');
      } else {
        throw Exception('Failed to update student: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }
}
