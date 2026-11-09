import 'package:revory/models/vehicle.dart';

class ReminderFormController {
  bool apply(
    Vehicle vehicle, {
    required String label,
    required String mileage,
    required DateTime? date,
  }) {
    if (date == null) return false;
    vehicle.nextServiceLabel = label.trim().isEmpty
        ? 'Next service'
        : label.trim();
    vehicle.nextServiceMileage = int.tryParse(mileage.replaceAll(',', ''));
    vehicle.nextServiceDate = date;
    return true;
  }
}
