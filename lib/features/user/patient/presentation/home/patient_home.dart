import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_dashboard.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_emergancy.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_profile.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    PatientDashboard(),
    PatientReport(),
    PatientEmergancy(),
    PatientProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Stop polling when leaving dashboard (index 0)
          if (currentIndex == 0 && index != 0) {
            context.read<PatientBloc>().stopPollingVitalInfo();
          }

          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home, color: Colors.blue),
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.bar_chart, color: Colors.blue),
            icon: Icon(Icons.bar_chart, color: Colors.black),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.call, color: Colors.blue),
            icon: Icon(Icons.call, color: Colors.black),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person, color: Colors.blue),
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: getIt<SizeConfig>().blockHight * 4,
          bottom: getIt<SizeConfig>().blockHight * 2,
          left: getIt<SizeConfig>().blockWidth * 4,
          right: getIt<SizeConfig>().blockWidth * 4,
        ),
        child: _pages[currentIndex],
      ),
    );
  }
}
