import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/settings_controller.dart';
import 'package:revory/services/notification_service.dart';

/// Provides service reminder persistence and notification coordination.
final Provider<ReminderController> reminderControllerProvider = Provider(
  ReminderController.new,
);

/// Persists reminder changes and synchronizes scheduled notifications.
class ReminderController {
  /// Creates reminder coordination using the current provider container.
  new(this.ref);

  /// Provider reference used to access garage and reminder preferences.
  final Ref ref;

  /// Persists garage reminder fields and rebuilds notification schedules.
  Future<void> saveReminder() async {
    await ref.read(garageControllerProvider.notifier).saveVehicle();
    await synchronize();
  }

  /// Replaces schedules for all vehicles, respecting the reminder preference.
  Future<void> synchronize() async {
    await NotificationService.cancelAll();
    if (!ref.read(settingsControllerProvider).remindersEnabled) return;
    final vehicles = ref.read(garageControllerProvider).vehicles;
    for (var i = 0; i < vehicles.length; i++) {
      final vehicle = vehicles[i];
      if (vehicle.nextServiceDate != null) {
        await NotificationService.schedule(
          id: i + 100,
          vehicle: vehicle.name,
          service: vehicle.nextServiceLabel,
          dueDate: vehicle.nextServiceDate!,
        );
      }
    }
  }
}
