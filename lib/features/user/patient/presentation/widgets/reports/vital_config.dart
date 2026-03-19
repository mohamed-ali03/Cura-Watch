// ─── Vital Config ──────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class VitalConfig {
  final String name;
  final String unit;
  final double normalRangeMin;
  final double normalRangeMax;
  final IconData icon;

  const VitalConfig({
    required this.name,
    required this.unit,
    required this.normalRangeMin,
    required this.normalRangeMax,
    required this.icon,
  });

  static const List<VitalConfig> all = [
    VitalConfig(
      name: 'Blood Pressure',
      unit: 'mmHg',
      normalRangeMin: 80,
      normalRangeMax: 120,
      icon: Icons.monitor_heart,
    ),
    VitalConfig(
      name: 'Heart Rate',
      unit: 'bpm',
      normalRangeMin: 60,
      normalRangeMax: 100,
      icon: Icons.favorite,
    ),
    VitalConfig(
      name: 'Oxygen',
      unit: '%',
      normalRangeMin: 95,
      normalRangeMax: 100,
      icon: Icons.air,
    ),
    VitalConfig(
      name: 'Steps',
      unit: 'steps',
      normalRangeMin: 7000,
      normalRangeMax: 10000,
      icon: Icons.directions_walk,
    ),
    VitalConfig(
      name: 'Temperature',
      unit: '°C',
      normalRangeMin: 36.1,
      normalRangeMax: 37.2,
      icon: Icons.thermostat,
    ),
    VitalConfig(
      name: 'Glucose',
      unit: 'mg/dL',
      normalRangeMin: 70,
      normalRangeMax: 100,
      icon: Icons.bloodtype,
    ),
  ];

  static VitalConfig? findByName(String name) {
    try {
      return all.firstWhere((v) => v.name == name);
    } catch (_) {
      return null;
    }
  }
}
