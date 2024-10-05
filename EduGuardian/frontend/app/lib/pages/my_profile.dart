import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/get_me_repository.dart';
import '../blocs/auth_bloc.dart';
import '../models/user_model.dart'; // นำเข้า UserModel
import 'login_page.dart'; // นำเข้า LoginPage เพื่อใช้ในปุ่ม Logout
import 'change_password_page.dart'; // นำเข้า ChangePasswordPage
import 'edit_profile_page.dart'; // นำเข้า EditProfilePage

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(7),
                    child: Container(
                      padding: EdgeInsets.all(50.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                            radius: 50,
                            backgroundImage: user.imageData != null
                                ? MemoryImage(user
                                    .imageData!) // Use MemoryImage for Uint8List
                                : AssetImage('assets/placeholder.png')
                                    as ImageProvider, // Fallback to placeholder if no image
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
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      // ปุ่ม Edit Profile
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // ปุ่ม Change Password
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // ปุ่ม Logout
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
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
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          actionsPadding: EdgeInsets.only(right: 12, bottom: 10),
        );
      },
    );
  }
}
