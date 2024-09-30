import 'package:flutter/material.dart';
import '../../models/models.dart';

class StudentProfilePage extends StatelessWidget {
  final Student student;

  const StudentProfilePage({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${student.firstName} ${student.lastName}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Student ID: ${student.studentId}",
                style: const TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Classroom: ${student.classroom}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            // Add more details if available in the Student model
          ],
        ),
      ),
    );
  }
}
