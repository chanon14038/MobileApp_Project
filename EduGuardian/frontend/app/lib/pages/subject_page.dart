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
      body: BlocProvider(
        create: (context) => SubjectBloc(SubjectRepository())..add(FetchSubjectById(subjectId)),
        child: BlocBuilder<SubjectBloc, SubjectState>(
          builder: (context, state) {
            if (state is SubjectLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SubjectLoadedById) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Subject ID: ${state.subject.id}'),
                    Text('Subject Name: ${state.subject.subject}'),
                  ],
                ),
              );
            } else if (state is SubjectError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
