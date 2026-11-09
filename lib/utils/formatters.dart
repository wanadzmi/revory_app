import 'package:flutter/material.dart';

/// Formats an integer with comma-separated thousands.
String numText(int n) =>
    n.toString().replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (_) => ',');

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
