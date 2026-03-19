import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/report_page.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/vital_config.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/row_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientReport extends StatefulWidget {
  const PatientReport({super.key});

  @override
  State<PatientReport> createState() => _PatientReportState();
}

class _PatientReportState extends State<PatientReport> {
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
              return _buildRowCard(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRowCard(int index) {
    return RowCard(
      icon: VitalConfig.all[index].icon,
      vitalName: VitalConfig.all[index].name,
      onShowReport: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<PatientBloc>(),
            child: HealthReportPage(config: VitalConfig.all[index]),
          ),
        ),
      ),
    );
  }
}
