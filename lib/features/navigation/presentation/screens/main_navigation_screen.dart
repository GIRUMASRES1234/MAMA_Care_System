import 'package:flutter/material.dart';

import '../../../appointment/presentation/screens/appointment_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../pregnancy/presentation/screens/pregnancy_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../education/presentation/screens/education_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    PregnancyScreen(),
    AppointmentScreen(),
    EducationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.black,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Progress",
            backgroundColor: Colors.red,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Appointment",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Education",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
