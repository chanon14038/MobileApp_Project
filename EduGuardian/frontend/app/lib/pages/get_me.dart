import 'package:flutter/material.dart';
import '../repositories/get_me_repository.dart';

class GetMePage extends StatelessWidget {
  final GetMeRepository _getMeRepository = GetMeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Info')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getMeRepository.getMe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data;
            return Column(
              children: [
                Text('Username: ${user!['username']}'),
                Text('Email: ${user['email']}'),
              ],
            );
          }
        },
      ),
    );
  }
}
