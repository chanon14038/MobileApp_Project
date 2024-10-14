import '../../models/subject.dart';
import '../../models/student.dart';

abstract class SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<Subject> subjects;

  SubjectLoaded(this.subjects);
}

class SubjectLoadedById extends SubjectState {
  final Subject subject;

  SubjectLoadedById(this.subject);
}

class StudentsLoadedBySubjectId extends SubjectState {
  final List<Student> students;

  StudentsLoadedBySubjectId(this.students);
}

class SubjectAdded extends SubjectState {}

class SubjectError extends SubjectState {
  final String message;

  SubjectError(this.message);
}