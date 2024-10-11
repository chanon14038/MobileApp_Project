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
            maxLines: 1, // จำกัดการกรอกได้มากสุด 1 บรรทัด
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      actionsPadding: EdgeInsets.only(right: 12, bottom: 10),
      actions: [
        TextButton(
          onPressed: () {
            // ตรวจสอบว่ากรอกข้อมูลแล้วหรือยัง
            if (_descriptionController.text.isEmpty) {
              // แสดงแจ้งเตือนถ้ายังไม่กรอกข้อความ
              _showErrorDialog(context);
              return;
            }

            // สร้างออบเจ็กต์ report
            final report = Reports(
              studentId: student.studentId,
              description: _descriptionController.text,
            );

            // ส่งค่า report กลับไปยังหน้าที่เรียกใช้
            Navigator.of(context).pop(report);

            // แสดง popup ยืนยันเมื่อส่ง report สำเร็จ
            _showSuccessDialog(context);
          },
          child:  const Text(
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

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Input Required',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Please enter a description for the report.',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด popup
              },
              child: const Text(
                'OK',
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
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Report Submitted',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Your report has been successfully submitted.',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด popup
              },
              child: const Text(
                'OK',
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
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
