abstract class StudentProfileEvent {}

class FetchStudentProfile extends StudentProfileEvent {}

class FetchStudentProfileById extends StudentProfileEvent {
  final String studentId;

  FetchStudentProfileById(this.studentId);
}