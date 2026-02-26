import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding1.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding2.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding3.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding4.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserOnBoarding extends StatefulWidget {
  const UserOnBoarding({super.key});

  @override
  State<UserOnBoarding> createState() => _UserOnBoardingState();
}

class _UserOnBoardingState extends State<UserOnBoarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Shared state for onboarding data
  // on boarding 1
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final ValueNotifier<bool> _isMale = ValueNotifier(true);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());

  // on boarding 2
  final ValueNotifier<String> _selectedBloodType = ValueNotifier('');
  final TextEditingController _allergiesController = TextEditingController();
  final ValueNotifier<List<String>> _selectedDiseases = ValueNotifier([]);

  // on boarding 3
  final ValueNotifier<List<TextEditingController>> _medicationControllers =
      ValueNotifier([]);
  final ValueNotifier<List<TimeOfDay>> _dosageTimes = ValueNotifier([]);

  // on boarding 4
  final TextEditingController _doctorIdController = TextEditingController();
  final ValueNotifier<List<Map<String, TextEditingController>>>
  _emergencyContacts = ValueNotifier([
    {'name': TextEditingController(), 'phone': TextEditingController()},
  ]);

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    super.initState();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getIt<SizeConfig>().blockHight * 8,
          horizontal: getIt<SizeConfig>().blockWidth * 8,
        ),
        child: Column(
          children: [
            // selected screen
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  OnBoarding1(
                    heightController: _heightController,
                    weightController: _weightController,
                    isMale: _isMale,
                    selectedDate: _selectedDate,
                  ),
                  HealthInfoWidget(
                    onBack: _previousPage,
                    selectedBloodType: _selectedBloodType,
                    allergiesController: _allergiesController,
                    selectedDiseases: _selectedDiseases,
                  ),
                  MedicationWidget(
                    onBack: _previousPage,
                    medicationControllers: _medicationControllers,
                    dosageTimes: _dosageTimes,
                  ),
                  DoctorContactWidget(
                    onBack: _previousPage,
                    doctorIdController: _doctorIdController,
                    emergencyContacts: _emergencyContacts,
                  ),
                ],
              ),
            ),
            SizedBox(height: getIt<SizeConfig>().blockHight * 2),
            // page indicator
            SmoothPageIndicator(controller: _pageController, count: 4),
            SizedBox(height: getIt<SizeConfig>().blockHight * 3),

            // buttons [next , next/previous, finish]
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _button() {
    if (_currentPage == 0) {
      return MyButton(text: 'Next', onTap: _nextPage);
    } else if (_currentPage == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MyButton(
              text: 'Previous',
              colored: false,
              onTap: _previousPage,
            ),
          ),
          SizedBox(width: getIt<SizeConfig>().blockWidth * 2),
          Expanded(
            child: MyButton(text: 'Finish', colored: true, onTap: _finish),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MyButton(
              text: 'Previous',
              colored: false,
              onTap: _previousPage,
            ),
          ),
          SizedBox(width: getIt<SizeConfig>().blockWidth * 2),
          Expanded(
            child: MyButton(text: 'Next', colored: true, onTap: _nextPage),
          ),
        ],
      );
    }
  }
}
