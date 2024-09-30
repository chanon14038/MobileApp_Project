import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/student_repository.dart';
import '../blocs/student_profile.dart';

class StudentProfilePage extends StatelessWidget {
  final String studentId;

  const StudentProfilePage({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudentBloc(StudentRepository())..add(FetchStudentById(studentId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Student profile"),
          centerTitle: true,
        ),
        body: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SingleStudentLoaded) {
              final student = state.student;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${student.firstName} ${student.lastName}",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text("Student ID: ${student.studentId}",
                        style: const TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Classroom: ${student.classroom}",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                  ],
                ),
              );
            } else if (state is StudentError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is StudentNotFound) {
              return Center(child: Text('Student not found'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}