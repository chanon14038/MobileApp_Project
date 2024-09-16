import 'package:app/teaching_page/report_student.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatelessWidget {
  final List<Map<String, String>> classrooms = [
    {
      'ชื่อวิชา': 'คณิตศาสตร์',
      'รหัสวิชา': 'MATH101',
      'ห้องที่สอน': 'ห้อง 101',
      'คำอธิบาย': 'เรียนรู้พื้นฐานคณิตศาสตร์',
    },
    {
      'ชื่อวิชา': 'วิทยาศาสตร์',
      'รหัสวิชา': 'SCI102',
      'ห้องที่สอน': 'ห้อง 102',
      'คำอธิบาย': 'สำรวจโลกวิทยาศาสตร์',
    },
    {
      'ชื่อวิชา': 'ภาษาอังกฤษ',
      'รหัสวิชา': 'ENG103',
      'ห้องที่สอน': 'ห้อง 103',
      'คำอธิบาย': 'พัฒนาทักษะภาษาอังกฤษ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ห้องเรียนที่สอน'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: classrooms.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(classrooms[index]['ชื่อวิชา']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('รหัสวิชา: ${classrooms[index]['รหัสวิชา']}'),
                  Text('ห้องที่สอน: ${classrooms[index]['ห้องที่สอน']}'),
                  SizedBox(height: 5),
                  Text('คำอธิบาย: ${classrooms[index]['คำอธิบาย']}'),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                // เมื่อกดที่กล่อง ให้ไปที่หน้าอื่น
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassroomDetailPage(
                      subjectName: classrooms[index]['ชื่อวิชา']!,
                      subjectCode: classrooms[index]['รหัสวิชา']!,
                      room: classrooms[index]['ห้องที่สอน']!,
                      description: classrooms[index]['คำอธิบาย']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
