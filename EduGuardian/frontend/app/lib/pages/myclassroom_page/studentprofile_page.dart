import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  final String studentName;
  final String studentId;

  StudentProfilePage({
    required this.studentName,
    required this.studentId,
  });

  // รายการรีพอร์ต (เหตุการณ์) ของนักเรียน
  final List<String> reportList = [
    'ดื้อในห้องเรียน',
    'ส่งงานช้า',
    'กินขนมในห้อง',
    'ไม่ทำการบ้าน',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์นักเรียน'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปโปรไฟล์นักเรียน
            Center(
              child: CircleAvatar(
                radius: 60, // ขนาดของรูปภาพ
                backgroundImage: AssetImage('assets/student_picture.png'), // รูปโปรไฟล์จาก assets
              ),
            ),
            SizedBox(height: 20), // เว้นระยะห่างระหว่างรูปภาพกับข้อมูลโปรไฟล์

            // ข้อมูลโปรไฟล์นักเรียน
            Text(
              'ชื่อ: $studentName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'รหัสประจำตัว: $studentId',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'รีพอร์ต:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // แสดงรายการรีพอร์ต
            Expanded(
              child: ListView.builder(
                itemCount: reportList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(reportList[index]),
                    onTap: () {
                      // เมื่อกดไอเท็มสามารถเพิ่ม action หรือ popup อะไรได้ตามที่ต้องการ
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('รีพอร์ต: ${reportList[index]}')),
                      );
                    },
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
