import '../../models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded(this.user);
}

class ProfileUpdated extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class ChangePasswordInitial extends UserState {}

class ChangePasswordLoading extends UserState {}

class ChangePasswordSuccess extends UserState {}

class ChangePasswordFailure extends UserState {
  final String error;

  ChangePasswordFailure(this.error);
}

class ImageUploadLoading extends UserState {}
class ImageUploaded extends UserState {}

class ImageUploadSuccess extends UserState {
  final String message;
  ImageUploadSuccess(this.message);
}

class ImageUploadFailure extends UserState {
  final String error;
  ImageUploadFailure(this.error);
}