class NotificationEvent {}

class NotificationReceived extends NotificationEvent {
  final String notification;

  NotificationReceived(this.notification);
}

class ConnectWebSocket extends NotificationEvent {}

class DisconnectWebSocket extends NotificationEvent {}