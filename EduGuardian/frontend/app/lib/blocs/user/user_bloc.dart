import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/get_me_repository.dart';
import 'user_event.dart';
import 'user_state.dart';


class GetMeBloc extends Bloc<GetMeEvent, GetMeState> {
  final GetMeRepository repository;

  GetMeBloc(this.repository) : super(GetMeInitial()) {
    on<FetchUserData>((event, emit) async {
      emit(GetMeLoading());
      try {
        final user = await repository.getMe();
        emit(GetMeLoaded(user));
      } catch (e) {
        emit(GetMeError(e.toString()));
      }
    });
  }
}
