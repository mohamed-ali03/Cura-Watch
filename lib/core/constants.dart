// Text Style
import 'package:flutter/material.dart';

final TextStyle headerTextStyle = TextStyle(
  fontSize: 24,
  letterSpacing: 0.05,
  fontWeight: FontWeight.w600,
  color: Color(0xFF2B4464),
);

final TextStyle subtitleTextStyle = TextStyle(
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
