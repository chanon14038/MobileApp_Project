import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebSocketClient {
  final String endpoint;
  WebSocketChannel? _channel;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  WebSocketClient(this.endpoint);

  Future<void> connect() async {
    String? token = await _secureStorage.read(key: 'token');

    if (token != null) {
      final String url = 'ws://10.0.2.2:8000/$endpoint?token=$token';
      _channel = WebSocketChannel.connect(Uri.parse(url));
    } else {
      throw Exception('Missing Token');
    }
  }

  Stream<dynamic>? get notificationsStream => _channel?.stream;

  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
  }

}
