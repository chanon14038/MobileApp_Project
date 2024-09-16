import 'package:app/teaching_page/reportdialog_widget.dart';
import 'package:flutter/material.dart';


class ClassroomDetailPage extends StatelessWidget {
  final String subjectName;
  final String subjectCode;
  final String room;
  final String description;

  // รายชื่อนักเรียน
  final List<String> studentNames = [
    'สมชาย แซ่ลี้',
    'สมหญิง ทองดี',
    'จิตติ เพ็งดี',
    'วรรณา วิริยะ',
    'สุชาติ ยอดเยี่ยม',
  ];

  ClassroomDetailPage({
    required this.subjectName,
    required this.subjectCode,
    required this.room,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ข้อมูลห้องเรียน
            Text(
              'ชื่อวิชา: $subjectName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'รหัสวิชา: $subjectCode',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'ห้องที่สอน: $room',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'คำอธิบาย:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // หัวข้อสำหรับรายชื่อนักเรียน
            Text(
              'รายชื่อนักเรียน:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // แสดงรายชื่อนักเรียนเป็นลิสต์
            Expanded(
              child: ListView.builder(
                itemCount: studentNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(studentNames[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.report),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ReportDialog(
                            studentName: studentNames[index],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
