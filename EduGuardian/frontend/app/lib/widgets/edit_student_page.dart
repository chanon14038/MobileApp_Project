import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/students_bloc.dart';
import '../models/student.dart';
import 'success_update_dialog.dart';

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
        title: Text("Edit Student Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _classroomController,
                decoration: InputDecoration(labelText: 'Classroom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the classroom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
                    showSuccessDialog(context);
                  }
                },
                child: Text('Save Changes'),
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
