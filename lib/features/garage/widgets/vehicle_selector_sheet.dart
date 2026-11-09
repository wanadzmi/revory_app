import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/features/garage/controllers/garage_controller.dart';

/// Lists garage vehicles and selects one before closing the bottom sheet.
class VehicleSelectorSheet extends ConsumerWidget {
  /// Creates the garage vehicle selector.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garage = ref.watch(garageControllerProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose vehicle',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: garage.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = garage.vehicles[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: vehicle.color,
                      backgroundImage: vehicle.photoPath == null
                          ? null
                          : FileImage(File(vehicle.photoPath!)),
                      child: vehicle.photoPath == null
                          ? const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    title: Text(vehicle.name),
                    subtitle: Text(vehicle.registration),
                    trailing: index == garage.selected
                        ? const Icon(Icons.check_circle)
                        : null,
                    onTap: () async {
                      await ref
                          .read(garageControllerProvider.notifier)
                          .selectVehicle(index);
                      if (context.mounted) Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
