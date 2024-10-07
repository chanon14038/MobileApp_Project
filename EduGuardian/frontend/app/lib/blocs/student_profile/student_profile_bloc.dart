import 'package:flutter_bloc/flutter_bloc.dart';
import 'student_profile_event.dart';
import 'student_profile_state.dart';
import '../../repositories/student_repository.dart';

class StudentProfileBloc extends Bloc<StudentProfileEvent, StudentProfileState> {
  final StudentRepository studentRepository;

  StudentProfileBloc(this.studentRepository) : super(StudentProfileLoading()) {
    on<FetchStudentProfile>((event, emit) async {
      emit(StudentProfileLoading());
      try {
        final student = await studentRepository.getStudents();
        emit(StudentProfileLoaded(student));
      } catch (e) {
        emit(StudentProfileError(e.toString()));
      }
    });

    on<FetchStudentProfileById>((event, emit) async {
      emit(StudentProfileLoading());
      try {
        final student = await studentRepository.getOneStudent(event.studentId);
        emit(SingleStudentProfileLoaded(student));
      } catch (e) {
        if (e.toString().contains('Student not found')) {
          emit(StudentProfileNotFound());
        } else {
          emit(StudentProfileError(e.toString()));
        }
      }
    });
  }
}
