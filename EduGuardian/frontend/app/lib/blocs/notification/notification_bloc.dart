import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc(this._notificationRepository)
      : super(NotificationState(notifications: [], connected: false)) {
    on<ConnectWebSocket>((event, emit) async {
      await _notificationRepository.connect();
      _notificationRepository.getNotifications()?.listen((notification) {
        add(NotificationReceived(notification));
      });
      emit(state.copyWith(connected: true));
    });

    on<NotificationReceived>((event, emit) {
      final updatedNotifications = List<String>.from(state.notifications)
        ..add(event.notification);
      emit(state.copyWith(notifications: updatedNotifications));
    });

    on<DisconnectWebSocket>((event, emit) {
      _notificationRepository.disconnect();
      emit(state.copyWith(connected: false));
    });
  }
}