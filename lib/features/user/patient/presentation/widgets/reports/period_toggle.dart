// ─── Period Toggle ─────────────────────────────────────────────────────────

import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/report_page.dart';
import 'package:flutter/material.dart';

class PeriodToggle extends StatelessWidget {
  final ValueNotifier<ReportPeriod> period;
  final ValueChanged<ReportPeriod> onChanged;

  const PeriodToggle({
    super.key,
    required this.period,
    required this.onChanged,
  });

  static const _selectedBg = Color(0xFF4A6FA5);
  static const _toggleBg = Color(0xFFF0F4F8);
  static const _labelGrey = Color(0xFF9AA3AF);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getIt<SizeConfig>().blockWidth * 4,
        vertical: getIt<SizeConfig>().blockHight * 1,
      ),
      child: Container(
        height: getIt<SizeConfig>().blockHight * 5,
        decoration: BoxDecoration(
          color: _toggleBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ValueListenableBuilder(
          valueListenable: period,
          builder: (context, current, child) => Row(
            children: [
              _btn(ReportPeriod.day, 'Daily', current),
              _btn(ReportPeriod.week, 'Week', current),
              _btn(ReportPeriod.month, 'Month', current),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(ReportPeriod p, String label, ReportPeriod current) {
    final selected = current == p;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(p),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: selected ? _selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _selectedBg.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : const [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : _labelGrey,
            ),
          ),
        ),
      ),
    );
  }
}
