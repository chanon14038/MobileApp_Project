import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(PageLoaded(0)) {
    on<PageSelected>((event, emit) {
      emit(PageLoaded(event.index));
    });
  }
}
