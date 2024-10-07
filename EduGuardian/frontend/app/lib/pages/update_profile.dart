import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/user_bloc.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  // Controllers สำหรับการเก็บข้อมูลในฟอร์ม
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController advisorRoomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch ข้อมูลผู้ใช้เมื่อหน้าโหลด
    context.read<UserBloc>().add(FetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 188, 157, 241), // ปรับสีของ AppBar
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            // เติมข้อมูลในฟอร์มเมื่อโหลดข้อมูลสำเร็จ
            firstNameController.text = state.user.firstName ?? '';
            lastNameController.text = state.user.lastName ?? '';
            subjectController.text = state.user.subject ?? '';
            phoneNumberController.text = state.user.phoneNumber ?? '';
            emailController.text = state.user.email ?? '';
            advisorRoomController.text = state.user.advisorRoom ?? '';

            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  _buildTextField(
                    controller: firstNameController,
                    labelText: 'First Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: lastNameController,
                    labelText: 'Last Name',
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: subjectController,
                    labelText: 'Subject',
                    icon: Icons.book,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: phoneNumberController,
                    labelText: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: advisorRoomController,
                    labelText: 'Advisor Room',
                    icon: Icons.class_,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // เรียก UpdateProfile event
                      context.read<UserBloc>().add(
                        UpdateProfile(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          subject: subjectController.text,
                          phoneNumber: phoneNumberController.text,
                          email: emailController.text,
                          advisorRoom: advisorRoomController.text,
                        ),
                      );
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      backgroundColor: Color.fromARGB(255, 188, 157, 241), // ปรับสีของปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text('Failed to load user data: ${state.message}'));
          } else {
            return Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
