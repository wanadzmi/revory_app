import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revory/controllers/vehicle_form_controller.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/pages/car_camera_guide.dart';

class EditVehicle extends StatefulWidget {
  const new({required this.vehicle, super.key});
  final Vehicle vehicle;
  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  final form = VehicleFormController();
  late final name = TextEditingController(text: widget.vehicle.name);
  late final plate = TextEditingController(text: widget.vehicle.registration);
  late final year = TextEditingController(text: widget.vehicle.year);
  late final mileage = TextEditingController(
    text: widget.vehicle.mileage.toString(),
  );
  late String? photoPath = widget.vehicle.photoPath;
  @override
  void dispose() {
    name.dispose();
    plate.dispose();
    year.dispose();
    mileage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      0,
      20,
      MediaQuery.of(context).viewInsets.bottom + 28,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit vehicle',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Vehicle model'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: plate,
                  decoration: const InputDecoration(
                    labelText: 'Registration number',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: year,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Year'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mileage,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Current mileage',
              suffixText: 'km',
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: choosePhoto,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              height: 74,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  if (photoPath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.file(
                        File(photoPath!),
                        width: 54,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const Icon(Icons.add_a_photo_outlined),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      photoPath == null
                          ? 'Add vehicle photo (optional)'
                          : 'Replace vehicle photo',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                form.update(
                  widget.vehicle,
                  name: name.text,
                  year: year.text,
                  registration: plate.text,
                  mileage: mileage.text,
                  photoPath: photoPath,
                );
                Navigator.pop(context, true);
              },
              child: const Text('Save changes'),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> choosePhoto() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Vehicle photo',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a photo'),
                subtitle: const Text('Use the car framing guide'),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from library'),
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == 'gallery') {
      final photo = await form.pickPhoto();
      if (photo != null && mounted) setState(() => photoPath = photo);
    } else if (source == 'camera' && mounted) {
      final photo = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const CarCameraGuide()),
      );
      if (photo != null && mounted) setState(() => photoPath = photo);
    }
  }
}
