import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/features/garage/controllers/garage_controller.dart';
import 'package:revory/features/garage/models/vehicle.dart';
import 'package:revory/features/maintenance/controllers/history_controller.dart';
import 'package:revory/features/maintenance/models/maintenance_record.dart';
import 'package:revory/features/profile/controllers/profile_controller.dart';

/// Combines selected vehicle, history, and profile state for the Home page.
final Provider<HomeState> homeControllerProvider = Provider(
  (ref) => HomeState(
    ref.watch(garageControllerProvider).vehicle,
    ref.watch(selectedVehicleRecordsProvider),
    ref.watch(profileControllerProvider).nickname,
  ),
);

/// Derived data displayed on the Home page.
class HomeState {
  /// Creates the Home view state from its feature dependencies.
  const new(this.vehicle, this.records, this.nickname);

  /// Vehicle whose summary and reminder are displayed.
  final Vehicle vehicle;

  /// Maintenance history for the selected vehicle.
  final List<MaintenanceRecord> records;

  /// Display name used in the garage heading.
  final String nickname;

  /// Returns the greeting appropriate for the supplied local time.
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

  /// Summary of configured service targets, or guidance when no target exists.
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
