import '../../models/subject.dart';

abstract class SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<Subject> subjects;

  SubjectLoaded(this.subjects);
}

class SubjectError extends SubjectState {
  final String message;

  SubjectError(this.message);
}
