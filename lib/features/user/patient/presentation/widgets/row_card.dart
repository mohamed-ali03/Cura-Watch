import 'package:cura_watch/core/constants.dart';
import 'package:flutter/material.dart';

class RowCard extends StatelessWidget {
  const RowCard({
    super.key,
    required this.icon,
    required this.vitalName,
    required this.onShowReport,
    this.phoneNumber,
  });

  final IconData icon;
  final String vitalName;
  final VoidCallback onShowReport;
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(mainColor)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // icon
          Expanded(flex: 1, child: Icon(icon)),
          //
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vitalName, style: subtitleTextStyle),
                if (phoneNumber != null) ...[
                  Text(phoneNumber!, style: bodyTextStyle),
                ] else ...[
                  Text('See Report', style: bodyTextStyle),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: onShowReport,
              icon: phoneNumber != null
                  ? Icon(Icons.phone)
                  : Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
