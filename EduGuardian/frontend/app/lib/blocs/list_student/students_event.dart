import '../../models/student.dart';

abstract class StudentEvent {}

class FetchStudents extends StudentEvent {}

class AddStudent extends StudentEvent {
  final Student student;

  AddStudent(this.student);
}