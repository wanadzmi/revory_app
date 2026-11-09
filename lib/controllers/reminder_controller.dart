import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/settings_controller.dart';
import 'package:revory/services/notification_service.dart';

final reminderControllerProvider = Provider(ReminderController.new);

class ReminderController {
  ReminderController(this.ref);
  final Ref ref;
  Future<void> saveReminder() async {
    await ref.read(garageControllerProvider.notifier).saveVehicle();
    await synchronize();
  }

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
