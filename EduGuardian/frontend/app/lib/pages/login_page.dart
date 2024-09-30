import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/login_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.all_inclusive,
              size: 150,
              ),
              Text(
                'EDUGUADIAN',
                style: GoogleFonts.bebasNeue(
                  fontSize: 50,
                  fontWeight: FontWeight.w600, 
                  color: Color.fromARGB(255, 218, 106, 238), 
                ),
              ),
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
                    // ถ้า login สำเร็จ ไปหน้าหลัก
                    Navigator.pushReplacementNamed(context, '/main');
                  } else if (state is AuthFailure) {
                    // แสดงข้อความ error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: ${state.error}')),
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
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Login Button with BlocBuilder
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return CircularProgressIndicator();
                            }
                            return Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: const Color.fromARGB(255, 218, 106, 238),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
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
                                  'Login'
                                   .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,),
                                    )
                                ),
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
