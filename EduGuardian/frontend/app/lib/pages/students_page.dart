import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/students_bloc.dart';
import '../repositories/student_repository.dart';
import 'studentprofile_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isSearching = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
            begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudentBloc(StudentRepository())..add(FetchStudents()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (!isSearching)
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          // เพิ่ม Padding
                          padding:
                              const EdgeInsets.only(left: 45), // ขยับไปทางขวา
                          child: Text(
                            'My Students',
                            key: ValueKey<bool>(!isSearching),
                            style: GoogleFonts.bebasNeue(
                              fontSize: 27,
                              color: Color.fromARGB(255, 96, 96, 96),
                            ),
                          ),
                        ),
                      ),
                    if (isSearching)
                      SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          key: ValueKey<bool>(isSearching),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 240, 240),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search students...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              border: InputBorder.none,
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey[600]),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                isSearching ? Icons.clear : Icons.search,
                color: const Color.fromARGB(255, 90, 90, 90),
              ),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchQuery = '';
                    searchController.clear();
                  }
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 216, 244),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                                  child: Icon(Icons.person,
                                      color: Colors.grey[600]),
                                ),
                                title: Text(
                                  '${student.firstName} ${student.lastName}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text('Classroom: ${student.classroom}'),
                                onTap: () {
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
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
