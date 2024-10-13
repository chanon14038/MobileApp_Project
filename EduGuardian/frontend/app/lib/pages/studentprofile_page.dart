import 'package:app/repositories/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/report_bloc.dart';
import '../repositories/student_repository.dart';
import '../blocs/student_profile_bloc.dart';

class StudentProfilePage extends StatefulWidget {
  final String studentId;

  const StudentProfilePage({
    required this.studentId,
  });

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentProfileBloc(StudentRepository())
        ..add(FetchStudentProfileById(widget.studentId)),
      child: Scaffold(
        backgroundColor: Color.fromARGB(249, 216, 244, 232), // พื้นหลังสีม่วง
        appBar: AppBar(
          backgroundColor: Color.fromARGB(249, 216, 244, 232),
          title: Text(
            "Student Profile",
            style: GoogleFonts.bebasNeue(
              fontSize: 30,
              color: Color.fromARGB(255, 96, 96, 96),
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<StudentProfileBloc, StudentProfileState>(
          builder: (context, state) {
            if (state is StudentProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SingleStudentProfileLoaded) {
              final student = state.student;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // ส่วนบน: กล่องโปรไฟล์นักเรียน
                    Container(
                      height: 290,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // กรอบสีขาว
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "${student.firstName} ${student.lastName}",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text("Student ID: ${student.studentId}",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Text("Classroom: ${student.classroom}",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Text("Advisor: ${student.advisor}",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // ส่วนล่าง: ListView ของรายงานโดยไม่มี Container หุ้ม
                    Expanded(
                      child: BlocProvider(
                        create: (context) => ReportBloc(ReportRepository())
                          ..add(FetchReports('${student.studentId}')),
                        child: Column(
                          children: [
                            // เพิ่มหัวข้อที่นี่
                            Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Text(
                                "Reports",
                                style: GoogleFonts.bebasNeue(
                                  fontSize: 24,
                                  color: Color.fromARGB(
                                      255, 96, 96, 96), // สีหัวข้อ
                                ),
                              ),
                            ),
                            Expanded(
                              child: BlocBuilder<ReportBloc, ReportState>(
                                builder: (context, state) {
                                  if (state is ReportLoading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is ReportLoaded) {
                                    return ListView.builder(
                                      itemCount: state.reports.length,
                                      itemBuilder: (context, index) {
                                        final report = state.reports[index];
                                        return Card(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 10.0),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${report.description}',  
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'Teacher : ${report.reporterName}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    // fontWeight: FontWeight.bold,
                                                    )),
                                                
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else if (state is ReportError) {
                                    return Center(
                                        child: Text('Dont have any reports'));
                                  }
                                  return Center(
                                      child: Text('No reports available'));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is StudentProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is StudentProfileNotFound) {
              return Center(child: Text('Student not found'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
