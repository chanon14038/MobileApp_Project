abstract class StudentEvent {}

class FetchStudents extends StudentEvent {}

class FetchStudentById extends StudentEvent {
  final String studentId;

  FetchStudentById(this.studentId);
}