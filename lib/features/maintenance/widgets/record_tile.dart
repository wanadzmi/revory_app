import 'package:flutter/material.dart';
import 'package:revory/features/maintenance/models/maintenance_record.dart';
import 'package:revory/shared/utils/formatters.dart';

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
