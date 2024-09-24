import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/myclassroom/students_page.dart';
import 'package:app/notification_page/notification_page.dart';
import 'package:app/myprofile_page/profile_page.dart';
import 'package:app/teaching_page/teaching_room.dart';

import 'blocs/navigation_bloc_app.dart';

class MainScreen extends StatelessWidget {
  static final List<Widget> _pages = <Widget>[
    StudentListPage(classroom: "1/2"),
    RoomsPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EduGuadian'),
          centerTitle: true,
          elevation: 6,
          backgroundColor: const Color.fromARGB(255, 188, 157, 241),
          shadowColor: Colors.blue.withOpacity(0.3),
        ),
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is PageLoaded) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _pages[state.selectedIndex],
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 188, 157, 241),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'My classroom',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Teach rooms',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: (state is PageLoaded) ? state.selectedIndex : 0,
              unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
              selectedItemColor: Color.fromARGB(255, 125, 0, 250),
              onTap: (index) {
                context.read<NavigationBloc>().add(PageSelected(index));
              },
              iconSize: 40,
            );
          },
        ),
      ),
    );
  }
}
