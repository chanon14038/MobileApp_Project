import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/get_me_repository.dart';
import 'user_event.dart';
import 'user_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<FetchUserData>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.getMe();
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(UserLoading());
      try {
        // เรียกฟังก์ชันใน repository เพื่ออัปเดตข้อมูล
        await repository.updateProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          subject: event.subject,           // เพิ่ม subject
          phoneNumber: event.phoneNumber,
          email: event.email,
          advisorRoom: event.advisorRoom,   // เพิ่ม advisorRoom
        );
        emit(ProfileUpdated());
        // หลังจากอัปเดตโปรไฟล์ เรียกข้อมูลใหม่อีกครั้ง
        add(FetchUserData());
      } catch (e) {
        emit(UserError('Failed to update profile: ${e.toString()}'));
      }
    });

  }
}
