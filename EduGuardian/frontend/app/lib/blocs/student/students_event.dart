import '../../models/student.dart';

abstract class StudentEvent {}

class FetchStudents extends StudentEvent {}


class FetchStudentProfile extends StudentEvent {
  final String studentId;

  FetchStudentProfile(this.studentId);
}

class AddStudent extends StudentEvent {
  final Student student;

  AddStudent(this.student);
}

class UpdateStudentProfile extends StudentEvent {
  final String studentId;
  final String firstName;
  final String lastName;
  final String classroom;

  UpdateStudentProfile(this.studentId, this.firstName, this.lastName, this.classroom);
}