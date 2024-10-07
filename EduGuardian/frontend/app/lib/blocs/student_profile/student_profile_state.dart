import '../../models/student.dart';

abstract class StudentProfileState {}

class StudentProfileLoading extends StudentProfileState {}

class StudentProfileLoaded extends StudentProfileState {
  final List<Student> student;

  StudentProfileLoaded(this.student);
}

class SingleStudentProfileLoaded extends StudentProfileState {
  final Student student;

  SingleStudentProfileLoaded(this.student);
}

class StudentProfileError extends StudentProfileState {
  final String message;

  StudentProfileError(this.message);
}

class StudentProfileNotFound extends StudentProfileState {}