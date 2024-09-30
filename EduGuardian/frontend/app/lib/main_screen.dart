import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/navigation_bloc.dart';
import 'pages/teaching_room.dart';
import 'pages/students_page.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationBloc(), // สร้าง BottomNavigationBloc
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EduGuadian'),
          centerTitle: true,
          elevation: 6,
          backgroundColor: const Color.fromARGB(255, 188, 157, 241),
          shadowColor: Colors.blue.withOpacity(0.3),
        ),
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            // เปลี่ยนหน้าจอขึ้นอยู่กับ selectedIndex
            switch (state.selectedIndex) {
              case 0:
                return StudentPage();
              case 1:
                return RoomsPage();
              case 2:
                return RoomsPage();
              case 3:
                return RoomsPage();
              default:
                return StudentPage();
            }
          },
        ),
        bottomNavigationBar:
            BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.selectedIndex,
              backgroundColor: const Color.fromARGB(255, 188, 157, 241),
              onTap: (index) {
                context
                    .read<BottomNavigationBloc>()
                    .add(ChangeBottomNavigation(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
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
              unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              selectedItemColor: const Color.fromARGB(255, 125, 0, 250),
              iconSize: 40,
            );
          },
        ),
      ),
    );
  }
}
