import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/students_bloc.dart';
import '../models/student.dart';
import '../widgets/buildtextfield.dart';
import '../widgets/success_update_dialog.dart';

class EditStudentProfilePage extends StatefulWidget {
  final Student student;

  const EditStudentProfilePage({required this.student});

  @override
  _EditStudentProfilePageState createState() => _EditStudentProfilePageState();
}

class _EditStudentProfilePageState extends State<EditStudentProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _classroomController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student.firstName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _classroomController =
        TextEditingController(text: widget.student.classroom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Student Profile',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                icon: Icons.person,
              ),
              SizedBox(height: 15),
              buildTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 15),
              buildTextField(
                controller: _classroomController,
                labelText: 'Classroom',
                icon: Icons.class_,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Dispatch update student event
                    context.read<StudentBloc>().add(
                          UpdateStudentProfile(
                            widget.student.studentId.toString(),
                            _firstNameController.text,
                            _lastNameController.text,
                            _classroomController.text,
                          ),
                        );
                    showUpdateSuccessDialog(context);
                  }
                },
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 40, 120, 63),
                  ),
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
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _classroomController.dispose();
    super.dispose();
  }
}
