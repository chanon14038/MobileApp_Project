import 'package:app/main_screen.dart';

import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'EduGuadian',
      theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      home: MainScreen(),
    );
  }
}
