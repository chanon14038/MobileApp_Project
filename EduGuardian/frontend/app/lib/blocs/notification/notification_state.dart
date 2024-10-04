import 'package:app/models/reports.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<Reports> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
