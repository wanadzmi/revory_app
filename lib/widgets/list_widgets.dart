import 'package:flutter/material.dart';
import 'package:revory/models/maintenance_record.dart';
import 'package:revory/utils/formatters.dart';

/// Maintenance summary tile with optional detailed presentation.
class RecordTile extends StatelessWidget {
  /// Creates a maintenance tile with optional detail and margin settings.
  const new({
    required this.record,
    super.key,
    this.detailed = false,
    this.margin = const EdgeInsets.only(bottom: 10),
  });

  /// Maintenance record displayed by this tile.
  final MaintenanceRecord record;

  /// Whether to show the detailed record presentation.
  final bool detailed;

  /// Outer spacing applied to the tile's card.
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

/// Section heading with an optional action label.
class Section extends StatelessWidget {
  /// Creates a heading with an optional trailing action.
  const new(this.title, this.action, {super.key, this.onTap});

  /// Heading text displayed for the section.
  final String title;

  /// Trailing action label, or null when no action is displayed.
  final String? action;

  /// Invoked when the trailing action is tapped, if supplied.
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

/// Placeholder displayed when no maintenance records are available.
class Empty extends StatelessWidget {
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
