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
                        _showReportDialog(context, studentNames[index]);
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

  // ฟังก์ชันแสดง popup รายงานการกระทำของนักเรียน
  void _showReportDialog(BuildContext context, String studentName) {
    TextEditingController descriptionController = TextEditingController();
    Map<String, bool> reasons = {
      'ดื้อ': false,
      'ซน': false,
      'กินขนม': false,
      'จีบสาว': false,
      'หลับ': false,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รายงานการกระทำของ $studentName'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('โปรดเลือกสาเหตุ:'),
                SizedBox(height: 10),
                Column(
                  children: reasons.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: reasons[key],
                      onChanged: (bool? value) {
                        // ใช้ setState ใน showDialog
                        (context as Element).markNeedsBuild();
                        reasons[key] = value ?? false;
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'คำอธิบายเพิ่มเติม',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด popup
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // รวบรวมข้อมูลรายงาน
                String selectedReasons = reasons.entries
                    .where((entry) => entry.value == true)
                    .map((entry) => entry.key)
                    .join(', ');

                String description = descriptionController.text;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'รายงาน ${studentName}\nสาเหตุ: $selectedReasons\nคำอธิบาย: $description'),
                  ),
                );
                Navigator.of(context).pop(); // ปิด popup
              },
              child: Text('รายงาน'),
            ),
          ],
        );
      },
    );
  }
}
