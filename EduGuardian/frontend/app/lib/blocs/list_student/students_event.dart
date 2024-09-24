abstract class StudentEvent {}

class FetchStudents extends StudentEvent {
  final String classroom;

  FetchStudents(this.classroom);
}