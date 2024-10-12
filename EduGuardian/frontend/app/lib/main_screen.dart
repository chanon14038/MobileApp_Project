import 'package:app/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blocs/navigation_bloc.dart';
import 'pages/my_profile.dart';
import 'pages/teaching_room.dart';
import 'pages/students_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/eduguardian_logo2.png',  
              height: 60,         
            ),
            SizedBox(width: 10),   
            Expanded(              
              child: Text(
                'EDUGUARDIAN',
                textAlign: TextAlign.center,  
                style: GoogleFonts.bebasNeue(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 40, 120, 63),
                ),
              ),
            ),
            SizedBox(width: 65),   
          ],
        ),
        centerTitle: true,  
        elevation: 6,
        backgroundColor: Color.fromARGB(255, 129, 234, 155),
        shadowColor: Colors.blue.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),


      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          switch (state.selectedIndex) {
            case 0:
              return StudentPage();
            case 1:
              return RoomsPage();
            case 2:
              return NotificationPage();
            case 3:
              return UserProfilePage();
            default:
              return StudentPage();
          }
        },
      ),
      bottomNavigationBar:
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.all(12), // ยกขึ้นจากขอบล่าง
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 48, 108, 28),
              borderRadius: BorderRadius.circular(30), // ทำให้โค้งมน
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), // ทำให้โค้งมนที่แท็บบาร์
              child: BottomNavigationBar(
                currentIndex: state.selectedIndex,
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
                selectedItemColor: const Color.fromARGB(255, 40, 120, 63),
                iconSize: 40,
                type: BottomNavigationBarType.fixed,
              ),
            ),
          );
        },
      ),
    );
  }
}
