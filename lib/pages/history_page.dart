import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/history_controller.dart';
import 'package:revory/models/maintenance_record.dart';
import 'package:revory/widgets/maintenance/add_maintenance_sheet.dart';
import 'package:revory/widgets/maintenance/maintenance_empty_state.dart';
import 'package:revory/widgets/maintenance/record_tile.dart';
import 'package:revory/widgets/slide_actions.dart';

/// Displays maintenance history for the selected garage vehicle.
class HistoryPage extends ConsumerWidget {
  /// Creates the selected-vehicle maintenance history page.
  const new({super.key});

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
              onPressed: () => _addMaintenance(context, ref),
              tooltip: 'Add maintenance',
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text('${records.length} records saved for this vehicle'),
        const SizedBox(height: 20),
        if (records.isEmpty)
          const MaintenanceEmptyState()
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

  Future<void> _addMaintenance(BuildContext context, WidgetRef ref) async {
    final garage = ref.read(garageControllerProvider);
    final record = await showModalBottomSheet<MaintenanceRecord>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddMaintenance(
        mileage: garage.vehicle.mileage,
        vehicles: garage.vehicles,
        selectedVehicleId: garage.vehicle.id,
      ),
    );
    if (record == null || !context.mounted) return;
    await ref.read(historyControllerProvider.notifier).addRecord(record);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maintenance saved to your history.')),
      );
    }
  }
}
