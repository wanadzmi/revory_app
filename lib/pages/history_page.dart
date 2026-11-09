import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/history_controller.dart';
import 'package:revory/widgets/list_widgets.dart';
import 'package:revory/widgets/slide_actions.dart';

/// Displays maintenance history for the selected garage vehicle.
class HistoryPage extends ConsumerWidget {
  /// Creates the history page with its add-maintenance interaction.
  const new({required this.onAdd, super.key});

  /// Opens the maintenance-entry form.
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(selectedVehicleRecordsProvider);
    final onDelete = ref.read(historyControllerProvider.notifier).deleteRecord;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      children: [
        Row(
          children: [
            Text(
              'Maintenance',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            IconButton(
              onPressed: onAdd,
              tooltip: 'Add maintenance',
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text('${records.length} records saved for this vehicle'),
        const SizedBox(height: 20),
        if (records.isEmpty)
          const Empty()
        else
          ...records.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SlideActions(
                itemKey: ValueKey(r),
                itemLabel: r.title,
                onDeleted: () => onDelete(r),
                child: RecordTile(
                  record: r,
                  detailed: true,
                  margin: EdgeInsets.zero,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
