import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true, // ทำให้ชื่ออยู่ตรงกลาง
      ),
      body: Column(
        children: [
          // เนื้อหาหลักที่อยู่กลางหน้าจอ
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 60, // ขนาดของรูปภาพ
                      backgroundImage: AssetImage('assets/profile_picture.png'), // รูปภาพโปรไฟล์จาก assets
                    ),
                    SizedBox(height: 20), // เว้นระยะห่างระหว่างรูปกับรายละเอียด
                    Text(
                      'ชื่อผู้ใช้: John Doe',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10), // เว้นระยะห่างระหว่างรายละเอียด
                    Text(
                      'อีเมล: john.doe@example.com',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'เบอร์โทรศัพท์: 080-123-4567',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ปุ่ม Logout ที่อยู่ล่างสุด
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: () {
                // การทำงานของปุ่ม Logout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // กลับไปที่หน้า Login
                );
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
