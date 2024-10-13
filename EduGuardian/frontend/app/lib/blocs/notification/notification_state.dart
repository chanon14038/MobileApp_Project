class NotificationState {
  final List<String> notifications;
  final bool connected;

  NotificationState({
    required this.notifications,
    required this.connected,
  });

  NotificationState copyWith({
    List<String>? notifications,
    bool? connected,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      connected: connected ?? this.connected,
    );
  }
}