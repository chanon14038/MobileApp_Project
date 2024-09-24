abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<dynamic> students;
  StudentLoaded(this.students);
}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
}