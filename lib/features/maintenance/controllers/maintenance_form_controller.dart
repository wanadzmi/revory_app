import 'package:revory/core/services/attachment_service.dart';
import 'package:revory/features/garage/models/vehicle.dart';
import 'package:revory/features/maintenance/models/maintenance_record.dart';

/// Validates maintenance input and creates unsaved maintenance records.
class MaintenanceFormController {
  /// Creates form logic with an optional attachment-service override.
  new({AttachmentService? attachments})
    : attachments = attachments ?? AttachmentService();

  /// Platform attachment dependency used to select receipts.
  final AttachmentService attachments;

  /// Whether the service name contains non-whitespace characters.
  bool canSave(String service) => service.trim().isNotEmpty;

  /// Selects a receipt and returns its name, or null when cancelled.
  Future<String?> pickReceipt() => attachments.pickReceipt();

  /// Finds the recorded mileage for an existing vehicle ID.
  int mileageFor(List<Vehicle> vehicles, String id) =>
      vehicles.firstWhere((vehicle) => vehicle.id == id).mileage;

  /// Creates a record from input; returns null for an empty service name.
  MaintenanceRecord? create({
    required String service,
    required String workshop,
    required String mileage,
    required int fallbackMileage,
    required String cost,
    required String vehicleId,
    String? receiptName,
  }) {
    if (!canSave(service)) return null;
    return MaintenanceRecord(
      service.trim(),
      workshop.trim().isEmpty ? 'No workshop added' : workshop.trim(),
      DateTime.now(),
      int.tryParse(mileage.replaceAll(',', '')) ?? fallbackMileage,
      double.tryParse(cost) ?? 0,
      receiptName,
      vehicleId,
    );
  }
}
