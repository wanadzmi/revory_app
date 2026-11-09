import 'package:flutter/material.dart';

String numText(int n) =>
    n.toString().replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (_) => ',');
String dateText(DateTime d) =>
    '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.day}, ${d.year}';
IconData iconFor(String t) => t.toLowerCase().contains('brake')
    ? Icons.disc_full_outlined
    : t.toLowerCase().contains('tyre')
    ? Icons.tire_repair_outlined
    : Icons.oil_barrel_outlined;
