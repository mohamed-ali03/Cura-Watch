import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
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
  Doctor? doctor;
  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(
      GetDoctor(id: widget.patient.assignedDoctorId),
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
          BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              if (state is DoctorLoaded) {
                doctor = state.doctor;
              }
              return RowCard(
                icon: Icons.person,
                vitalName: doctor?.fullName ?? 'Loading....',
                phoneNumber: doctor?.phoneNumber ?? 'Loading....',
                onShowReport: () => doctor != null
                    ? makePhoneCall(doctor?.phoneNumber ?? '')
                    : {},
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
