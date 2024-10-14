import '../../models/subject.dart';

abstract class SubjectEvent {}

class FetchSubjects extends SubjectEvent {}

class FetchSubjectById extends SubjectEvent {
  final String subjectId;

  FetchSubjectById(this.subjectId);
}

class FetchStudentsBySubjectId extends SubjectEvent {
  final String subjectId;

  FetchStudentsBySubjectId(this.subjectId);
}

class AddSubject extends SubjectEvent {
  final Subject subject;

  AddSubject(this.subject);
}