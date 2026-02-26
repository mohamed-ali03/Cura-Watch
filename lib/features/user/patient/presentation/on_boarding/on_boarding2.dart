import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/user/patient/widgets/on_boarding_title.dart';
import 'package:cura_watch/features/user/patient/widgets/section_header.dart';
import 'package:flutter/material.dart';

class HealthInfoWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final ValueNotifier<String> selectedBloodType;
  final TextEditingController allergiesController;
  final ValueNotifier<List<String>> selectedDiseases;
  const HealthInfoWidget({
    super.key,
    this.onBack,
    required this.selectedBloodType,
    required this.allergiesController,
    required this.selectedDiseases,
  });

  @override
  State<HealthInfoWidget> createState() => _HealthInfoWidgetState();
}

class _HealthInfoWidgetState extends State<HealthInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // title
          OnBoardingTitle(onBack: widget.onBack, title: 'Medical Background'),
          SizedBox(height: getIt<SizeConfig>().blockHight * 3),

          // ── Blood Type ──
          SectionHeader(
            icon: Icons.water_drop,
            iconColor: const Color(mainColor),
            title: 'Blood Type',
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder(
            valueListenable: widget.selectedBloodType,
            builder: (context, value, child) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: bloodTypes
                    .map(
                      (type) => _BloodTypeButton(
                        label: type,
                        isSelected: widget.selectedBloodType.value == type,
                        onTap: () => widget.selectedBloodType.value = type,
                      ),
                    )
                    .toList(),
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(color: Color(secondColor), thickness: 1),
          const SizedBox(height: 20),

          // ── Chronic Diseases ──
          SectionHeader(
            icon: Icons.monitor_heart,
            iconColor: const Color(mainColor),
            title: 'Chronic Diseases',
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder(
            valueListenable: widget.selectedDiseases,
            builder: (context, value, child) {
              return Column(
                children: [
                  ...diseases.keys.map(
                    (disease) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          final updated = List<String>.from(
                            widget.selectedDiseases.value,
                          );
                          if (updated.contains(disease)) {
                            updated.remove(disease);
                          } else {
                            updated.add(disease);
                          }
                          widget.selectedDiseases.value = updated;
                        },
                        child: Row(
                          children: [
                            _Checkbox(checked: value.contains(disease)),
                            const SizedBox(width: 12),
                            Text(
                              disease,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2C3E55),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(color: Color(secondColor), thickness: 1),
          const SizedBox(height: 20),

          // ── Allergies ──
          SectionHeader(
            icon: Icons.back_hand,
            iconColor: const Color(mainColor),
            title: 'Allergies',
          ),
          const SizedBox(height: 14),
          MyTextField(
            hintText:
                'List any food, drug, or environmental allergies.\n\nType \'None\' if you don\'t have any',
            controller: widget.allergiesController,
            numberOfRows: 5,
          ),
        ],
      ),
    );
  }
}

// ── Blood Type Button ───────────────────────────────────────────────────────

class _BloodTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BloodTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(mainColor) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.white : const Color(secondColor),
            width: 2,
          ),
        ),
        child: Center(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: label.length > 2 ? 8 : 10,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : const Color(mainColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Custom Checkbox ─────────────────────────────────────────────────────────

class _Checkbox extends StatelessWidget {
  final bool checked;

  const _Checkbox({required this.checked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
        border: Border.all(
          color: checked ? const Color(secondColor) : const Color(mainColor),
          width: 2,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, size: 16, color: Color(0xFF3B8DE0))
          : null,
    );
  }
}
