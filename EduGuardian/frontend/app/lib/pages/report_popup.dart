import 'package:flutter/material.dart';

import '../models/reports.dart';
import '../models/student.dart';

class ReportPopup extends StatelessWidget {
  final Student student;
  final TextEditingController _descriptionController = TextEditingController();

  ReportPopup({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report for ${student.firstName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ID: ${student.studentId}'),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Enter report details'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Create report object
            final report = Reports(
              studentId: student.studentId,
              description: _descriptionController.text,
            );

            // ส่งค่า report กลับไปยังหน้าที่เรียกใช้
            Navigator.of(context).pop(report);
          },
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without returning data
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
