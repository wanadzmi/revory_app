import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revory/core/services/photo_processing_service.dart';
import 'package:revory/features/profile/controllers/profile_details_controller.dart';

/// Edits the profile name and photo and returns the unsaved result.
class ProfileDetailsPage extends StatefulWidget {
  /// Creates an editor initialized from the supplied profile fields.
  const new({required this.nickname, required this.photoPath, super.key});

  /// Display name initially populated in the editor.
  final String nickname;

  /// Initial local image path, or null when the profile has no photo.
  final String? photoPath;
  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final controller = ProfileDetailsController();
  late final name = TextEditingController(text: widget.nickname);
  late String? photoPath = widget.photoPath;
  @override
  void dispose() {
    name.dispose();
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
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Edit profile',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: pickPhoto,
          child: CircleAvatar(
            radius: 42,
            backgroundImage: photoPath == null
                ? null
                : FileImage(File(photoPath!)),
            child: photoPath == null
                ? const Icon(Icons.add_a_photo_outlined)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Nickname'),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () =>
                Navigator.pop(context, controller.create(name.text, photoPath)),
            child: const Text('Save profile'),
          ),
        ),
      ],
    ),
  );
  bool _pickingPhoto = false;

  Future<void> pickPhoto() async {
    if (_pickingPhoto) return;
    _pickingPhoto = true;
    try {
      await _pickPhoto();
    } on PhotoProcessingException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      _pickingPhoto = false;
    }
  }

  Future<void> _pickPhoto() async {
    final photo = await controller.pickPhoto();
    if (photo != null && mounted) setState(() => photoPath = photo);
  }
}
