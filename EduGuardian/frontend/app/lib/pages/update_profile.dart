import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_bloc.dart';
import '../models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/buildtextfield.dart';
import '../widgets/success_update_dialog.dart';

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
            buildTextField(
              controller: firstNameController,
              labelText: 'First Name',
              icon: Icons.person,
            ),
            SizedBox(height: 15),
            buildTextField(
              controller: lastNameController,
              labelText: 'Last Name',
              icon: Icons.person_outline,
            ),
            SizedBox(height: 15),
            buildTextField(
              controller: subjectController,
              labelText: 'Subject',
              icon: Icons.subject,
            ),
            SizedBox(height: 15),
            buildTextField(
              controller: phoneNumberController,
              labelText: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15),
            buildTextField(
              controller: emailController,
              labelText: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15),
            buildTextField(
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
                showUpdateSuccessDialog(context);
              },
              child: Text(
                'Save Changes',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 40, 120, 63)),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                backgroundColor: Color.fromARGB(249, 216, 244, 232),
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
}
