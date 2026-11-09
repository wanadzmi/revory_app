import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/core/repositories/local_app_repository.dart';
import 'package:revory/features/garage/controllers/garage_controller.dart';
import 'package:revory/features/maintenance/models/maintenance_record.dart';

/// Provides maintenance history state and record operations.
final historyControllerProvider =
    NotifierProvider<HistoryController, List<MaintenanceRecord>>(
      HistoryController.new,
    );

/// Records belonging to the selected vehicle, including legacy unassigned data.
final Provider<List<MaintenanceRecord>> selectedVehicleRecordsProvider =
    Provider((ref) {
      final garage = ref.watch(garageControllerProvider);
      return ref
          .watch(historyControllerProvider)
          .where(
            (r) =>
                r.vehicleId == garage.vehicle.id ||
                (r.vehicleId.isEmpty && garage.selected == 0),
          )
          .toList();
    });

/// Manages maintenance records and their local persistence.
class HistoryController extends Notifier<List<MaintenanceRecord>> {
  @override
  List<MaintenanceRecord> build() => [
    MaintenanceRecord(
      'Engine oil & filter',
      'Shell Jalan Ampang',
      DateTime(2026, 10, 12),
      42180,
      278,
      'receipt-october.jpg',
    ),
    MaintenanceRecord(
      'Brake pads',
      'Autohaus Service Centre',
      DateTime(2026, 7, 4),
      37820,
      420,
      'brake-pads.pdf',
    ),
    MaintenanceRecord(
      'Tyre rotation',
      'TyrePro',
      DateTime(2026, 4, 18),
      34100,
      80,
      null,
    ),
  ];

  /// Storage dependency used for maintenance history.
  LocalAppRepository get repository => ref.read(localAppRepositoryProvider);

  /// Replaces history with saved records when stored data exists.
  Future<void> restore() async {
    final saved = await repository.readList('records');
    if (saved != null) state = saved.map(MaintenanceRecord.fromJson).toList();
  }

  /// Saves a record and updates its vehicle's recorded mileage.
  Future<void> addRecord(MaintenanceRecord record) async {
    if (record.vehicleId.isEmpty) {
      record.vehicleId = ref.read(garageControllerProvider).vehicle.id;
    }
    state = [record, ...state];
    await repository.writeList(
      'records',
      state.map((r) => r.toJson()).toList(),
    );
    await ref
        .read(garageControllerProvider.notifier)
        .updateMileage(record.vehicleId, record.mileage);
  }

  /// Removes a record from history and persists the remaining records.
  Future<void> deleteRecord(MaintenanceRecord record) async {
    state = state.where((r) => r != record).toList();
    await repository.writeList(
      'records',
      state.map((r) => r.toJson()).toList(),
    );
  }
}
