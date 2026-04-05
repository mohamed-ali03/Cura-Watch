import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/row_card.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientEmergancy extends StatelessWidget {
  final Patient patient;
  const PatientEmergancy({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text('Emergency Contacts', style: headerTextStyle),

          // listview
          ListView.separated(
            itemCount: patient.emergencyContact.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return RowCard(
                icon: Icons.person,
                vitalName: patient.emergencyContact[index].keys.first,
                phoneNumber: patient.emergencyContact[index].values.first,
                onShowReport: () =>
                    makePhoneCall(patient.emergencyContact[index].values.first),
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
