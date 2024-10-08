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
        // Call the repository function to update the profile
        await repository.updateProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          subject: event.subject,           
          phoneNumber: event.phoneNumber,
          email: event.email,
          advisorRoom: event.advisorRoom,   
        );

        // After successful update, fetch the updated user data
        add(FetchUserData());
        
        // Optionally, you can emit a success state if needed
        emit(ProfileUpdated());
      } catch (e) {
        emit(UserError('Failed to update profile: ${e.toString()}'));
      }
    });

  }
}


//change password bloc
class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository userRepository; // Repository สำหรับส่งคำขอไปยัง API

  ChangePasswordBloc(this.userRepository) : super(ChangePasswordInitial()) {
    on<ChangePasswordEvent>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        // เรียกใช้ API เพื่อเปลี่ยนรหัสผ่าน
        await userRepository.changePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        );
        emit(ChangePasswordSuccess());
      } catch (error) {
        emit(ChangePasswordFailure(error.toString()));
      }
    });
  }
}