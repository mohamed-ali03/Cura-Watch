import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/row_card.dart';
import 'package:cura_watch/features/user/shared/model/doctor.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientEmergancy extends StatefulWidget {
  final Patient patient;
  const PatientEmergancy({super.key, required this.patient});

  @override
  State<PatientEmergancy> createState() => _PatientEmergancyState();
}

class _PatientEmergancyState extends State<PatientEmergancy> {
  Doctor doctor = Doctor(
    id: 'Loading.....',
    fullName: 'Loading.....',
    email: 'Loading.....',
    phoneNumber: 'Loading.....',
    gender: 'Loading.....',
    availableHours: {},
  );
  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(
      GetDoctorEvent(id: widget.patient.assignedDoctorId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Doctor', style: headerTextStyle),
          const SizedBox(height: 20),
          BlocBuilder<DoctorBloc, DoctorState>(
            buildWhen: (previous, current) =>
                current is GetDoctorLoaded && previous is GetDoctorLoading,
            builder: (context, state) {
              if (state is GetDoctorLoaded) {
                doctor = state.doctor;
              }
              return RowCard(
                icon: Icons.person,
                vitalName: doctor.fullName,
                phoneNumber: doctor.phoneNumber,
                onShowReport: () => makePhoneCall(doctor.phoneNumber),
              );
            },
          ),
          const SizedBox(height: 20),

          // title
          Text('Emergency Contacts', style: headerTextStyle),

          // listview
          ListView.separated(
            itemCount: widget.patient.emergencyContact.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return RowCard(
                icon: Icons.person,
                vitalName: widget.patient.emergencyContact[index].keys.first,
                phoneNumber:
                    widget.patient.emergencyContact[index].values.first,
                onShowReport: () => makePhoneCall(
                  widget.patient.emergencyContact[index].values.first,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Call this function
void makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);
  await launchUrl(url);
}
