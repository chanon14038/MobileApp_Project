import 'package:app/pages/myclassroom_page/studentprofile_page.dart';
import 'package:flutter/material.dart';

class MyClassroomPage extends StatelessWidget {
  // เลขห้องเรียน
  final String classroomNumber = '101';
  
  // รายชื่อนักเรียนพร้อมรหัสประจำตัว
  final List<Map<String, String>> students = [
    {'name': 'สมชาย แซ่ลี้', 'id': '1001'},
    {'name': 'สมหญิง ทองดี', 'id': '1002'},
    {'name': 'จิตติ เพ็งดี', 'id': '1003'},
    {'name': 'วรรณา วิริยะ', 'id': '1004'},
    {'name': 'สุชาติ ยอดเยี่ยม', 'id': '1005'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ห้องเรียน: $classroomNumber', // แสดงเลขห้องเรียน
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'รายชื่อนักเรียน', // หัวข้อหลักของ AppBar
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Card(
              elevation: 3, // ทำให้ card ดูมีเงาเล็กน้อย
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // มุมโค้งของ card
              ),
              child: ListTile(
                title: Text(
                  'รหัส${students[index]['id']} - ${students[index]['name']}', // รหัสนักเรียน + ชื่อ
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  // กดเพื่อไปยังหน้าโปรไฟล์ของนักเรียน พร้อมส่งข้อมูล
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentProfilePage(
                        studentName: students[index]['name']!,
                        studentId: students[index]['id']!,
                        classroomNumber: classroomNumber, // ส่งเลขห้องเรียนไปยังหน้าโปรไฟล์
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
