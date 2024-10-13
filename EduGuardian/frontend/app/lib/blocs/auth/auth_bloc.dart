import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../notification_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final NotificationBloc notificationBloc;

  AuthBloc(this.authRepository, this.notificationBloc) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {

        await authRepository.login(event.username, event.password);
        
        notificationBloc.add(ConnectWebSocket());

        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      await authRepository.logout();

      notificationBloc.add(DisconnectWebSocket());

      emit(AuthLoggedOut());
    });
  }
}
