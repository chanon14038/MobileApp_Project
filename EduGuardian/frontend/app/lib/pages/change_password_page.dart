import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
        // backgroundColor: Color.fromARGB(255, 188, 157, 241), // ปรับสีของ AppBar เหมือนหน้า Edit Profile
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _buildTextField(
              controller: currentPasswordController,
              labelText: 'Current Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 15),
            _buildTextField(
              controller: newPasswordController,
              labelText: 'New Password',
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            SizedBox(height: 15),
            _buildTextField(
              controller: confirmPasswordController,
              labelText: 'Confirm New Password',
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  // Proceed with password change logic
                } else {
                  // Show error: passwords do not match
                }
              },
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                backgroundColor: Color.fromARGB(255, 188, 157,
                    241), // ปรับสีของปุ่มให้เหมือนกับหน้า Edit Profile
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText, // ใช้สำหรับฟิลด์รหัสผ่าน
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
