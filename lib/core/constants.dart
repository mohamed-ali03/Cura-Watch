// Text Style
import 'package:cura_watch/features/user/patient/presentation/widgets/reports/report_page.dart';
import 'package:flutter/material.dart';

final TextStyle headerTextStyle = TextStyle(
  fontSize: 24,
  letterSpacing: 0.05,
  fontWeight: FontWeight.w600,
  color: Color(0xFF2B4464),
);

final TextStyle subtitleTextStyle = TextStyle(
  fontSize: 20,
  letterSpacing: 0.05,
  fontWeight: FontWeight.w600,
  color: Color(0xFF2B4464),
);

final TextStyle subtitleTextStyle2 = TextStyle(
  fontSize: 14,
  letterSpacing: 0.05,
  fontWeight: FontWeight.w600,
  color: Color(0xFF2B4464),
);

final TextStyle bodyTextStyle = TextStyle(
  fontSize: 14,
  letterSpacing: 0.05,
  fontWeight: FontWeight.w400,
  color: Color(0xFF2B4464),
);

const List<String> headerTitles = [
  'Complete Your Profile',
  'Medical Background',
  'Current Medications',
  'Emergeny Contacts',
];

final List<String> bloodTypes = [
  'A+',
  'A−',
  'B+',
  'B−',
  'O+',
  'O−',
  'AB+',
  'AB−',
];

final Map<String, bool> diseases = {
  'Diabetes': false,
  'Hypertension': false,
  'Heart Disease': false,
  'Asthma': false,
};

const mainColor = 0xFF2B4464;
const secondColor = 0xFFD0DCE8;

enum AuthRouteType {
  signIn,
  signUp,
  forgetPassword,
  verification,
  resetPassword,
}

// --------------------------------------------------------------
// Day readings (1-22 hours) - 2026, 3, 11
final dayReadings = [
  Reading(date: DateTime(2026, 3, 11, 1), value: 58.0),
  Reading(date: DateTime(2026, 3, 11, 2), value: 55.0),
  Reading(date: DateTime(2026, 3, 11, 3), value: 54.0),
  Reading(date: DateTime(2026, 3, 11, 4), value: 53.0),
  Reading(date: DateTime(2026, 3, 11, 5), value: 55.0),
  Reading(date: DateTime(2026, 3, 11, 6), value: 60.0),
  Reading(date: DateTime(2026, 3, 11, 7), value: 72.0),
  Reading(date: DateTime(2026, 3, 11, 8), value: 85.0),
  Reading(date: DateTime(2026, 3, 11, 9), value: 90.0),
  Reading(date: DateTime(2026, 3, 11, 10), value: 88.0),
  Reading(date: DateTime(2026, 3, 11, 11), value: 92.0),
  Reading(date: DateTime(2026, 3, 11, 12), value: 95.0),
  Reading(date: DateTime(2026, 3, 11, 13), value: 98.0),
  Reading(date: DateTime(2026, 3, 11, 14), value: 94.0),
  Reading(date: DateTime(2026, 3, 11, 15), value: 100.0),
  Reading(date: DateTime(2026, 3, 11, 16), value: 96.0),
  Reading(date: DateTime(2026, 3, 11, 17), value: 110.0),
  Reading(date: DateTime(2026, 3, 11, 18), value: 105.0),
  Reading(date: DateTime(2026, 3, 11, 19), value: 88.0),
  Reading(date: DateTime(2026, 3, 11, 20), value: 82.0),
  Reading(date: DateTime(2026, 3, 11, 21), value: 75.0),
  Reading(date: DateTime(2026, 3, 11, 22), value: 70.0),
];

// Week readings (Sun=8 Mar, Fri=13 Mar 2026)
final weekReadings = [
  Reading(date: DateTime(2026, 3, 8), value: 78.0), // Sun
  Reading(date: DateTime(2026, 3, 9), value: 82.0), // Mon
  Reading(date: DateTime(2026, 3, 10), value: 88.0), // Tue
  Reading(date: DateTime(2026, 3, 11), value: 85.0), // Wed
  Reading(date: DateTime(2026, 3, 12), value: 90.0), // Thu
  Reading(date: DateTime(2026, 3, 13), value: 86.0), // Fri
];

// Month readings (day 1-11 of Mar 2026, last at 10 PM)
final monthReadings = [
  Reading(date: DateTime(2026, 3, 1), value: 80.0),
  Reading(date: DateTime(2026, 3, 2), value: 76.0),
  Reading(date: DateTime(2026, 3, 3), value: 82.0),
  Reading(date: DateTime(2026, 3, 4), value: 79.0),
  Reading(date: DateTime(2026, 3, 5), value: 85.0),
  Reading(date: DateTime(2026, 3, 6), value: 91.0),
  Reading(date: DateTime(2026, 3, 7), value: 87.0),
  Reading(date: DateTime(2026, 3, 8), value: 83.0),
  Reading(date: DateTime(2026, 3, 9), value: 78.0),
  Reading(date: DateTime(2026, 3, 10), value: 81.0),
  Reading(date: DateTime(2026, 3, 11, 22), value: 70.0),
];
