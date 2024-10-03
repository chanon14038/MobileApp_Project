import '../../models/subject.dart';

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

class SubjectError extends SubjectState {
  final String message;

  SubjectError(this.message);
}
