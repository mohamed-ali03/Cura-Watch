import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:flutter/material.dart';

class VitalBox extends StatelessWidget {
  final void Function()? onTap;
  final String vitalName;
  final IconData vitalIcon;
  final String vitalData;

  const VitalBox({
    super.key,
    this.onTap,
    required this.vitalName,
    required this.vitalIcon,
    required this.vitalData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(getIt<SizeConfig>().blockHight * 2),
        decoration: BoxDecoration(
          border: Border.all(color: Color(mainColor)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(vitalName, style: subtitleTextStyle),
                Icon(vitalIcon, color: Color(mainColor)),
              ],
            ),
            SizedBox(height: getIt<SizeConfig>().blockHight * 2),
            Text(vitalData, style: bodyTextStyle),
          ],
        ),
      ),
    );
  }
}
