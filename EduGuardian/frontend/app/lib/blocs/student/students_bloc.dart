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

    on<FetchStudentProfile>((event, emit) async {
      emit(StudentProfileLoading());
      try {
        final student = await studentRepository.getOneStudent(event.studentId);
        emit(StudentProfileLoaded(student));
      } catch (e) {
        if (e.toString().contains('Student not found')) {
          emit(StudentProfileNotFound());
        } else {
          emit(StudentError(e.toString()));
        }
      }
    });

    on<UpdateStudentProfile>((event, emit) async {
      emit(StudentUpdating());
      try {
        await studentRepository.updateStudent(
            event.studentId, event.firstName, event.lastName, event.classroom);
        emit(StudentUpdated());
        add(FetchStudents());
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });
  }
}
