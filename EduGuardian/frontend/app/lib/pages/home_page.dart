import 'package:flutter/material.dart';
import 'login_page.dart'; // เรียกใช้หน้า Login เพื่อใช้ใน logout

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // การทำงานของปุ่มแรก
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Button 1 pressed')),
                );
              },
              child: Text('ครูประจำชั้น'),
            ),
            SizedBox(height: 20), // เพิ่มระยะห่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () {
                // การทำงานของปุ่มที่สอง
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Button 2 pressed')),
                );
              },
              child: Text('ครูประจำวิชา'),
            ),
            SizedBox(height: 40), // เพิ่มระยะห่างระหว่างปุ่มกับปุ่ม logout
            ElevatedButton(
              onPressed: () {
                // การทำงานของปุ่ม Logout จะนำผู้ใช้กลับไปที่หน้า Login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
