import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // ตัวแปรสำหรับควบคุมการมองเห็นรหัสผ่าน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // เปลี่ยนจาก Icon เป็น Image.asset
              Image.asset(
                'assets/images/eduguardian_logo.png', // ใช้รูปภาพ PNG แทน Icon
                width: 250,
                height: 250,
              ),
              // Text(
              //   'EDUGUADIAN',
              //   style: GoogleFonts.bebasNeue(
              //     fontSize: 50,
              //     fontWeight: FontWeight.w600,
              //     color: Color.fromARGB(255, 218, 106, 238),
              //   ),
              // ),
              const Text(
                'Hello Teacher!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushReplacementNamed(context, '/main');
                  } else if (state is AuthFailure) {
                    // แสดง popup ข้อความ error
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Row(
                            children: [
                              Icon(
                                Icons.warning, // ใช้ไอคอน warning สำหรับสัญลักษณ์ตกใจ
                                color: Colors.yellow,
                                size: 40, // ขนาดของไอคอน
                              ),
                              SizedBox(width: 10), // ระยะห่างระหว่างไอคอนและข้อความ
                              Expanded(
                                child: Text(
                                  'Login Failed',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          content: Text('Login failed: ${state.error}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // ปิด popup
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Center(
                  child: Column(
                    children: [
                      // Username
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 236, 236, 236),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 236, 236, 236),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible, // ใช้ตัวแปรควบคุม
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible =
                                          !_isPasswordVisible; // เปลี่ยนสถานะการมองเห็น
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Login Button with BlocBuilder
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return CircularProgressIndicator();
                            }
                            return Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    backgroundColor: Color.fromARGB(255, 48, 108, 28),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Call the login event
                                    context.read<AuthBloc>().add(
                                          AuthLoginEvent(
                                            _usernameController.text,
                                            _passwordController.text,
                                          ),
                                        );
                                  },
                                  child: Text(
                                    'Login'.toUpperCase(),
                                    style: GoogleFonts.dosis(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
