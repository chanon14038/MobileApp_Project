import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../models/models.dart';
import 'students_event.dart';
import 'students_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final Dio dio;

  StudentBloc(this.dio) : super(StudentInitial()) {
    on<FetchStudents>((event, emit) async {
      emit(StudentLoading());
      try {
        final response = await dio.get('http://127.0.0.1:8000/students');
        List<Student> students = (response.data as List)
            .map((studentJson) => Student.fromJson(studentJson))
            .toList();

        // Filter students by classroom from the event
        List<Student> filteredStudents = students
            .where((student) => student.classroom == event.classroom)
            .toList();

        emit(StudentLoaded(filteredStudents));
      } catch (error) {
        emit(StudentError("Failed to fetch students"));
      }
    });
  }
}
