import 'package:app/pages/reportdialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/subject_bloc.dart';
import '../repositories/subject_repository.dart';

class SubjectByIDPage extends StatelessWidget {
  final String subjectId;

  const SubjectByIDPage({Key? key, required this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 226, 216, 244), // Light purple background
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 226, 216, 244), // Match background color
        title: Text(
          'Subject Details',
          style: GoogleFonts.bebasNeue(
            fontSize: 30,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back button
          },
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SubjectBloc(SubjectRepository())
              ..add(FetchSubjectById(subjectId)), // Load subject data
          ),
          BlocProvider(
            create: (context) => StudentsBloc(SubjectRepository())
              ..add(FetchStudentsBySubjectId(subjectId)), // Load students
          ),
        ],
        child: Padding(
          padding:
              const EdgeInsets.all(20.0), // Similar padding to the profile page
          child: Column(
            children: [
              // Subject Information Card
              Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // White card
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: BlocBuilder<SubjectBloc, SubjectState>(
                  builder: (context, state) {
                    if (state is SubjectLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SubjectLoadedById) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Subject ID: ${state.subject.id}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Subject Name: ${state.subject.subject}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Additional Info: ${state.subject.description ?? "No additional info"}',
                            style: const TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                        ],
                      );
                    } else if (state is SubjectError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Students List Header
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Text(
                  "Students List",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 24,
                    color: Color.fromARGB(255, 96, 96, 96), // Header color
                  ),
                ),
              ),

              // Students List
              Expanded(
                child: BlocBuilder<StudentsBloc, SubjectState>(
                  builder: (context, state) {
                    if (state is SubjectLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StudentsLoadedBySubjectId) {
                      return ListView.builder(
                        itemCount: state.students.length,
                        itemBuilder: (context, index) {
                          final student = state.students[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child:
                                    Icon(Icons.person, color: Colors.grey[600]),
                              ),
                              title: Text(
                                '${student.firstName} ${student.lastName}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('ID: ${student.studentId}'),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ReportDialog(student: student),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is SubjectError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
