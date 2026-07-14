import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  final Function(AuthRouteType) onTap;

  const VerificationScreen({super.key, required this.onTap});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getIt<SizeConfig>().blockWidth * 5,
          vertical: getIt<SizeConfig>().blockWidth * 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.onTap(AuthRouteType.forgetPassword);
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                  ),
                  SizedBox(width: getIt<SizeConfig>().blockWidth * 2),
                  Text(
                    'Verification Code',
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 0.05,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B4464),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              Image.asset('assets/logo/curawatch.jpeg'),
              SizedBox(height: getIt<SizeConfig>().blockHight * 5),
              Text(
                'Please enter the 4-digit code sent to your email address',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.05,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B4464),
                ),
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              MyTextField(
                hintText: 'Enter sent code',
                controller: codeController,
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              RichText(
                text: TextSpan(
                  text: 'Didn\'t receive the code? ',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2B4464),
                  ),
                  children: [
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.05,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B4464),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              MyButton(
                text: 'Next',
                onTap: () => widget.onTap(AuthRouteType.resetPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
