import 'package:app/repositories/get_me_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'blocs/notification_bloc.dart';
import 'pages/login_page.dart';
import 'pages/notification_page.dart';
import 'repositories/auth_repository.dart';
import 'main_screen.dart';
import 'services/websocket_client.dart';

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
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(UserRepository()),
        ),
        BlocProvider<BottomNavigationBloc>(
          create: (context) => BottomNavigationBloc(),
        ),
        BlocProvider(
          create: (context) =>
              NotificationBloc(WebSocketClient(endpoint: 'ws')),
          child: NotificationPage(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
