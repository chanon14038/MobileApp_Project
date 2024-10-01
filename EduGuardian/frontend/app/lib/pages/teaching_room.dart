import 'dart:math'; // เพิ่ม library สำหรับสุ่ม
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/subject_bloc.dart';
import '../repositories/subject_repository.dart';

class RoomsPage extends StatelessWidget {
  // สร้างลิสต์ของสีที่ต้องการสุ่ม
  final List<Color> cardColors = [
    Colors.lightBlue[50]!,
    Colors.lightGreen[50]!,
    Colors.amber[50]!,
    Colors.pink[50]!,
    Colors.purple[50]!,
    Colors.orange[50]!,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubjectBloc(SubjectRepository())..add(FetchSubjects()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My subjects',
                style: GoogleFonts.bebasNeue(
                  fontSize: 30,
                  color: Color.fromARGB(255, 96, 96, 96), 
                ),
              ),
          centerTitle: true,
        ),
        body: BlocBuilder<SubjectBloc, SubjectState>(
          builder: (context, state) {
            if (state is SubjectLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SubjectLoaded) {
              final subjects = state.subjects;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0, vertical: 2.0),
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
                    
                    // สุ่มสีจากลิสต์ของสี
                    final random = Random();
                    final cardColor = cardColors[random.nextInt(cardColors.length)];

                    return InkWell(
                      onTap: () {
                        // Handle onTap for more actions or navigation
                        print('Tapped on ${subject.subject}');
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: cardColor, // ใช้สีสุ่มเป็นพื้นหลังการ์ด
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${subject.subject}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'รหัสวิชา: ${subject.subjectId}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'ห้องที่สอน: ${subject.classroom}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'คำอธิบาย:',
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
    );
  }
}
