import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/student_repository.dart';
import '../blocs/student_profile.dart';

class StudentProfilePage extends StatefulWidget {
  final String studentId;
  final List<String> descriptions; // รับรายการ description เข้ามา

  const StudentProfilePage({required this.studentId, required this.descriptions});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudentBloc(StudentRepository())..add(FetchStudentById(widget.studentId)),
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
                    Text("Advisor: ${student.advisor}",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Text(
                      "Description:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.descriptions.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                widget.descriptions[index],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
