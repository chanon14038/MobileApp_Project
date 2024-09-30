import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // Handler for login event
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.username, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Handler for logout event
    on<AuthLogoutEvent>((event, emit) async {
      await authRepository.logout();
      emit(AuthLoggedOut());
    });
  }
}
