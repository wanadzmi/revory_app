import 'package:flutter/material.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/services/attachment_service.dart';

class VehicleFormController {
  new({AttachmentService? attachments})
    : attachments = attachments ?? AttachmentService();
  final AttachmentService attachments;
  bool canSave(String name) => name.trim().isNotEmpty;
  Future<String?> pickPhoto() => attachments.pickPhoto();
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
