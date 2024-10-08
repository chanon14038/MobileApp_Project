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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // ขอบโค้งมน
      ),
      title: Text(
        'Report for \n${student.firstName} ${student.lastName}',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Student ID: ${student.studentId}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            'Classroom: ${student.classroom}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Enter report details',
              border: OutlineInputBorder(), // กรอบให้กับช่องกรอก
            ),
            maxLines: 1, // ขยายช่องกรอกได้มากสุด 3 บรรทัด
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      actionsPadding: EdgeInsets.only(right: 12, bottom: 10),
      actions: [
        TextButton(
          onPressed: () {
            // สร้างออบเจ็กต์ report
            final report = Reports(
              studentId: student.studentId,
              description: _descriptionController.text,
            );

            // ส่งค่า report กลับไปยังหน้าที่เรียกใช้
            Navigator.of(context).pop(report);
          },
          child: const Text(
            'Submit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิด dialog โดยไม่ส่งค่ากลับ
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ],
      backgroundColor: Colors.white, // สีพื้นหลัง
    );
  }
}
