import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/user/patient/widgets/add_button.dart';
import 'package:cura_watch/features/user/patient/widgets/on_boarding_title.dart';
import 'package:cura_watch/features/user/patient/widgets/section_header.dart';
import 'package:flutter/material.dart';

class DoctorContactWidget extends StatefulWidget {
  final VoidCallback onBack;
  final TextEditingController doctorIdController;
  final ValueNotifier<List<Map<String, TextEditingController>>>
  emergencyContacts;

  const DoctorContactWidget({
    super.key,
    required this.onBack,
    required this.doctorIdController,
    required this.emergencyContacts,
  });

  @override
  State<DoctorContactWidget> createState() => _DoctorContactWidgetState();
}

class _DoctorContactWidgetState extends State<DoctorContactWidget> {
  void _addContact() {
    var newList = List<Map<String, TextEditingController>>.from(
      widget.emergencyContacts.value,
    );
    newList.add({
      'name': TextEditingController(),
      'phone': TextEditingController(),
    });
    widget.emergencyContacts.value = newList;
  }

  @override
  void dispose() {
    widget.doctorIdController.dispose();
    for (final contact in widget.emergencyContacts.value) {
      contact['name']!.dispose();
      contact['phone']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          OnBoardingTitle(onBack: widget.onBack, title: 'Emergeny Contacts'),
          SizedBox(height: getIt<SizeConfig>().blockHight * 3),

          // ── My Doctor ──
          // TODO : make it searchable
          SectionHeader(
            icon: Icons.supervised_user_circle,
            iconColor: const Color(mainColor),
            title: 'My Doctor',
          ),

          const SizedBox(height: 12),
          MyTextField(
            controller: widget.doctorIdController,
            hintText: 'Enter your doctor ID',
            isNumber: true,
          ),

          const SizedBox(height: 20),
          const Divider(color: Color(0xFFE5EDF5), thickness: 1),
          const SizedBox(height: 20),

          // ── Emergency Contact ──
          SectionHeader(
            icon: Icons.phone_outlined,
            iconColor: const Color(mainColor),
            title: 'Add Emergency Contact',
          ),
          const SizedBox(height: 16),

          // Contact cards
          ValueListenableBuilder(
            valueListenable: widget.emergencyContacts,
            builder: (context, contacts, child) {
              return Column(
                children: List.generate(
                  contacts.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ContactCard(
                      index: i + 1,
                      nameController: contacts[i]['name']!,
                      phoneController: contacts[i]['phone']!,
                    ),
                  ),
                ),
              );
            },
          ),

          Align(
            alignment: Alignment.centerRight,
            child: AddButton(label: 'Add Contact', onTap: _addContact),
          ),
        ],
      ),
    );
  }
}

// ── Contact Card ─────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final int index;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const _ContactCard({
    required this.index,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact $index',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A2E4A),
          ),
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: nameController,
          hintText: 'Enter contact $index name',
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: phoneController,
          hintText: 'Enter contact $index number',
          isNumber: true,
        ),
      ],
    );
  }
}
