import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revory/controllers/vehicle_form_controller.dart';
import 'package:revory/pages/car_camera_guide.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});
  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final form = VehicleFormController();
  final name = TextEditingController();
  final plate = TextEditingController();
  final year = TextEditingController();
  final mileage = TextEditingController();
  String? photoPath;
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
            'Add a vehicle',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: name,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Vehicle model',
              hintText: 'e.g. Proton X50',
            ),
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
                          : 'Vehicle photo selected',
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
              onPressed: !form.canSave(name.text)
                  ? null
                  : () {
                      final vehicle = form.create(
                        name: name.text,
                        year: year.text,
                        registration: plate.text,
                        mileage: mileage.text,
                        photoPath: photoPath,
                      );
                      if (vehicle != null) Navigator.pop(context, vehicle);
                    },
              child: const Text('Add vehicle'),
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
