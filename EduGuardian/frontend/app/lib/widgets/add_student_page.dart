import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/students_bloc.dart';
import '../models/student.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _classroom = '';
  String _studentId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Student',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                labelText: 'First Name',
                icon: Icons.person, // เปลี่ยนเป็นไอคอนคน
                onSaved: (value) => _firstName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                labelText: 'Last Name',
                icon: Icons.person_outline, // ไอคอนคนแบบ outline
                onSaved: (value) => _lastName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                labelText: 'Classroom',
                icon: Icons.class_, // ไอคอนห้องเรียน
                onSaved: (value) => _classroom = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter classroom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                labelText: 'Student ID',
                icon: Icons.badge, // ไอคอนสำหรับ Student ID
                onSaved: (value) => _studentId = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newStudent = Student(
                      firstName: _firstName,
                      lastName: _lastName,
                      classroom: _classroom,
                      studentId: _studentId,
                    );

                    // เรียกใช้ Bloc เพื่อเพิ่มนักเรียนใหม่
                    BlocProvider.of<StudentBloc>(context)
                        .add(AddStudent(newStudent));

                    // กลับไปที่หน้า StudentPage และรีเฟรชหน้า
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color.fromARGB(249, 216, 244, 232),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27.0),
                  ),
                ),
                child: Text(
                  'Add Student',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 40, 120, 63),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 40, 120, 63)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
