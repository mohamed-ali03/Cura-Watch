import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/user/shared/model/doctor.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/add_button.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorContactWidget extends StatefulWidget {
  final TextEditingController doctorIdController;
  final ValueNotifier<List<Map<String, TextEditingController>>>
  emergencyContacts;

  const DoctorContactWidget({
    super.key,
    required this.doctorIdController,
    required this.emergencyContacts,
  });

  @override
  State<DoctorContactWidget> createState() => _DoctorContactWidgetState();
}

class _DoctorContactWidgetState extends State<DoctorContactWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<Doctor> _filteredDoctors = [];
  bool _isSearching = false;

  @override
  void initState() {
    context.read<PatientBloc>().add(GetDoctors());
    _searchFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay(BuildContext context) {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 200, // Adjust this value based on your layout
        left: 20,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(doctor.fullName[0].toUpperCase()),
                  ),
                  title: Text(doctor.fullName),
                  subtitle: Text('${doctor.email} • ${doctor.phoneNumber}'),
                  onTap: () {
                    widget.doctorIdController.text = doctor.id;
                    _searchController.text = doctor.fullName;
                    _removeOverlay();
                    _searchFocusNode.unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _filterDoctors(String query, List<Doctor> doctors) {
    _filteredDoctors = doctors.where((doctor) {
      return doctor.fullName.toLowerCase().contains(query.toLowerCase()) ||
          doctor.email.toLowerCase().contains(query.toLowerCase()) ||
          doctor.phoneNumber.contains(query);
    }).toList();

    if (_isSearching && _filteredDoctors.isNotEmpty) {
      _showOverlay(context);
    } else {
      _removeOverlay();
    }
  }

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── My Doctor ──
          // TODO : make it searchable
          SectionHeader(
            icon: Icons.supervised_user_circle,
            iconColor: const Color(mainColor),
            title: 'My Doctor',
          ),

          const SizedBox(height: 12),
          BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              List<Doctor> doctors = [];
              if (state is DoctorsLoaded) {
                doctors = state.doctors;
              }

              return TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Search doctor by name, email, or phone',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (query) {
                  _isSearching = query.isNotEmpty;
                  _filterDoctors(query, doctors);
                },
              );
            },
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
