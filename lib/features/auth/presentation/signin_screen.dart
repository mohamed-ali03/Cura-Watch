import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:cura_watch/features/auth/presentation/forget_password_screen.dart';
import 'package:cura_watch/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  final Function() onTap;
  const SignInScreen({super.key, required this.onTap});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthBlocSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        } else if (state is AuthBlocError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
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
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0.05,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B4464),
                  ),
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                MyTextField(
                  hintText: 'Enter your email',
                  controller: emailController,
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 2),
                MyTextField(
                  hintText: 'Enter your password',
                  controller: passwordController,
                  isObscure: true,
                  eye: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ),
                SizedBox(height: getIt<SizeConfig>().blockHight * 1.5),
                _buildButton(),
                SizedBox(height: getIt<SizeConfig>().blockHight * 1),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Color(0xFF2B4464)),
                    children: [
                      TextSpan(text: 'Don\'t have an account? '),
                      TextSpan(
                        text: 'Sign Up',
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
            text: 'Sign In',
            onTap: () => context.read<AuthBlocBloc>().add(
              AuthSignIn(
                email: emailController.text,
                password: passwordController.text,
              ),
            ),
          );
        }
      },
    );
  }
}
