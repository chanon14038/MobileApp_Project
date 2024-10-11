import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/websocket_client.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final WebSocketClient webSocketClient;
  List<dynamic> _notifications = [];

  NotificationBloc(this.webSocketClient) : super(NotificationInitial()) {
    // เพิ่ม listener สำหรับฟังข้อมูลใหม่จาก WebSocket
    _listenToWebSocket();
    
    // โหลดข้อมูลแจ้งเตือนเริ่มต้น
    on<LoadNotificationsEvent>((event, emit) {
      emit(NotificationLoading());
      emit(NotificationLoaded(_notifications));
    });

    // เพิ่มแจ้งเตือนใหม่ลงใน state
    on<NewNotificationEvent>((event, emit) {
      _notifications.add(event.notification);
      emit(NotificationLoaded(List.from(_notifications))); // สำเนารายการใหม่เพื่ออัปเดต UI
    });
  }

  void _listenToWebSocket() {
    // ฟังการแจ้งเตือนใหม่จาก WebSocket และ dispatch event เมื่อมีข้อมูลใหม่
    webSocketClient.notifyStream.listen((notification) {
      add(NewNotificationEvent(notification));
    });
  }
}
