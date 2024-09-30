import '../services/dio_client.dart';
import '../models/student_list.dart';

class StudentRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Student>> getStudents() async {
    try {
      final response = await _dioClient.dio.get('/students');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data; // คำตอบจาก API ควรเป็น List
        return data.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch students');
      }
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }
}
