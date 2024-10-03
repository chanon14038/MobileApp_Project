import 'package:flutter_bloc/flutter_bloc.dart';
import 'subject_event.dart';
import 'subject_state.dart';
import '../../repositories/subject_repository.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository subjectRepository;

  SubjectBloc(this.subjectRepository) : super(SubjectLoading()) {
    // Fetch all subjects
    on<FetchSubjects>((event, emit) async {
      emit(SubjectLoading());
      try {
        final subjects = await subjectRepository.getSubjects();
        emit(SubjectLoaded(subjects));
      } catch (e) {
        emit(SubjectError(e.toString()));
      }
    });

    // Fetch subject by ID
    on<FetchSubjectById>((event, emit) async {
      emit(SubjectLoading());
      try {
        final subject = await subjectRepository.getSubjectById(event.subjectId);
        emit(SubjectLoadedById(subject));
      } catch (e) {
        emit(SubjectError(e.toString()));
      }
    });
  }
}

class StudentsBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository subjectRepository;

  StudentsBloc(this.subjectRepository) : super(SubjectLoading()) {
    // Fetch students by subject ID
    on<FetchStudentsBySubjectId>((event, emit) async {
      emit(SubjectLoading());
      try {
        final students = await subjectRepository.getStudentsBySubjectId(event.subjectId);
        emit(StudentsLoadedBySubjectId(students));
      } catch (e) {
        emit(SubjectError(e.toString()));
      }
    });
  }
}