import 'package:app/myclassroom/studentprofile_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/students_bloc_app.dart';

import '../models/models.dart';

class StudentListPage extends StatelessWidget {
  final String classroom;

  StudentListPage({required this.classroom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student List"),
      ),
      body: BlocProvider(
        create: (context) => StudentBloc(Dio())..add(FetchStudents(classroom)),
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentLoaded) {
              return ListView.builder(
                itemCount: state.students.length,
                itemBuilder: (context, index) {
                  final Student student = state.students[index];
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
                        subtitle: Text('Class: ${student.classroom}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentProfilePage(student: student),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is StudentError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
