import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/row_card.dart';
import 'package:flutter/material.dart';

class PatientEmergancy extends StatelessWidget {
  const PatientEmergancy({super.key});

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
            itemCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return RowCard(
                icon: Icons.person,
                vitalName: 'Mohamed ali',
                phoneNumber: '012234324',
                onShowReport: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
