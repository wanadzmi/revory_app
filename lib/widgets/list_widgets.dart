import 'package:flutter/material.dart';
import 'package:revory/models/maintenance_record.dart';
import 'package:revory/utils/formatters.dart';

class RecordTile extends StatelessWidget {
  const RecordTile({
    super.key,
    required this.record,
    this.detailed = false,
    this.margin = const EdgeInsets.only(bottom: 10),
  });
  final MaintenanceRecord record;
  final bool detailed;
  final EdgeInsetsGeometry margin;
  @override
  Widget build(BuildContext context) => Card(
    margin: margin,
    child: ListTile(
      leading: const Icon(Icons.build_outlined),
      title: Text(
        record.title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('${dateText(record.date)} • ${record.workshop}'),
      trailing: Text('RM ${record.cost.toStringAsFixed(0)}'),
    ),
  );
}

class Section extends StatelessWidget {
  const Section(this.title, this.action, {super.key, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const Spacer(),
      if (action != null)
        GestureDetector(
          onTap: onTap,
          child: Text(
            action!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ],
  );
}

class Empty extends StatelessWidget {
  const Empty({super.key});
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
