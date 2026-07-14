import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final Function(AuthRouteType) onTap;

  const ForgetPasswordScreen({super.key, required this.onTap});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

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
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  onPressed: () {
                    widget.onTap(AuthRouteType.signIn);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              Image.asset('assets/logo/curawatch.jpeg'),
              SizedBox(height: getIt<SizeConfig>().blockHight * 5),
              Text(
                'Forget Password',
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 0.05,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2B4464),
                ),
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              Text(
                'Enter your email address and we\'ll send you a code to reset your password',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.05,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B4464),
                ),
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              MyTextField(
                hintText: 'Enter your email',
                controller: emailController,
              ),
              SizedBox(height: getIt<SizeConfig>().blockHight * 2),
              MyButton(
                text: 'Send Code',
                onTap: () => widget.onTap(AuthRouteType.verification),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
