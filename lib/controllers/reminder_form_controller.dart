import 'package:revory/models/vehicle.dart';

/// Validates and applies upcoming-service form input.
class ReminderFormController {
  /// Applies reminder input, returning false without changes when date is null.
  bool apply(
    Vehicle vehicle, {
    required String label,
    required String mileage,
    required DateTime? date,
  }) {
    if (date == null) return false;
    vehicle
      ..nextServiceLabel = label.trim().isEmpty ? 'Next service' : label.trim()
      ..nextServiceMileage = int.tryParse(mileage.replaceAll(',', ''))
      ..nextServiceDate = date;
    return true;
  }
}
