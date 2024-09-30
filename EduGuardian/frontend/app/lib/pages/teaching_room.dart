import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/subject_bloc.dart';
import '../repositories/subject_repository.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubjectBloc(SubjectRepository())..add(FetchSubjects()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ห้องเรียนที่สอน'),
          centerTitle: true,
        ),
        body: BlocBuilder<SubjectBloc, SubjectState>(
          builder: (context, state) {
            if (state is SubjectLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SubjectLoaded) {
              final subjects = state.subjects;
              return ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('${subject.subject}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('รหัสวิชา: ${subject.subjectId}'),
                          Text('ห้องที่สอน: ${subject.classroom}'),
                          SizedBox(height: 5),
                          Text('คำอธิบาย: ${subject.description}'),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        // Handle onTap for more actions or navigation
                      },
                    ),
                  );
                },
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
