import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/core/repositories/local_app_repository.dart';
import 'package:revory/features/garage/models/vehicle.dart';

/// Provides the garage state and vehicle operations.
final garageControllerProvider =
    NotifierProvider<GarageController, GarageState>(GarageController.new);

/// Vehicles and the currently selected vehicle index.
class GarageState {
  /// Creates garage state with the first vehicle selected by default.
  const new(this.vehicles, [this.selected = 0]);

  /// Vehicles currently available in the garage.
  final List<Vehicle> vehicles;

  /// Zero-based index of the selected vehicle.
  final int selected;

  /// Currently selected vehicle; the garage must contain at least one vehicle.
  Vehicle get vehicle => vehicles[selected];
}

/// Manages garage selection, vehicle changes, and garage persistence.
class GarageController extends Notifier<GarageState> {
  @override
  GarageState build() => GarageState([
    Vehicle(
      'Mazda CX-5',
      '2021',
      'VBT 4821',
      42180,
      const Color(0xff254b44),
      nextServiceMileage: 45000,
      nextServiceDate: DateTime(2026, 12, 12),
      nextServiceLabel: 'Oil change',
    ),
    Vehicle('Honda City', '2018', 'WXY 1937', 87540, const Color(0xff5369a8)),
  ]);

  /// Storage dependency used for garage data.
  LocalAppRepository get repository => ref.read(localAppRepositoryProvider);

  /// Restores saved vehicles and clamps the selection to a valid index.
  Future<void> restore() async {
    final saved = await repository.readList('vehicles');
    if (saved == null || saved.isEmpty) return;
    final vehicles = saved.map(Vehicle.fromJson).toList();
    final selected =
        (await repository.preferences).getInt('selectedVehicle') ?? 0;
    state = GarageState(vehicles, selected.clamp(0, vehicles.length - 1));
  }

  /// Selects and persists the vehicle at the supplied index.
  Future<void> selectVehicle(int index) async {
    state = GarageState(state.vehicles, index);
    await repository.writeInt('selectedVehicle', index);
  }

  /// Adds a vehicle and selects it before persisting the garage.
  Future<void> addVehicle(Vehicle vehicle) async {
    final vehicles = [...state.vehicles, vehicle];
    state = GarageState(vehicles, vehicles.length - 1);
    await saveVehicle();
  }

  /// Emits updated garage state and saves vehicles and selection.
  Future<void> saveVehicle() async {
    state = GarageState([...state.vehicles], state.selected);
    await repository.writeList(
      'vehicles',
      state.vehicles.map((v) => v.toJson()).toList(),
    );
    await repository.writeInt('selectedVehicle', state.selected);
  }

  /// Updates and persists mileage for a matching ID; ignores unknown IDs.
  Future<void> updateMileage(String vehicleId, int mileage) async {
    final index = state.vehicles.indexWhere((v) => v.id == vehicleId);
    if (index < 0) return;
    state.vehicles[index].mileage = mileage;
    await saveVehicle();
  }

  /// Removes a vehicle and repairs selection; preserves the last vehicle.
  Future<void> deleteVehicle(int index) async {
    if (state.vehicles.length <= 1) return;
    final vehicles = [...state.vehicles]..removeAt(index);
    var selected = state.selected;
    if (index < selected) selected--;
    state = GarageState(vehicles, selected.clamp(0, vehicles.length - 1));
    await saveVehicle();
  }
}
