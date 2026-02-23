import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  final Function() onTap;
  const SignUpScreen({super.key, required this.onTap});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  ValueNotifier<bool> isDoctor = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthBlocSuccess || state is AuthBlocError) {
          if (state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(getIt<SizeConfig>().blockWidth * 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/logo/curawatch.jpeg'),
                SizedBox(height: getIt<SizeConfig>().blockHight * 5),
                Text(
                  'Register With Us!',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B4464),
                  ),
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 3),
                MyTextField(
                  hintText: 'Enter your Full Name',
                  controller: fullNameController,
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                MyTextField(
                  hintText: 'Enter your Email',
                  controller: emailController,
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                MyTextField(
                  hintText: 'Enter your Phone Number',
                  controller: phoneNumberController,
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                MyTextField(
                  hintText: 'Enter your Password',
                  controller: passwordController,
                  isObscure: true,
                  eye: true,
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                MyTextField(
                  hintText: 'Enter your Confirm Password',
                  controller: confirmPasswordController,
                  isObscure: true,
                  eye: true,
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                ValueListenableBuilder(
                  valueListenable: isDoctor,
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MyButton(
                          text: 'Doctor',
                          colored: value,
                          onTap: () => isDoctor.value = true,
                        ),
                      ),
                      SizedBox(width: getIt<SizeConfig>().blockWidth * 2),
                      Expanded(
                        child: MyButton(
                          text: 'Patient',
                          colored: !value,
                          onTap: () => isDoctor.value = false,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                _buildButton(),
                SizedBox(height: getIt<SizeConfig>().blockHight * 1),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Color(0xFF2B4464)),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return BlocBuilder<AuthBlocBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthBlocLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return MyButton(
            text: 'Sign Up',
            onTap: () => context.read<AuthBlocBloc>().add(
              AuthSignUp(
                fullName: fullNameController.text,
                email: emailController.text,
                phoneNumber: phoneNumberController.text,
                password: passwordController.text,
                confirmedPassword: confirmPasswordController.text,
                role: isDoctor.value ? 'Doctor' : 'Patient',
              ),
            ),
          );
        }
      },
    );
  }
}
