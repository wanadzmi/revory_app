import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/repositories/local_app_repository.dart';

final garageControllerProvider =
    NotifierProvider<GarageController, GarageState>(GarageController.new);

class GarageState {
  const GarageState(this.vehicles, [this.selected = 0]);
  final List<Vehicle> vehicles;
  final int selected;
  Vehicle get vehicle => vehicles[selected];
}

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
  LocalAppRepository get repository => ref.read(localAppRepositoryProvider);
  Future<void> restore() async {
    final saved = await repository.readList('vehicles');
    if (saved == null || saved.isEmpty) return;
    final vehicles = saved.map(Vehicle.fromJson).toList();
    final selected =
        (await repository.preferences).getInt('selectedVehicle') ?? 0;
    state = GarageState(vehicles, selected.clamp(0, vehicles.length - 1));
  }

  Future<void> selectVehicle(int index) async {
    state = GarageState(state.vehicles, index);
    await repository.writeInt('selectedVehicle', index);
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    final vehicles = [...state.vehicles, vehicle];
    state = GarageState(vehicles, vehicles.length - 1);
    await saveVehicle();
  }

  Future<void> saveVehicle() async {
    state = GarageState([...state.vehicles], state.selected);
    await repository.writeList(
      'vehicles',
      state.vehicles.map((v) => v.toJson()).toList(),
    );
    await repository.writeInt('selectedVehicle', state.selected);
  }

  Future<void> updateMileage(String vehicleId, int mileage) async {
    final index = state.vehicles.indexWhere((v) => v.id == vehicleId);
    if (index < 0) return;
    state.vehicles[index].mileage = mileage;
    await saveVehicle();
  }

  Future<void> deleteVehicle(int index) async {
    if (state.vehicles.length <= 1) return;
    final vehicles = [...state.vehicles]..removeAt(index);
    var selected = state.selected;
    if (index < selected) selected--;
    state = GarageState(vehicles, selected.clamp(0, vehicles.length - 1));
    await saveVehicle();
  }
}
