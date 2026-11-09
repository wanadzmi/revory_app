import 'package:flutter_test/flutter_test.dart';
import 'package:revory/features/garage/controllers/vehicle_form_controller.dart';
import 'package:revory/features/maintenance/controllers/maintenance_form_controller.dart';
import 'package:revory/features/profile/controllers/profile_details_controller.dart';
import 'package:revory/features/reminders/controllers/reminder_form_controller.dart';

void main() {
  test(
    'maintenance controller validates service and normalizes form input',
    () {
      final controller = MaintenanceFormController();
      expect(controller.canSave('  '), isFalse);
      final record = controller.create(
        service: ' Oil change ',
        workshop: ' ',
        mileage: '42,500',
        fallbackMileage: 0,
        cost: '125.50',
        vehicleId: 'car',
      );
      expect(record!.title, 'Oil change');
      expect(record.mileage, 42500);
      expect(record.cost, 125.5);
      expect(record.vehicleId, 'car');
      expect(record.workshop, 'No workshop added');
    },
  );

  test(
    'vehicle and reminder controllers preserve defaults and require a date',
    () {
      final form = VehicleFormController();
      expect(
        form.create(name: ' ', year: '', registration: '', mileage: ''),
        isNull,
      );
      final vehicle = form.create(
        name: ' Car ',
        year: '',
        registration: '',
        mileage: 'invalid',
      )!;
      expect(vehicle.name, 'Car');
      expect(vehicle.mileage, 0);
      final reminder = ReminderFormController();
      expect(
        reminder.apply(vehicle, label: '', mileage: '1,000', date: null),
        isFalse,
      );
      expect(vehicle.nextServiceDate, isNull);
      final date = DateTime(2027);
      expect(
        reminder.apply(vehicle, label: ' ', mileage: '1,000', date: date),
        isTrue,
      );
      expect(vehicle.nextServiceMileage, 1000);
      expect(vehicle.nextServiceLabel, 'Next service');
      expect(vehicle.nextServiceDate, date);
      expect(ProfileDetailsController().create(' ', null).nickname, 'Driver');
    },
  );
}
