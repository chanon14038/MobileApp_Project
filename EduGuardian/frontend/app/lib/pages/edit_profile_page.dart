import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
        // backgroundColor: Color.fromARGB(255, 188, 157, 241), // ปรับสีของ AppBar
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
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle save logic here
              },
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                backgroundColor:
                    Color.fromARGB(255, 188, 157, 241), // ปรับสีของปุ่ม
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
}
