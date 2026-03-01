import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/row_card.dart';
import 'package:flutter/material.dart';

class PatientReport extends StatelessWidget {
  const PatientReport({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text('Report', style: headerTextStyle),

          // listview
          ListView.separated(
            itemCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return RowCard(
                icon: Icons.heart_broken,
                vitalName: 'Blood Pressure',
                onShowReport: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
