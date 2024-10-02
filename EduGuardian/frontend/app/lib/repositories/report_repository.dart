import 'package:app/models/reports.dart';
import 'package:dio/dio.dart';
import '../services/dio_client.dart';

class ReportRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Reports>> getReports(String studentId) async {
    try {
      final response = await _dioClient.dio.get('/descriptions/$studentId');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Reports.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch reports');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Report not found');
      } else {
        throw Exception('Failed to fetch report: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch report: $e');
    }
  }
}