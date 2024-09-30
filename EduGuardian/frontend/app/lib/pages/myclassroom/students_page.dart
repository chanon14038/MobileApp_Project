import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/students_bloc.dart';
import '../../repositories/student_repository.dart';

class StudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentBloc(StudentRepository())..add(FetchStudents()),
      child: Scaffold(
        appBar: AppBar(title: Text('Students')),
        body: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentLoaded) {
              final students = state.students;
              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    title: Text('${student.firstName} ${student.lastName}'),
                    subtitle: Text('Classroom: ${student.classroom}'),
                  );
                },
              );
            } else if (state is StudentError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container(); // Default case
          },
        ),
      ),
    );
  }
}
