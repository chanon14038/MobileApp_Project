import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NewNotificationEvent extends NotificationEvent {
  final dynamic notification;

  const NewNotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class LoadNotificationsEvent extends NotificationEvent {}
