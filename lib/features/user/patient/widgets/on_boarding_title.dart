import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_text.dart';
import 'package:flutter/material.dart';

class OnBoardingTitle extends StatelessWidget {
  final VoidCallback? onBack;
  final String title;
  const OnBoardingTitle({super.key, this.onBack, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios,
            size: getIt<SizeConfig>().blockWidth * 5,
          ),
        ),
        SizedBox(width: getIt<SizeConfig>().blockWidth * 1),
        MyText(text: title),
      ],
    );
  }
}
