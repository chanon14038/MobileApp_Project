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

    on<AddStudent>((event, emit) async {
      emit(StudentAdding());
      try {
        final addedStudent = await studentRepository.addStudent(event.student);
        emit(StudentAdded(addedStudent));

        // ดึงข้อมูลนักเรียนทั้งหมดอีกครั้งหลังจากเพิ่มสำเร็จ
        final students = await studentRepository.getStudents();
        emit(StudentLoaded(students));
      } catch (e) {
        emit(StudentError('Failed to add student: ${e.toString()}'));
      }
    });
  }
}
