import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/vital_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  List<Map<String, dynamic>> healthData = [
    {
      'name': 'Blood Pressure',
      'icon': Icons.monitor_heart, // heart + ECG style
      'data': '120/80 mmHg',
    },
    {
      'name': 'Heart Rate',
      'icon': Icons.favorite, // classic heart icon
      'data': '72 bpm',
    },
    {
      'name': 'Oxygen',
      'icon': Icons.air, // represents breathing / oxygen
      'data': '98%',
    },
    {
      'name': 'Steps',
      'icon': Icons.directions_walk, // walking icon
      'data': '5000',
    },
    {
      'name': 'Temperature',
      'icon': Icons.thermostat, // thermometer icon
      'data': '98.6°F',
    },
    {
      'name': 'Glucose',
      'icon': Icons.bloodtype, // blood drop icon
      'data': '100 mg/dL',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text('Dashboard', style: headerTextStyle),
          // logo
          Image.asset('assets/logo/curawatch.jpeg'),
          SizedBox(height: getIt<SizeConfig>().blockHight * 3),

          // welcome sentence
          Text('Good Day, Mohamed', style: headerTextStyle),
          Text('Track your vitals & stay healthy', style: bodyTextStyle),

          // grid view
          BlocBuilder<PatientBloc, PatientState>(
            buildWhen: (previous, current) => current is VitalInfoLoaded,
            builder: (context, state) {
              if (state is VitalInfoLoaded) {
                healthData[1]['data'] = state.vitalInfo.pressure;
                healthData[2]['data'] = state.vitalInfo.heartRate;
                healthData[3]['data'] = state.vitalInfo.oxygen;
                healthData[4]['data'] = state.vitalInfo.steps;
                healthData[5]['data'] = state.vitalInfo.temperature;
                healthData[6]['data'] = state.vitalInfo.glucose;
              }

              return GridView.builder(
                itemCount: 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: getIt<SizeConfig>().blockHight * 3,
                  mainAxisSpacing: getIt<SizeConfig>().blockHight * 3,
                  childAspectRatio: 4 / 3,
                ),
                itemBuilder: (context, index) {
                  return VitalBox(
                    vitalName: healthData[index]['name']!,
                    vitalIcon: healthData[index]['icon']!,
                    vitalData: healthData[index]['data']!,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
