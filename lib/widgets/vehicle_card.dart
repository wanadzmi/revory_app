import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/utils/formatters.dart';

/// Displays the selected vehicle photo, identity, and recorded mileage.
class VehicleCard extends StatelessWidget {
  /// Creates a vehicle summary card with a tap interaction.
  const new({required this.vehicle, required this.onTap, super.key});

  /// Vehicle whose details and image are displayed.
  final Vehicle vehicle;

  /// Invoked when the user taps the vehicle summary.
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(22),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 215,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (vehicle.photoPath != null)
              Image.file(
                File(vehicle.photoPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallback(),
              )
            else
              _fallback(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x10000000), Color(0xD9000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'MY GARAGE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.expand_more, color: Colors.white),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    vehicle.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.registration}  •  ${vehicle.year}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .86),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${numText(vehicle.mileage)} km',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget _fallback() => ColoredBox(
    color: vehicle.color,
    child: const Center(
      child: Icon(
        Icons.directions_car_filled,
        color: Colors.white38,
        size: 108,
      ),
    ),
  );
}
