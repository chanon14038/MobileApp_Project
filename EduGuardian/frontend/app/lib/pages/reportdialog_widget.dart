import 'package:app/models/student.dart';
import 'package:flutter/material.dart';

class ReportDialog extends StatelessWidget {
  final Student student; // Assume you want to show student info

  const ReportDialog({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report for ${student.firstName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ID: ${student.studentId}'),
          const SizedBox(height: 10),
          // Add more fields as needed
          TextField(
            decoration: InputDecoration(labelText: 'Enter report details'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle the report submission
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
