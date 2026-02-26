import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/user/patient/widgets/add_button.dart';
import 'package:cura_watch/features/user/patient/widgets/on_boarding_title.dart';
import 'package:cura_watch/features/user/patient/widgets/section_header.dart';
import 'package:flutter/material.dart';

class MedicationWidget extends StatefulWidget {
  final VoidCallback onBack;
  final ValueNotifier<List<TextEditingController>> medicationControllers;
  final ValueNotifier<List<TimeOfDay>> dosageTimes;
  const MedicationWidget({
    super.key,
    required this.onBack,
    required this.medicationControllers,
    required this.dosageTimes,
  });

  @override
  State<MedicationWidget> createState() => _MedicationWidgetState();
}

class _MedicationWidgetState extends State<MedicationWidget> {
  void _addMedication() {
    final newList = List<TextEditingController>.from(
      widget.medicationControllers.value,
    );
    newList.add(TextEditingController());
    widget.medicationControllers.value = newList;
  }

  void _addDosageTime() {
    final newList = List<TimeOfDay>.from(widget.dosageTimes.value);
    newList.add(const TimeOfDay(hour: 12, minute: 0));
    widget.dosageTimes.value = newList;
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.dosageTimes.value[index],
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1A2E4A),
            onPrimary: Colors.white,
            onSurface: Color(0xFF1A2E4A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final newList = List<TimeOfDay>.from(widget.dosageTimes.value);
      newList[index] = picked;
      widget.dosageTimes.value = newList;
    }
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  void dispose() {
    for (final c in widget.medicationControllers.value) {
      c.dispose();
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
          OnBoardingTitle(onBack: widget.onBack, title: 'Current Medications'),
          SizedBox(height: getIt<SizeConfig>().blockHight * 3),

          // ── Medication Name Section ──
          SectionHeader(
            icon: Icons.medication,
            iconColor: const Color(mainColor),
            title: 'Enter Medication Name',
          ),
          const SizedBox(height: 12),

          // Medication fields
          ValueListenableBuilder(
            valueListenable: widget.medicationControllers,
            builder: (context, controllers, child) {
              return Column(
                children: List.generate(
                  controllers.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MyTextField(
                      controller: controllers[i],
                      hintText: 'Enter your medication',
                    ),
                  ),
                ),
              );
            },
          ),

          // Add Medication button
          Align(
            alignment: Alignment.centerRight,
            child: AddButton(label: 'Add Medication', onTap: _addMedication),
          ),

          const SizedBox(height: 20),
          const Divider(color: Color(secondColor), thickness: 1),
          const SizedBox(height: 20),

          // ── Dosage Time Section ──
          SectionHeader(
            icon: Icons.schedule_outlined,
            iconColor: const Color(mainColor),
            title: 'Enter Medication Dosage Time',
          ),
          const SizedBox(height: 12),

          // Time pickers
          ValueListenableBuilder(
            valueListenable: widget.dosageTimes,
            builder: (context, times, child) {
              return Column(
                children: List.generate(
                  times.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _TimePickerField(
                      time: _formatTime(times[i]),
                      onTap: () => _pickTime(i),
                    ),
                  ),
                ),
              );
            },
          ),

          // Add Dosage Time button
          Align(
            alignment: Alignment.centerRight,
            child: AddButton(label: 'Add Dosage Time', onTap: _addDosageTime),
          ),
        ],
      ),
    );
  }
}

// ── Time Picker Field ────────────────────────────────────────────────────────

class _TimePickerField extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const _TimePickerField({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD0DCE8), width: 1.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2E4A),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF1A2E4A),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
