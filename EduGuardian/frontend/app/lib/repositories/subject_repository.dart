import 'package:dio/dio.dart';
import '../models/subject.dart';
import '../services/dio_client.dart';

class SubjectRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Subject>> getSubjects() async {
    try {
      final response = await _dioClient.dio.get('/subject');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Subject.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subjects');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Subject not found');
      } else {
        throw Exception('Failed to fetch subject: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch subject: $e');
    }
  }
}