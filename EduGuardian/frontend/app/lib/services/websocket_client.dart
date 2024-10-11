import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  final String endpoint;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late IOWebSocketChannel _channel;
  late final BehaviorSubject<dynamic> _notifyStream = BehaviorSubject();

  WebSocketClient({required this.endpoint}) {
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    try {
      // รับ token จาก secure storage (ถ้ามี)
      String? token = await _storage.read(key: 'token');
      if (token == null) throw Exception('No token found');
      
      // สร้าง URL สำหรับเชื่อมต่อ WebSocket
      String url = 'ws://10.0.2.2:8000/$endpoint?token=$token';
      _channel = IOWebSocketChannel.connect(Uri.parse(url));

      // เริ่มฟังการแจ้งเตือนผ่านสตรีม WebSocket
      _notifyStream.addStream(_channel.stream);
    } catch (e) {
      print("Error initializing WebSocket: $e");
    }
  }

  // ส่งข้อมูลแบบ Stream เพื่อใช้งานใน BLoC
  Stream<dynamic> get notifyStream => _notifyStream.stream;

  void dispose() {
    _notifyStream.close();
    _channel.sink.close();
  }
}
