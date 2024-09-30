import 'package:flutter_bloc/flutter_bloc.dart';
import 'subject_event.dart';
import 'subject_state.dart';
import '../../repositories/subject_repository.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository subjectRepository;

  SubjectBloc(this.subjectRepository) : super(SubjectLoading()) {
    on<FetchSubjects>((event, emit) async {
      emit(SubjectLoading());
      try {
        final subjects = await subjectRepository.getSubjects();
        emit(SubjectLoaded(subjects));
      } catch (e) {
        emit(SubjectError(e.toString()));
      }
    });
  }
}
