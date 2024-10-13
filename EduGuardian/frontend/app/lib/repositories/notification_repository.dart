import '../services/websocket_client.dart';

class NotificationRepository {
  final String endpoint = "ws";
  final WebSocketClient _webSocketClient;

  NotificationRepository() : _webSocketClient = WebSocketClient("ws");

  Future<void> connect() async {
    await _webSocketClient.connect();
  }

  Stream<dynamic>? getNotifications() {
    return _webSocketClient.notificationsStream;
  }

  void sendNotification(String message) {
    _webSocketClient.sendMessage(message);
  }

  void disconnect() {
    _webSocketClient.disconnect();
  }

}
