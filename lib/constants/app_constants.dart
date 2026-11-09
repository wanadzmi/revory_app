import 'package:flutter/material.dart';

/// Display labels for the supported appearance modes.
const themeModeLabels = <ThemeMode, String>{
  ThemeMode.light: 'Light',
  ThemeMode.dark: 'Dark',
  ThemeMode.system: 'Follow device settings',
};

/// Returns a local-time greeting for the supplied time.
String greetingForTime(DateTime time) {
  if (time.hour < 12) return 'Good morning';
  if (time.hour < 17) return 'Good afternoon';
  if (time.hour < 21) return 'Good evening';
  return 'Good night';
}

/// Formats an integer with comma-separated thousands.
String numText(int n) {
  final s = n.toString();
  return s.replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (_) => ',');
}

/// Formats a date using an English month abbreviation.
String dateText(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}

/// Chooses a maintenance icon from the service title.
IconData iconFor(String t) => t.toLowerCase().contains('brake')
    ? Icons.disc_full_outlined
    : t.toLowerCase().contains('tyre')
    ? Icons.tire_repair_outlined
    : Icons.oil_barrel_outlined;
