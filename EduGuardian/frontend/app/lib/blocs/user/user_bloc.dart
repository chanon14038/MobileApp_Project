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
