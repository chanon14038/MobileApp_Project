import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/subject_bloc.dart';
import '../models/subject.dart';
import '../widgets/add_success_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSubjectPage extends StatefulWidget {
  @override
  _AddSubjectPageState createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final _formKey = GlobalKey<FormState>();
  String? _classroom;
  String? _subject;
  String? _subjectId;
  String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Subject',
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
                labelText: 'Classroom',
                icon: Icons.class_,
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
                labelText: 'Subject',
                icon: Icons.book,
                onSaved: (value) => _subject = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                labelText: 'Subject ID',
                icon: Icons.badge,
                onSaved: (value) => _subjectId = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                labelText: 'Description (optional)', // Indicate it's optional
                icon: Icons.description,
                maxLines: 3,
                onSaved: (value) => _description = value, // Allow empty string
                validator: null, // Change this line to handle optional
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newSubject = Subject(
                      classroom: _classroom!,
                      subject: _subject!,
                      subjectId: _subjectId!,
                      description: _description ??
                          '', // If description is null, assign empty string
                    );
                    BlocProvider.of<SubjectBloc>(context)
                        .add(AddSubject(newSubject));
                    showAddSuccessDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color.fromARGB(249, 216, 244, 232),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27.0),
                  ),
                ),
                child: const Text(
                  'Add Subject',
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
    FormFieldValidator<String>? validator, // Make validator optional
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
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
