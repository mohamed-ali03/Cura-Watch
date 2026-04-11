import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/features/user/patient/bloc/patient_bloc.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding1.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding2.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding3.dart';
import 'package:cura_watch/features/user/patient/presentation/on_boarding/on_boarding4.dart';
import 'package:cura_watch/features/user/shared/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserOnBoarding extends StatefulWidget {
  final Patient? patient;
  const UserOnBoarding({super.key, this.patient});

  @override
  State<UserOnBoarding> createState() => _UserOnBoardingState();
}

class _UserOnBoardingState extends State<UserOnBoarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
      ValueNotifier([TextEditingController()]);
  final ValueNotifier<List<TimeOfDay>> _dosageTimes = ValueNotifier([
    TimeOfDay(hour: 0, minute: 0),
  ]);

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

    if (widget.patient != null) {
      _heightController.text = widget.patient!.height.toString();
      _weightController.text = widget.patient!.weight.toString();
      _isMale.value = widget.patient!.gender == 'male';
      _selectedDate.value = widget.patient!.dateOfBirth;
      _selectedBloodType.value = widget.patient!.bloodType;
      _allergiesController.text = widget.patient!.allergies.join(', ');
      _selectedDiseases.value = widget.patient!.chronicDiseases;
      _doctorIdController.text = widget.patient!.assignedDoctorId;
      _emergencyContacts.value = widget.patient!.emergencyContact
          .map(
            (contact) => {
              'name': TextEditingController(text: contact.keys.first),
              'phone': TextEditingController(text: contact.values.first),
            },
          )
          .toList();
      getMedicationSeperated();
    }

    super.initState();
  }

  // navigate between pages
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

  Map<String, dynamic> getMedicationMap() {
    final medications = _medicationControllers.value;
    final times = _dosageTimes.value;

    final Map<String, dynamic> result = {};

    for (int i = 0; i < medications.length; i++) {
      final name = medications[i].text.trim();
      if (name.isNotEmpty) {
        result[name] = '${times[i].hour}:${times[i].minute}';
      }
    }
    return result;
  }

  void getMedicationSeperated() {
    for (var medication in widget.patient!.medications.keys) {
      _medicationControllers.value.add(TextEditingController(text: medication));
      final parts = widget.patient!.medications[medication]!.split(":");
      final time = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
      _dosageTimes.value.add(time);
    }
  }

  // finish on boarding and send data to server
  void _finish() async {
    context.read<PatientBloc>().add(
      EditPatientInfoEvent(
        gender: _isMale.value ? 'male' : 'female',
        weight: double.tryParse(_weightController.text) ?? 0.0,
        height: double.tryParse(_heightController.text) ?? 0.0,
        dateOfBirth: _selectedDate.value,
        bloodType: _selectedBloodType.value,
        chronicDiseases: _selectedDiseases.value,
        allergies: _allergiesController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        medications: getMedicationMap(),

        assignedDoctorId: _doctorIdController.text,
        emergencyContact: _emergencyContacts.value.map((e) {
          return {
            e['name']?.text ?? 'Not Defined': e['phone']?.text ?? 'Not Defined',
          };
        }).toList(),
      ),
    );
    if (widget.patient != null) {
      Navigator.pop(context);
    }
  }

  List<String> titles = [
    'Complete Your Profile',
    'Medical Background',
    'Current Medications',
    'Emergency Contacts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(titles[_currentPage]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _currentPage == 0
              ? () => Navigator.pop(context)
              : _previousPage,
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getIt<SizeConfig>().blockHight * 3,
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
                    selectedBloodType: _selectedBloodType,
                    allergiesController: _allergiesController,
                    selectedDiseases: _selectedDiseases,
                  ),
                  MedicationWidget(
                    medicationControllers: _medicationControllers,
                    dosageTimes: _dosageTimes,
                  ),
                  DoctorContactWidget(
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
