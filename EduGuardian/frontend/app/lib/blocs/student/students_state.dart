import '../../models/student.dart';

abstract class StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;

  StudentLoaded(this.students);
}

class StudentProfileLoading extends StudentState {}

class StudentProfileLoaded extends StudentState {
  final Student student;

  StudentProfileLoaded(this.student);
}

class StudentProfileNotFound extends StudentState {}

class StudentAdding extends StudentState {}

class StudentAdded extends StudentState {
  final Student student;

  StudentAdded(this.student);
}

class StudentUpdating extends StudentState {}

class StudentUpdated extends StudentState {}


class StudentError extends StudentState {
  final String message;

  StudentError(this.message);
}