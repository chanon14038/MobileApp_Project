import 'package:flutter_bloc/flutter_bloc.dart';
import 'student_profile_event.dart';
import 'student_profile_state.dart';
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

    on<FetchStudentById>((event, emit) async {
      emit(StudentLoading());
      try {
        final student = await studentRepository.getOneStudent(event.studentId);
        emit(SingleStudentLoaded(student));
      } catch (e) {
        if (e.toString().contains('Student not found')) {
          emit(StudentNotFound());
        } else {
          emit(StudentError(e.toString()));
        }
      }
    });
  }
}
