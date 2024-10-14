import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/get_me_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    // Fetch user data
    on<FetchUserData>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.getMe();
        emit(UserLoaded(user));
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });

    // Update profile
    on<UpdateProfile>((event, emit) async {
      emit(UserLoading());
      try {
        await repository.updateProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          subject: event.subject,
          phoneNumber: event.phoneNumber,
          email: event.email,
          advisorRoom: event.advisorRoom,
        );
        emit(ProfileUpdated());
      } catch (e) {
        emit(FailureState('Failed to update profile: ${e.toString()}'));
      }
    });

    // Change password
    on<ChangePasswordEvent>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await repository.changePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        );
        emit(ChangePasswordSuccess());
      } catch (error) {
        emit(FailureState(error.toString()));
      }
    });

    // Upload profile image
    on<UploadImageEvent>((event, emit) async {
      emit(ImageUploadLoading());
      try {
        await repository.uploadImage(event.imageData);
        emit(ImageUploaded());
        add(FetchUserData());
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });

    // Delete profile image
    on<DeleteProfileImageEvent>((event, emit) async {
      emit(ImageDeleteLoading());
      try {
        await repository
            .deleteImageProfile(); // Call the repository to delete the image
        emit(ImageDeleted());
        add(FetchUserData()); // Fetch updated data after deletion
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });
  }
}
