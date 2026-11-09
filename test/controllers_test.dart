import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/history_controller.dart';
import 'package:revory/controllers/home_controller.dart';
import 'package:revory/controllers/profile_controller.dart';
import 'package:revory/controllers/settings_controller.dart';
import 'package:revory/models/maintenance_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'history follows vehicle selection and updates the correct odometer',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final garage = container.read(garageControllerProvider.notifier);
      final first = container.read(garageControllerProvider).vehicle;
      await garage.selectVehicle(1);
      final second = container.read(garageControllerProvider).vehicle;
      final record = MaintenanceRecord(
        'Oil change',
        '',
        DateTime(2026),
        90000,
        100,
        null,
      );
      await container
          .read(historyControllerProvider.notifier)
          .addRecord(record);
      expect(record.vehicleId, second.id);
      expect(container.read(homeControllerProvider).records, [record]);
      expect(container.read(homeControllerProvider).vehicle.mileage, 90000);
      expect(first.mileage, 42180);
      await garage.selectVehicle(0);
      expect(
        container.read(selectedVehicleRecordsProvider),
        isNot(contains(record)),
      );
    },
  );

  test(
    'separate controllers restore saved profile, settings, garage and history',
    () async {
      final first = ProviderContainer();
      addTearDown(first.dispose);
      await first
          .read(profileControllerProvider.notifier)
          .updateProfile('Nadzmi', '/photo.jpg');
      await first
          .read(settingsControllerProvider.notifier)
          .setThemeMode(ThemeMode.system);
      await first.read(garageControllerProvider.notifier).selectVehicle(1);
      await first
          .read(historyControllerProvider.notifier)
          .addRecord(
            MaintenanceRecord('Brakes', '', DateTime(2026), 88000, 200, null),
          );
      final restored = ProviderContainer();
      addTearDown(restored.dispose);
      await restored.read(garageControllerProvider.notifier).restore();
      await restored.read(historyControllerProvider.notifier).restore();
      await restored.read(profileControllerProvider.notifier).restore();
      await restored.read(settingsControllerProvider.notifier).restore();
      expect(restored.read(homeControllerProvider).nickname, 'Nadzmi');
      expect(restored.read(profileControllerProvider).photoPath, '/photo.jpg');
      expect(
        restored.read(settingsControllerProvider).themeMode,
        ThemeMode.system,
      );
      expect(restored.read(garageControllerProvider).selected, 1);
      expect(
        restored.read(selectedVehicleRecordsProvider).single.title,
        'Brakes',
      );
    },
  );
}
