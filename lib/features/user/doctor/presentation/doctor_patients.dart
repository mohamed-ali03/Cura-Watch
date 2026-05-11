import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/features/user/doctor/presentation/widgets/patient_details_page.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/report_page.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/vital_config.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/row_card.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorPatients extends StatefulWidget {
  const DoctorPatients({super.key});

  @override
  State<DoctorPatients> createState() => _DoctorPatientsState();
}

class _DoctorPatientsState extends State<DoctorPatients> {
  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(GetAssignedPatient());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Patients', style: headerTextStyle),
        BlocBuilder<DoctorBloc, DoctorState>(
          builder: (context, state) {
            if (state is GetAssignedPatientLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetAssignedPatientLoaded) {
              patients = state.patients;
            }

            if (state is DoctorError) {
              return Center(child: Text(state.message));
            }
            return Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: getIt<SizeConfig>().screenWidth / 2 - 32,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person_pin, size: 48),
                        SizedBox(height: 10),
                        Text(patients[index].fullName),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  showReportDialog(patients[index]),
                              icon: Icon(Icons.bar_chart_outlined),
                            ),
                            IconButton(
                              onPressed: () =>
                                  showPatientProfile(patients[index]),
                              icon: Icon(Icons.person),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
  // show dialog of reports

  Widget _buildRowCard(int index, Patient patient) {
    return RowCard(
      icon: VitalConfig.all[index].icon,
      vitalName: VitalConfig.all[index].name,
      onShowReport: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<DoctorBloc>(),
            child: HealthReportPage(
              config: VitalConfig.all[index],
              patient: patient,
            ),
          ),
        ),
      ),
    );
  }

  void showReportDialog(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(patient.fullName, style: headerTextStyle),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              6,
              (index) => Column(
                children: [_buildRowCard(index, patient), SizedBox(height: 10)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showPatientProfile(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<DoctorBloc>(),
          child: PatientDetailsPage(patient: patient),
        ),
      ),
    );
  }

  // show dialog of patient details

  // Widget _buildProfileField({
  //   required String fieldTitel,
  //   required String fieldHint,
  //   required String fieldData,
  //   int? numberOfLines,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(fieldTitel, style: subtitleTextStyle),
  //       MyTextField(
  //         hintText: fieldHint,
  //         controller: TextEditingController()..text = fieldData,
  //         isEditable: false,
  //         numberOfRows: numberOfLines ?? 1,
  //       ),
  //     ],
  //   );
  // }

  // void showPatientProfile(Patient patient) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(patient.fullName, style: headerTextStyle),
  //           IconButton(
  //             onPressed: () => Navigator.pop(context),
  //             icon: Icon(Icons.close),
  //           ),
  //         ],
  //       ),
  //       content: SingleChildScrollView(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             _buildProfileField(
  //               fieldTitel: 'Phone',
  //               fieldHint: 'Phone Number',
  //               fieldData: patient.phoneNumber,
  //             ),
  //             const SizedBox(height: 16),
  //             _buildProfileField(
  //               fieldTitel: 'Email',
  //               fieldHint: 'Email',
  //               fieldData: patient.email,
  //             ),
  //             const SizedBox(height: 16),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: _buildProfileField(
  //                     fieldTitel: 'Gender',
  //                     fieldHint: 'Gender',
  //                     fieldData: patient.gender,
  //                   ),
  //                 ),
  //                 // const SizedBox(width: 16),
  //                 // Expanded(
  //                 //   child: _buildProfileField(
  //                 //     fieldTitel: 'Height',
  //                 //     fieldHint: 'Height',
  //                 //     fieldData: patient.height.toString(),
  //                 //   ),
  //                 // ),
  //                 // const SizedBox(width: 16),
  //                 // Expanded(
  //                 //   child: _buildProfileField(
  //                 //     fieldTitel: 'Weight',
  //                 //     fieldHint: 'Weight',
  //                 //     fieldData: patient.weight.toString(),
  //                 //   ),
  //                 // ),
  //               ],
  //             ),
  //             const SizedBox(height: 16),
  //             // _buildProfileField(
  //             //   fieldTitel: 'Date of Birth',
  //             //   fieldHint: 'Date of Birth',
  //             //   fieldData: patient.dateOfBirth.toLocal().toString().split(
  //             //     ' ',
  //             //   )[0],
  //             // ),
  //             // const SizedBox(height: 16),
  //             // _buildProfileField(
  //             //   fieldTitel: 'Blood Type',
  //             //   fieldHint: 'Blood Type',
  //             //   fieldData: patient.bloodType,
  //             // ),
  //             const SizedBox(height: 16),
  //             _buildProfileField(
  //               fieldTitel: 'Chronic Diseases',
  //               fieldHint: 'Chronic Diseases',
  //               fieldData: patient.chronicDiseases.join(', '),
  //             ),
  //             const SizedBox(height: 16),
  //             _buildProfileField(
  //               fieldTitel: 'Allergies',
  //               fieldHint: 'Allergies',
  //               fieldData: patient.allergies.join(', '),
  //             ),
  //             const SizedBox(height: 16),
  //             _buildProfileField(
  //               fieldTitel: 'Medications',
  //               fieldHint: 'Medications',
  //               fieldData: patient.medications.entries
  //                   .map((entry) => '${entry.key}: ${entry.value}')
  //                   .join('\n'),
  //               numberOfLines: patient.medications.keys.length + 1,
  //             ),
  //             const SizedBox(height: 16),
  //             // _buildProfileField(
  //             //   fieldTitel: 'Emergency Contact',
  //             //   fieldHint: 'Emergency Contact',
  //             //   fieldData: patient.emergencyContact.isNotEmpty
  //             //       ? patient.emergencyContact
  //             //             .map(
  //             //               (contact) =>
  //             //                   '${contact.keys.first}: ${contact.values.first}',
  //             //             )
  //             //             .join('\n')
  //             //       : '',
  //             //   numberOfLines: patient.emergencyContact.length + 1,
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
