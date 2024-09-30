import 'package:flutter_bloc/flutter_bloc.dart';
import 'students_event.dart';
import 'students_state.dart';
import '../../repositories/student_repository.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;

  StudentBloc(this.studentRepository) : super(StudentLoading());

  Stream<StudentState> mapEventToState(StudentEvent event) async* {
    if (event is FetchStudents) {
      yield StudentLoading();
      try {
        final students = await studentRepository.getStudents();
        yield StudentLoaded(students);
      } catch (e) {
        yield StudentError(e.toString());
      }
    }
  }
}