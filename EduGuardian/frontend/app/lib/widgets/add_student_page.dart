import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) => _firstName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => _lastName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Classroom'),
                onSaved: (value) => _classroom = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter classroom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Student ID'),
                onSaved: (value) => _studentId = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
                child: Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
