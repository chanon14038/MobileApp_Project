import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/students_bloc.dart';
import '../repositories/student_repository.dart';
import 'studentprofile_page.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudentBloc(StudentRepository())..add(FetchStudents()),
      child: Scaffold(
        appBar: AppBar(
          title: isSearching
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search students...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                )
              : Text(
                  'My Students',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 27,
                    color: Color.fromARGB(255, 96, 96, 96),
                  ),
                ),
          centerTitle: true,
          actions: [
            isSearching
                ? IconButton(
                    icon: Icon(Icons.clear,
                        color: const Color.fromARGB(255, 90, 90, 90)),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        searchQuery = '';
                        searchController.clear();
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search,
                        color: const Color.fromARGB(255, 90, 90, 90)),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(), // เพิ่ม padding รอบ ListView
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 216, 244), // พื้นหลังขาวสำหรับกรอบ
              borderRadius: BorderRadius.circular(20), // มุมโค้งของกรอบ
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // เงารอบกรอบ
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0), // เพิ่ม padding ภายในกรอบ
              child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
                  if (state is StudentLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is StudentLoaded) {
                    final students = state.students.where((student) {
                      return searchQuery.isEmpty ||
                          '${student.firstName} ${student.lastName}'
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase());
                    }).toList();

                    if (students.isEmpty) {
                      return Center(child: Text('No students found.'));
                    }

                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0), // เพิ่ม padding ด้านบนและล่างของการ์ด
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(Icons.person, color: Colors.grey[600]),
                                ),
                                title: Text(
                                  '${student.firstName} ${student.lastName}',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Classroom: ${student.classroom}'),
                                onTap: () {
                                  // Navigate to Student Profile Page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentProfilePage(
                                          studentId: '${student.studentId}'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is StudentError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Container(); // Default case
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
