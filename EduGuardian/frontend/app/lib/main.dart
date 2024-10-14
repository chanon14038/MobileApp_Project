import 'package:app/repositories/get_me_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'blocs/notification_bloc.dart';
import 'pages/login_page.dart';
import 'repositories/auth_repository.dart';
import 'main_screen.dart';
import 'repositories/notification_repository.dart';
import 'repositories/student_repository.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationBloc(NotificationRepository()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            AuthRepository(),
            BlocProvider.of<NotificationBloc>(context),
          ),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(UserRepository()),
        ),
        BlocProvider<BottomNavigationBloc>(
          create: (context) => BottomNavigationBloc(),
        ),
        BlocProvider(
          create: (context) => StudentBloc(StudentRepository()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
