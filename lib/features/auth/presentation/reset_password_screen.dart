import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final Function(AuthRouteType) onTap;

  const ResetPasswordScreen({super.key, required this.onTap});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
                      widget.onTap(AuthRouteType.verification);
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                  ),
                  SizedBox(width: getIt<SizeConfig>().blockWidth * 2),
                  Text(
                    'Create New Password',
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
                'Set your new password',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.05,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B4464),
                ),
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              MyTextField(
                hintText: 'Enter sent password',
                controller: passwordController,
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              MyTextField(
                hintText: 'Confirm password',
                controller: confirmPasswordController,
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 3),
              MyButton(
                text: 'Reset Password',
                onTap: () => widget.onTap(AuthRouteType.signIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
