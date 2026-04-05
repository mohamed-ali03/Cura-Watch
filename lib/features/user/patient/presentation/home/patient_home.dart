import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_dashboard.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_emergancy.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_profile.dart';
import 'package:cura_watch/features/user/patient/presentation/home/patient_report.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientHome extends StatefulWidget {
  final Patient patient;
  const PatientHome({super.key, required this.patient});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int currentIndex = 0;

  List<Widget> get _pages => [
    PatientDashboard(),
    PatientReport(),
    PatientEmergancy(patient: widget.patient),
    PatientProfile(),
  ];

  void showWarningMSG() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Fall Detected'),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ],
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: getIt<SizeConfig>().blockWidth * 35,
            ),
            Text(
              'Do you need help, ${widget.patient.fullName.split(' ').first}?',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Column(
              children: [
                Icon(Icons.close, color: Colors.red),
                Text('Dismiss'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement call emergency
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Icon(Icons.phone, color: Colors.red),
                Text('Call Emergency'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (false) {
            showWarningMSG();
          }
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
