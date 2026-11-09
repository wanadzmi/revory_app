import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/history_controller.dart';
import 'package:revory/controllers/profile_controller.dart';
import 'package:revory/models/maintenance_record.dart';
import 'package:revory/models/vehicle.dart';

final homeControllerProvider = Provider(
  (ref) => HomeState(
    ref.watch(garageControllerProvider).vehicle,
    ref.watch(selectedVehicleRecordsProvider),
    ref.watch(profileControllerProvider).nickname,
  ),
);

class HomeState {
  const HomeState(this.vehicle, this.records, this.nickname);
  final Vehicle vehicle;
  final List<MaintenanceRecord> records;
  final String nickname;

  String greeting(DateTime now) {
    final hour = now.hour;
    return hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : hour < 21
        ? 'Good evening'
        : 'Good night';
  }

  String get reminderText {
    final parts = <String>[];
    if (vehicle.nextServiceMileage != null) {
      parts.add('At ${vehicle.nextServiceMileage} km');
    }
    final date = vehicle.nextServiceDate;
    if (date != null) parts.add('by ${date.day}/${date.month}/${date.year}');
    return parts.isEmpty
        ? 'No target set — tap Manage to add one.'
        : parts.join(' • ');
  }
}
