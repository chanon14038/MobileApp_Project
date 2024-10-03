import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // นำเข้า Bloc
import '../repositories/get_me_repository.dart';
import '../blocs/auth_bloc.dart';
import 'login_page.dart'; // นำเข้า LoginPage เพื่อใช้ในปุ่ม Logout

class GetMePage extends StatelessWidget {
  final GetMeRepository _getMeRepository = GetMeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true, // ทำให้ชื่ออยู่ตรงกลาง
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getMeRepository.getMe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data;
            return Column(
              children: [
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
                            '${user!['first_name']} ${user!['last_name']}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10), // เว้นระยะห่างระหว่างรายละเอียด
                          Text(
                            'ครูประจำชั: ${user['advisor_room']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'เบอร์โทรศัพท์: ${user['phone_number']}', // แสดงเบอร์โทรศัพท์จากข้อมูล
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Email: ${user['email']}', // แสดงเบอร์โทรศัพท์จากข้อมูล
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
                      // ส่ง AuthLogoutEvent
                      context.read<AuthBloc>().add(AuthLogoutEvent());

                      // นำทางกลับไปที่หน้า Login
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
            );
          }
        },
      ),
    );
  }
}
