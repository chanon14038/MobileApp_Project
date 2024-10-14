import 'package:dio/dio.dart';
import '../models/student.dart';
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

  Future<Subject> getSubjectById(String subjectId) async {
    try {
      final response = await _dioClient.dio.get('/subject/$subjectId');
      if (response.statusCode == 200) {
        return Subject.fromJson(response.data);
      } else {
        throw Exception('Failed to load subject');
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

  Future<List<Student>> getStudentsBySubjectId(String subjectId) async {
    try {
      final response = await _dioClient.dio.get('/subject/$subjectId/students');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load students');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Students not found');
      } else {
        throw Exception('Failed to fetch students: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<void> addSubject(Subject subject) async {
    try {
      final response = await _dioClient.dio.post(
        '/subject',
        data: subject.toJson(),
      );
      if (response.statusCode == 200) {
        print('Subject added successfully');
      } else {
        throw Exception('Failed to add subject');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request: ${e.message}');
      } else {
        throw Exception('Failed to add subject: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to add subject: $e');
    }
  }
}
