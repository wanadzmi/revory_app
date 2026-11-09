import 'package:flutter/material.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/services/attachment_service.dart';

/// Validates vehicle forms and normalizes vehicle fields.
class VehicleFormController {
  /// Creates vehicle-form logic with an optional attachment override.
  new({AttachmentService? attachments})
    : attachments = attachments ?? AttachmentService();

  /// Platform attachment dependency used to select vehicle photos.
  final AttachmentService attachments;

  /// Whether the vehicle model contains non-whitespace characters.
  bool canSave(String name) => name.trim().isNotEmpty;

  /// Selects a vehicle image path, or returns null when cancelled.
  Future<String?> pickPhoto() => attachments.pickPhoto();

  /// Creates an unsaved vehicle, or returns null when its name is blank.
  Vehicle? create({
    required String name,
    required String year,
    required String registration,
    required String mileage,
    String? photoPath,
  }) {
    if (!canSave(name)) return null;
    return Vehicle(
      name.trim(),
      year.trim().isEmpty ? '—' : year.trim(),
      registration.trim().isEmpty ? 'No plate' : registration.trim(),
      int.tryParse(mileage) ?? 0,
      const Color(0xff8a5d42),
      photoPath: photoPath,
    );
  }

  /// Applies edited fields, preserving existing values for blank input.
  void update(
    Vehicle vehicle, {
    required String name,
    required String year,
    required String registration,
    required String mileage,
    String? photoPath,
  }) {
    vehicle.name = name.trim().isEmpty ? vehicle.name : name.trim();
    vehicle.registration = registration.trim().isEmpty
        ? vehicle.registration
        : registration.trim();
    vehicle.year = year.trim().isEmpty ? vehicle.year : year.trim();
    vehicle.mileage = int.tryParse(mileage) ?? vehicle.mileage;
    vehicle.photoPath = photoPath;
  }
}
