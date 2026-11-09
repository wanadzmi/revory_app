import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/controllers/garage_controller.dart';
import 'package:revory/controllers/profile_controller.dart';
import 'package:revory/models/profile_details.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/pages/profile_details_page.dart';
import 'package:revory/pages/settings_page.dart';
import 'package:revory/utils/formatters.dart';
import 'package:revory/widgets/garage/add_vehicle_sheet.dart';
import 'package:revory/widgets/garage/edit_vehicle_sheet.dart';
import 'package:revory/widgets/section_header.dart';
import 'package:revory/widgets/slide_actions.dart';

/// Displays the user profile, garage management, and settings access.
class ProfilePage extends ConsumerWidget {
  /// Creates the profile and garage management page.
  const new({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final vehicles = ref.watch(garageControllerProvider).vehicles;
    final garage = ref.read(garageControllerProvider.notifier);
    final nickname = profile.nickname;
    final profilePhotoPath = profile.photoPath;
    final select = garage.selectVehicle;
    final add = garage.addVehicle;
    final onEditVehicle = garage.saveVehicle;
    final onDeleteVehicle = garage.deleteVehicle;
    final onUpdateProfile = ref
        .read(profileControllerProvider.notifier)
        .updateProfile;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      children: [
        Row(
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
              ),
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
            ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            onTap: () async {
              final result = await showModalBottomSheet<ProfileDetails>(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (_) => ProfileDetailsPage(
                  nickname: nickname,
                  photoPath: profilePhotoPath,
                ),
              );
              if (result != null) {
                await onUpdateProfile(result.nickname, result.photoPath);
              }
            },
            contentPadding: const EdgeInsets.all(14),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: profilePhotoPath == null
                  ? null
                  : FileImage(File(profilePhotoPath)),
              child: profilePhotoPath == null ? const Icon(Icons.person) : null,
            ),
            title: Text(
              nickname,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text('Tap to edit your profile'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 26),
        const SectionHeader('MY GARAGE', 'Manage'),
        const SizedBox(height: 8),
        ...List.generate(
          vehicles.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SlideActions(
              itemKey: ValueKey(vehicles[i]),
              itemLabel: vehicles[i].name,
              canDelete: vehicles.length > 1,
              onDeleted: () => onDeleteVehicle(i),
              onEdit: () async {
                final saved = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => EditVehicle(vehicle: vehicles[i]),
                );
                if (saved == true) await onEditVehicle();
              },
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  onTap: () => select(i),
                  leading: CircleAvatar(
                    backgroundColor: vehicles[i].color,
                    backgroundImage: vehicles[i].photoPath == null
                        ? null
                        : FileImage(File(vehicles[i].photoPath!)),
                    child: vehicles[i].photoPath == null
                        ? const Icon(Icons.directions_car, color: Colors.white)
                        : null,
                  ),
                  title: Text(vehicles[i].name),
                  subtitle: Text(
                    '${vehicles[i].registration} · '
                    '${numText(vehicles[i].mileage)} km',
                  ),
                  trailing: const Icon(Icons.chevron_left),
                ),
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            final v = await showModalBottomSheet<Vehicle>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => const AddVehicle(),
            );
            if (v != null) await add(v);
          },
          icon: const Icon(Icons.add),
          label: const Text('Add another vehicle'),
        ),
      ],
    );
  }
}
