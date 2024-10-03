import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/get_me_repository.dart';
import '../blocs/auth_bloc.dart';
import '../models/user_model.dart'; // นำเข้า UserModel
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
      body: FutureBuilder<UserModel>(
        future:
            _getMeRepository.getMe(), // ใช้ UserModel แทน Map<String, dynamic>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
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
                            backgroundImage: AssetImage(
                                'assets/profile_picture.png'), // รูปภาพโปรไฟล์จาก assets
                          ),
                          SizedBox(
                              height:
                                  20), // เว้นระยะห่างระหว่างรูปกับรายละเอียด
                          Text(
                            '${user.firstName} ${user.lastName}', // แสดงชื่อจาก UserModel
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10), // เว้นระยะห่างระหว่างรายละเอียด
                          Text(
                            'ครูประจำชั้น: ${user.advisorRoom}', // แสดง advisorRoom จาก UserModel
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'เบอร์โทรศัพท์: ${user.phoneNumber}', // แสดงเบอร์โทรศัพท์จาก UserModel
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Email: ${user.email}', // แสดง Email จาก UserModel
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
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage()), // กลับไปที่หน้า Login
                      );
                    },
                    child: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
