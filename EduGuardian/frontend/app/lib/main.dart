import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'get_me.dart';
import 'login.dart';
import 'blocs/login_bloc.dart';
import 'repositories/auth_repository.dart';
import 'pages/myclassroom/students_page.dart';
import 'main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/main': (context) => MainScreen(),
        },
      ),
    );
  }
}
