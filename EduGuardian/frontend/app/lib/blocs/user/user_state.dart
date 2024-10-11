import '../../models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded(this.user);
}

class ProfileUpdated extends UserState {}


class ChangePasswordInitial extends UserState {}

class ChangePasswordLoading extends UserState {}

class ChangePasswordSuccess extends UserState {}


class ImageUploadLoading extends UserState {}

class ImageUploaded extends UserState {}

class ImageUploadSuccess extends UserState {
  final String message;
  
  ImageUploadSuccess(this.message);
}

class ImageDeleteLoading extends UserState {}

class ImageDeleted extends UserState {}

class FailureState extends UserState {
  final String error;

  FailureState(this.error);
}