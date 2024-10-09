import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/user_bloc.dart';
import '../repositories/get_me_repository.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
      ),
      body: BlocProvider(
        create: (context) => UserBloc(UserRepository()),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              _showSuccessDialog(context); // แสดง popup เมื่อสำเร็จ
            } else if (state is ChangePasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
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
                    obscureText: _isNewPasswordObscured,
                    toggleVisibility: () {
                      setState(() {
                        _isNewPasswordObscured = !_isNewPasswordObscured;
                      });
                    },
                    isObscured: _isNewPasswordObscured,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm New Password',
                    icon: Icons.lock_outline,
                    obscureText: _isConfirmPasswordObscured,
                    toggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordObscured =
                            !_isConfirmPasswordObscured;
                      });
                    },
                    isObscured: _isConfirmPasswordObscured,
                  ),
                  SizedBox(height: 30),
                  if (state is ChangePasswordLoading)
                    CircularProgressIndicator() // แสดง Loading ขณะกำลังเปลี่ยนรหัสผ่าน
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (newPasswordController.text ==
                            confirmPasswordController.text) {
                          context.read<UserBloc>().add(
                                ChangePasswordEvent(
                                  currentPassword:
                                      currentPasswordController.text,
                                  newPassword: newPasswordController.text,
                                ),
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        backgroundColor: Color.fromARGB(249, 216, 244, 232),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27.0),
                        ),
                      ),
                      child: Text(
                        'Change Password',
                        style: TextStyle(fontSize: 18,
                        color: Color.fromARGB(255, 40, 120, 63)),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    bool isObscured = true,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 40, 120, 63)),
        suffixIcon: toggleVisibility != null
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Color.fromARGB(255, 40, 120, 63),
                ),
                onPressed: toggleVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  // ฟังก์ชันแสดง popup สำเร็จพร้อมเครื่องหมายถูก
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 15),
              Text(
                'Password Changed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Your password has been successfully changed.',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด popup
                  Navigator.of(context).pop(); // กลับไปหน้าเดิม
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
