import 'dart:io';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/history_controller.dart';
import 'package:revory/controllers/main_controller.dart';
import 'package:revory/controllers/reminder_controller.dart';
import 'package:revory/models/maintenance_record.dart';
import 'package:revory/pages/history_page.dart';
import 'package:revory/pages/home_page.dart';
import 'package:revory/pages/profile_page.dart';
import 'package:revory/widgets/add_maintenance_sheet.dart';
import 'package:revory/widgets/app_bottom_navigation_bar.dart';
import 'package:revory/widgets/service_reminder_sheet.dart';

/// Composes the primary tab pages and their navigation interactions.
class MainPage extends ConsumerStatefulWidget {
  /// Creates the primary navigation page.
  const new({super.key});
  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  Future<void> add() async {
    final appState = ref.read(garageControllerProvider);
    final result = await showModalBottomSheet<MaintenanceRecord>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddMaintenance(
        mileage: appState.vehicle.mileage,
        vehicles: appState.vehicles,
        selectedVehicleId: appState.vehicle.id,
      ),
    );
    if (result != null) {
      await ref.read(historyControllerProvider.notifier).addRecord(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maintenance saved to your history.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(mainControllerProvider);
    final pages = [
      HomePage(choose: choose, manageReminder: manageReminder),
      HistoryPage(onAdd: add),
      const ProfilePage(),
    ];
    return AdaptiveScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      minimizeBehavior: TabBarMinimizeBehavior.never,
      body: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: IndexedStack(index: tab, children: pages),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: tab,
        onSelected: (index) =>
            ref.read(mainControllerProvider.notifier).selectedTab = index,
      ),
    );
  }

  Future<void> choose() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (c) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose vehicle', style: Theme.of(c).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(ref.read(garageControllerProvider).vehicles.length, (
            i,
          ) {
            final appState = ref.read(garageControllerProvider);
            final v = appState.vehicles[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: v.color,
                backgroundImage: v.photoPath == null
                    ? null
                    : FileImage(File(v.photoPath!)),
                child: v.photoPath == null
                    ? const Icon(Icons.directions_car, color: Colors.white)
                    : null,
              ),
              title: Text(v.name),
              subtitle: Text(v.registration),
              trailing: i == appState.selected
                  ? const Icon(Icons.check_circle)
                  : null,
              onTap: () async {
                await ref
                    .read(garageControllerProvider.notifier)
                    .selectVehicle(i);
                if (c.mounted) Navigator.pop(c);
              },
            );
          }),
        ],
      ),
    ),
  );

  Future<void> manageReminder() async {
    final vehicle = ref.read(garageControllerProvider).vehicle;
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ServiceReminderSheet(vehicle: vehicle),
    );
    if (changed == true) {
      await ref.read(reminderControllerProvider).saveReminder();
    }
  }
}
