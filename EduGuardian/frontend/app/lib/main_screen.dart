import 'package:app/myclassroom_page/myclassroom_page.dart';
import 'package:app/notification_page/notification_page.dart';
import 'package:app/myprofile_page/profile_page.dart';
import 'package:app/teaching_page/teaching_room.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    MyClassroomPage(),
    RoomsPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduGuadian'),
        centerTitle: true,
        elevation: 6, 
        backgroundColor: const Color.fromARGB(255, 188, 157, 241),// Set elevation for shadow
        shadowColor: Colors.blue.withOpacity(0.3), // Set shadow color
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 188, 157, 241),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
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
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: Color.fromARGB(255, 125, 0, 250),
        onTap: _onItemTapped,
        iconSize: 40,
      ),
    );
  }
}