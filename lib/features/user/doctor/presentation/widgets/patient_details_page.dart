import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/features/user/doctor/presentation/widgets/vitals_history_page.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientDetailsPage extends StatefulWidget {
  final Patient patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(
      GetPatientByIdEvent(patientId: widget.patient.id),
    );
  }

  Future<void> _makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<DoctorBloc>(),
          child: VitalsHistoryPage(
            patientName: widget.patient.fullName,
            patientId: widget.patient.id,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        bool isLoading = state is GetPatientByIdLoading;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.patient.fullName, style: headerTextStyle),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => _navigateToHistory(context),
                tooltip: 'Vitals History',
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 16),
                    _buildHistoryButton(context),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Physical Information'),
                    _buildPhysicalInfo(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Contact Details'),
                    _buildContactInfo(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Health Record'),
                    _buildHealthRecord(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Emergency Contacts'),
                    _buildEmergencyContacts(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _navigateToHistory(context),
        icon: const Icon(Icons.show_chart),
        label: const Text('View Full Vitals History'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: headerTextStyle.copyWith(fontSize: 18, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.blue),
          ),
          const SizedBox(height: 15),
          Text(
            widget.patient.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${widget.patient.gender.toUpperCase()} • ${widget.patient.bloodType}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoTile(
            Icons.height,
            'Height',
            '${widget.patient.height} cm',
            Colors.orange,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildInfoTile(
            Icons.monitor_weight_outlined,
            'Weight',
            '${widget.patient.weight} kg',
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.blue),
            title: const Text('Phone'),
            subtitle: Text(widget.patient.phoneNumber),
            onTap: () => _makeCall(widget.patient.phoneNumber),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.redAccent),
            title: const Text('Email'),
            subtitle: Text(widget.patient.email),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRecord() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelValue(
              'Chronic Diseases',
              widget.patient.chronicDiseases.join(', '),
            ),
            const Divider(height: 24),
            _buildLabelValue('Allergies', widget.patient.allergies.join(', ')),
            const Divider(height: 24),
            const Text(
              'Medications',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (widget.patient.medications.isEmpty)
              const Text('No medications listed')
            else
              ...widget.patient.medications.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.medication_liquid,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text('${e.key}: ${e.value}')),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    if (widget.patient.emergencyContact.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No emergency contacts saved.'),
        ),
      );
    }
    return Column(
      children: widget.patient.emergencyContact.map((contact) {
        final name = contact['name'] ?? 'Unknown';
        final phone = contact['number']?.toString() ?? '';
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.emergency_share)),
            title: Text(name),
            subtitle: Text(phone),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () => _makeCall(phone),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? 'None' : value,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
