import 'package:flutter_bloc/flutter_bloc.dart';
import 'students_event.dart';
import 'students_state.dart';
import '../../repositories/student_repository.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;

  StudentBloc(this.studentRepository) : super(StudentLoading()) {
    
    on<FetchStudents>((event, emit) async {
      emit(StudentLoading());
      try {
        final students = await studentRepository.getStudents();
        emit(StudentLoaded(students));
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });
  }
}
