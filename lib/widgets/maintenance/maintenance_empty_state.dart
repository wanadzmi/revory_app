import 'package:flutter/material.dart';

/// Placeholder displayed when no maintenance records are available.
class MaintenanceEmptyState extends StatelessWidget {
  /// Creates the maintenance-history empty state.
  const new({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 45),
    child: Column(
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 12),
        const Text(
          'No maintenance recorded yet',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text('Your service history will appear here.'),
      ],
    ),
  );
}
