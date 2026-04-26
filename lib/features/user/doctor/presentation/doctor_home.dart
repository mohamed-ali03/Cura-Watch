import 'package:cura_watch/features/user/doctor/presentation/doctor_patients.dart';
import 'package:cura_watch/features/user/doctor/presentation/doctor_profile.dart';
import 'package:flutter/material.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int currentIndex = 0;

  List<Widget> pages = [DoctorPatients(), DoctorProfile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset('assets/logo/curawatch.jpeg'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: pages[currentIndex],
            ),
          ),
        ],
      ),
    );
  }
}
