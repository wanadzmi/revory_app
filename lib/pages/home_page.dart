import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/home_controller.dart';
import 'package:revory/controllers/reminder_controller.dart';
import 'package:revory/widgets/garage/vehicle_card.dart';
import 'package:revory/widgets/garage/vehicle_selector_sheet.dart';
import 'package:revory/widgets/maintenance/maintenance_empty_state.dart';
import 'package:revory/widgets/maintenance/record_tile.dart';
import 'package:revory/widgets/reminders/service_reminder_sheet.dart';
import 'package:revory/widgets/section_header.dart';

/// Displays the selected vehicle, service targets, and recent maintenance.
class HomePage extends ConsumerWidget {
  /// Creates the selected-vehicle overview page.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final vehicle = state.vehicle;
    final records = state.records;
    final nickname = state.nickname;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.greeting(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "$nickname's garage",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              VehicleCard(
                vehicle: vehicle,
                onTap: () => _chooseVehicle(context),
              ),
              const SizedBox(height: 28),
              SectionHeader(
                'UPCOMING SERVICE',
                'Manage',
                onTap: () => _manageReminder(context, ref),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          Icons.oil_barrel_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.nextServiceLabel,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(state.reminderText),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 27),
              const SectionHeader('RECENT MAINTENANCE', 'See all'),
              const SizedBox(height: 8),
              if (records.isEmpty)
                const MaintenanceEmptyState()
              else
                ...records.take(3).map((r) => RecordTile(record: r)),
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> _chooseVehicle(BuildContext context) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => const VehicleSelectorSheet(),
      );

  Future<void> _manageReminder(BuildContext context, WidgetRef ref) async {
    final vehicle = ref.read(garageControllerProvider).vehicle;
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ServiceReminderSheet(vehicle: vehicle),
    );
    if (changed == true && context.mounted) {
      await ref.read(reminderControllerProvider).saveReminder();
    }
  }
}
