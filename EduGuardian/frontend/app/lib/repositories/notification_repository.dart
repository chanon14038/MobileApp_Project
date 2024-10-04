import 'package:dio/dio.dart';
import 'package:app/models/reports.dart';

class NotificationRepository {
  final Dio _dio = Dio(); // ใช้ Dio ในการเรียก API

  Future<List<Reports>> getNotifications() async {
    try {
      final response = await _dio.get('/descriptions'); // เรียก API ที่ /descriptions
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) => Reports.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}
