import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/row_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientEmergancy extends StatelessWidget {
  const PatientEmergancy({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoaded) {
          final patient = state.patient;
          final emergencyContact = patient.emergencyContact;
          final doctor = patient.doctor;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emergency Contacts Section
                Text('Emergency Contacts', style: headerTextStyle),

                if (emergencyContact.isNotEmpty &&
                    emergencyContact['name'] != null &&
                    emergencyContact['name'].toString().isNotEmpty &&
                    emergencyContact['number'] != null &&
                    emergencyContact['number'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: RowCard(
                      icon: Icons.person,
                      vitalName: emergencyContact['name'].toString(),
                      phoneNumber: emergencyContact['number'].toString(),
                      onShowReport: () {},
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'No emergency contact information available',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),

                const SizedBox(height: 32),

                // Doctor Section
                Text('Assigned Doctor', style: headerTextStyle),

                if (doctor != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: RowCard(
                      icon: Icons.local_hospital,
                      vitalName: doctor.fullName,
                      phoneNumber: doctor.phoneNumber,
                      onShowReport: () {},
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'No doctor information available',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        }

        // Loading state
        if (state is PatientLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state or initial state
        return const Center(
          child: Text(
            'Unable to load emergency information',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      },
    );
  }
}
