import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(getIt<SizeConfig>().blockWidth * 4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo/curawatch.jpeg'),
              SizedBox(height: getIt<SizeConfig>().blockHight * 10),
              Image.asset('assets/images/onBoarding.jpeg'),
              SizedBox(height: getIt<SizeConfig>().blockHight * 3),
              Text(
                'Smart monitoring\nfor a healthier life',
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 0.07,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2B4464),
                ),
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 3),
              MyButton(
                text: 'Get Started',
                onTap: () {
                  getIt<CacheHelper>().saveData(
                    key: 'isNotFirstTime',
                    value: true,
                  );
                  Navigator.pushNamed(context, '/auth');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
