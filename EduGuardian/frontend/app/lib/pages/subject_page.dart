import 'package:app/pages/reportdialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/subject_bloc.dart';
import '../repositories/subject_repository.dart';

class SubjectByIDPage extends StatelessWidget {
  final String subjectId;

  const SubjectByIDPage({Key? key, required this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ปุ่มย้อนกลับ
          },
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SubjectBloc(SubjectRepository())
              ..add(FetchSubjectById(subjectId)), // โหลดข้อมูลวิชา
          ),
          BlocProvider(
            create: (context) => StudentsBloc(SubjectRepository())
              ..add(FetchStudentsBySubjectId(subjectId)), // โหลดรายชื่อนักเรียนในวิชา
          ),
        ],
        child: SingleChildScrollView( // ใช้ SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0), // เว้นระยะห่าง
                Text(
                  'Subject Information',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 20, // ปรับขนาดฟอนต์ให้เหมาะสม
                      ),
                  textAlign: TextAlign.center, // จัดกึ่งกลางข้อความ
                ),
                const SizedBox(height: 10.0),
                Center( // Center widget เพื่อจัดกลาง Card
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // กำหนดความกว้างของ Card ให้เกือบเต็มจอ
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BlocBuilder<SubjectBloc, SubjectState>(
                          builder: (context, state) {
                            if (state is SubjectLoading) {
                              return const Center(child: CircularProgressIndicator()); // กำลังโหลดข้อมูล
                            } else if (state is SubjectLoadedById) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center, // จัดข้อความให้กึ่งกลาง
                                children: [
                                  Text(
                                    'Subject ID: ${state.subject.id}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center, // จัดกึ่งกลางข้อความ
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Subject Name: ${state.subject.subject}',
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center, // จัดกึ่งกลางข้อความ
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Additional Info: ${state.subject.description ?? "No additional info"}',
                                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.center, // จัดกึ่งกลางข้อความ
                                  ),
                                ],
                              );
                            } else if (state is SubjectError) {
                              return Center(child: Text(state.message)); // แสดงข้อผิดพลาด
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0), // เว้นระยะห่าง
                Text(
                  'Students List',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center, // จัดกึ่งกลางข้อความ
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9, // กำหนดความกว้างของ Container ให้เกือบเต็มจอ
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: BlocBuilder<StudentsBloc, SubjectState>(
                    builder: (context, state) {
                      if (state is SubjectLoading) {
                        return const Center(child: CircularProgressIndicator()); // กำลังโหลดรายชื่อนักเรียน
                      } else if (state is StudentsLoadedBySubjectId) {
                        return ListView.builder(
                          shrinkWrap: true, // ทำให้ ListView มีขนาดพอดีกับเนื้อหา
                          physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อน
                          itemCount: state.students.length,
                          itemBuilder: (context, index) {
                            final student = state.students[index];
                            return ListTile(
                              title: Text('${student.firstName}'),
                              subtitle: Text('ID: ${student.studentId}'),
                              onTap: () {
                                // Show the popup dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => ReportDialog(student: student), // Pass the selected student if needed
                                );
                              },
                            );
                          },
                        );
                      } else if (state is SubjectError) {
                        return Center(child: Text(state.message)); // แสดงข้อผิดพลาด
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
