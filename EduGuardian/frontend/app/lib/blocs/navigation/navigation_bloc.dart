import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationInitial()) {
    // การกำหนด handler สำหรับ ChangeBottomNavigation
    on<ChangeBottomNavigation>((event, emit) {
      emit(BottomNavigationChanged(event.index));
    });
  }
}