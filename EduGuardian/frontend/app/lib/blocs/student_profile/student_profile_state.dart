import '../../models/student_list.dart';

abstract class StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;

  StudentLoaded(this.students);
}

class SingleStudentLoaded extends StudentState {
  final Student student;

  SingleStudentLoaded(this.student);
}

class StudentError extends StudentState {
  final String message;

  StudentError(this.message);
}

class StudentNotFound extends StudentState {}