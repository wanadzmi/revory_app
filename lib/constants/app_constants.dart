import 'package:flutter/material.dart';

const themeModeLabels = <ThemeMode, String>{
  ThemeMode.light: 'Light',
  ThemeMode.dark: 'Dark',
  ThemeMode.system: 'Follow device settings',
};

String greetingForTime(DateTime time) {
  if (time.hour < 12) return 'Good morning';
  if (time.hour < 17) return 'Good afternoon';
  if (time.hour < 21) return 'Good evening';
  return 'Good night';
}

String numText(int n) {
  final s = n.toString();
  return s.replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (_) => ',');
}

String dateText(DateTime d) =>
    '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.day}, ${d.year}';
IconData iconFor(String t) => t.toLowerCase().contains('brake')
    ? Icons.disc_full_outlined
    : t.toLowerCase().contains('tyre')
    ? Icons.tire_repair_outlined
    : Icons.oil_barrel_outlined;
