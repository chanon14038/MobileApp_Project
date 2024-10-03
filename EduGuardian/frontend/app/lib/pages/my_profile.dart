import 'package:app/pages/change_password_page.dart';
import 'package:app/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text(
          'Profile',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel>(
        future: _getMeRepository.getMe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // เริ่มจากด้านบน
                children: [
                  Padding(
                    padding: EdgeInsets.all(7),
                    child: Container(
                      padding: EdgeInsets.all(50.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // สีพื้นหลัง

                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/profile_picture.png'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Advisor: ${user.advisorRoom}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tel: ${user.phoneNumber}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Email: ${user.email}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          // ปุ่ม Edit Profile และ Change Password
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.edit),
                          label: Text('Edit Profile'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 205, 188, 235),
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.lock),
                          label: Text('Change Password'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 205, 188, 235),
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.logout),
                          label: Text('Logout'),
                          onPressed: () {
                            _showLogoutConfirmation(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 65, vertical: 15),
                            backgroundColor:
                                const Color.fromARGB(255, 240, 158, 158),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Function to show logout confirmation dialog
  // ฟังก์ชันสำหรับแสดงกล่องยืนยันการออกจากระบบ
  // Function to show logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout
                context.read<AuthBloc>().add(AuthLogoutEvent());

                // Navigate to login page and remove all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
