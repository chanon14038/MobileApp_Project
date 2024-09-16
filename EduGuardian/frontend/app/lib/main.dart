import 'package:app/login/login_page.dart';
import 'package:flutter/material.dart';


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
      home: LoginPage(),
    );
  }
}
