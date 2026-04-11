import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/user_on_boarding.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientProfile extends StatelessWidget {
  final Patient patient;
  const PatientProfile({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile', style: headerTextStyle),

              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'logout') {
                    getIt<CacheHelper>().clearData();
                    Navigator.pushNamed(context, '/');
                  } else if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<PatientBloc>(),
                          child: UserOnBoarding(patient: patient),
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.person_pin, size: 40, color: Color(mainColor)),
              SizedBox(width: 16),
              Text(
                patient.fullName,
                style: TextStyle(
                  fontSize: 40,
                  color: Color(mainColor),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Phone',
            fieldHint: 'Phone Number',
            fieldData: patient.phoneNumber,
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Email',
            fieldHint: 'Email',
            fieldData: patient.email,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildProfileField(
                  fieldTitel: 'Gender',
                  fieldHint: 'Gender',
                  fieldData: patient.gender,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProfileField(
                  fieldTitel: 'Height',
                  fieldHint: 'Height',
                  fieldData: patient.height.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProfileField(
                  fieldTitel: 'Weight',
                  fieldHint: 'Weight',
                  fieldData: patient.weight.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Date of Birth',
            fieldHint: 'Date of Birth',
            fieldData: patient.dateOfBirth.toLocal().toString().split(' ')[0],
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Blood Type',
            fieldHint: 'Blood Type',
            fieldData: patient.bloodType,
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Chronic Diseases',
            fieldHint: 'Chronic Diseases',
            fieldData: patient.chronicDiseases.join(', '),
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Allergies',
            fieldHint: 'Allergies',
            fieldData: patient.allergies.join(', '),
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Medications',
            fieldHint: 'Medications',
            fieldData: patient.medications.entries
                .map((entry) => '${entry.key}: ${entry.value}')
                .join('\n'),
            numberOfLines: patient.medications.keys.length,
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            fieldTitel: 'Emergency Contact',
            fieldHint: 'Emergency Contact',
            fieldData: patient.emergencyContact.isNotEmpty
                ? patient.emergencyContact
                      .map(
                        (contact) =>
                            '${contact.keys.first}: ${contact.values.first}',
                      )
                      .join('\n')
                : '',
            numberOfLines: patient.emergencyContact.length,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required String fieldTitel,
    required String fieldHint,
    required String fieldData,
    int? numberOfLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldTitel, style: subtitleTextStyle),
        MyTextField(
          hintText: fieldHint,
          controller: TextEditingController()..text = fieldData,
          isEditable: false,
          numberOfRows: numberOfLines ?? 1,
        ),
      ],
    );
  }
}
