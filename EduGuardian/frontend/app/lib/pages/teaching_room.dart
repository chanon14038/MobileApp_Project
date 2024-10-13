import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/subject_bloc.dart';
import '../repositories/subject_repository.dart';
import 'subject_page.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubjectBloc(SubjectRepository())..add(FetchSubjects()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Teaching room',
            style: GoogleFonts.bebasNeue(
              fontSize: 27,
              color: Color.fromARGB(255, 96, 96, 96),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(), // เพิ่ม padding รอบกรอบ
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(166, 216, 244, 232), // พื้นหลังขาวสำหรับกรอบ
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
              child: BlocBuilder<SubjectBloc, SubjectState>(
                builder: (context, state) {
                  if (state is SubjectLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SubjectLoaded) {
                    final subjects = state.subjects;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // ตั้งให้แสดง 2 การ์ดในหนึ่งแถว
                          crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                          mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
                          childAspectRatio: 1, // ปรับสัดส่วนของการ์ด
                        ),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjects[index];

                          return InkWell(
                            onTap: () {
                              // นำทางไปยังหน้า SubjectByIDPage พร้อมส่ง subjectId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubjectByIDPage(
                                    subjectId: '${subject.id}', // ส่งค่า subjectId ไปยังหน้า SubjectByIDPage
                                  ),
                                ),
                              );
                              print('Tapped on ${subject.subject}');
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.white, // เปลี่ยนเป็นสีขาวเสมอ
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Classroom: ${subject.classroom}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    
                                    Text(
                                      'Subject: ${subject.subject}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Subject ID: ${subject.subjectId}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Description:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${subject.description}',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is SubjectError) {
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
