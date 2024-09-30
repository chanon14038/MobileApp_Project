import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/students_bloc.dart';
import '../repositories/student_repository.dart';
import 'studentprofile_page.dart';

class StudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudentBloc(StudentRepository())..add(FetchStudents()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Students'),
        ),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('${student.firstName} ${student.lastName}'),
                        subtitle: Text('Classroom: ${student.classroom}'),
                        onTap: () {
                          // Navigate to Student Profile Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentProfilePage(
                                  studentId: '${student.studentId}'),
                            ),
                          );
                        },
                      ),
                    ),
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
