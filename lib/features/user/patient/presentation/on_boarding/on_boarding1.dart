import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class OnBoarding1 extends StatefulWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final ValueNotifier<bool> isMale;
  final ValueNotifier<DateTime> selectedDate;
  const OnBoarding1({
    super.key,
    required this.heightController,
    required this.weightController,
    required this.isMale,
    required this.selectedDate,
  });

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18), // default 18 years old
      firstDate: DateTime(1900), // minimum DOB
      lastDate: now, // can't pick future date
    );

    if (picked != null) {
      widget.selectedDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // image
          Image.asset('assets/images/onBoarding_1.jpeg'),
          SizedBox(height: getIt<SizeConfig>().blockHight * 3),

          // data input
          MyTextField(
            hintText: 'Height',
            controller: widget.heightController,
            isNumber: true,
          ),
          SizedBox(height: getIt<SizeConfig>().blockHight * 2),
          MyTextField(
            hintText: 'Weight',
            controller: widget.weightController,
            isNumber: true,
          ),
          SizedBox(height: getIt<SizeConfig>().blockHight * 2),
          ValueListenableBuilder(
            valueListenable: widget.selectedDate,
            builder: (context, selectedDate, child) => TextFormField(
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: "Date of Birth",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text:
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
            ),
          ),
          SizedBox(height: getIt<SizeConfig>().blockHight * 2),
          ValueListenableBuilder(
            valueListenable: widget.isMale,
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyButton(
                    text: 'Male',
                    colored: value,
                    onTap: () => widget.isMale.value = true,
                  ),
                ),
                SizedBox(width: getIt<SizeConfig>().blockWidth * 2),
                Expanded(
                  child: MyButton(
                    text: 'Female',
                    colored: !value,
                    onTap: () => widget.isMale.value = false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
