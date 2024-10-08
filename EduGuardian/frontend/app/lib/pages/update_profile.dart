import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_bloc.dart';
import '../models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateProfilePage extends StatefulWidget {
  final UserModel user;

  UpdateProfilePage({required this.user});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController subjectController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController advisorRoomController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    subjectController = TextEditingController(text: widget.user.subject);
    phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    emailController = TextEditingController(text: widget.user.email);
    advisorRoomController =
        TextEditingController(text: widget.user.advisorRoom);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    subjectController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    advisorRoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
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
              icon: Icons.subject,
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
              icon: Icons.room,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Dispatch the update profile event
                BlocProvider.of<UserBloc>(context).add(UpdateProfile(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  subject: subjectController.text,
                  phoneNumber: phoneNumberController.text,
                  email: emailController.text,
                  advisorRoom: advisorRoomController.text,
                ));

                // แสดง popup เมื่อบันทึกสำเร็จ
                _showSuccessDialog(context);
              },
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                backgroundColor: Color.fromARGB(255, 188, 157, 241),
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

  // ฟังก์ชันแสดง popup สำเร็จพร้อมข้อความ
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
                'Profile Updated!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Your profile has been successfully updated.',
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
