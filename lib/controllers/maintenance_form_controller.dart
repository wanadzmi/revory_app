import 'package:revory/models/maintenance_record.dart';
import 'package:revory/models/vehicle.dart';
import 'package:revory/services/attachment_service.dart';

class MaintenanceFormController {
  MaintenanceFormController({AttachmentService? attachments})
    : attachments = attachments ?? AttachmentService();
  final AttachmentService attachments;
  bool canSave(String service) => service.trim().isNotEmpty;
  Future<String?> pickReceipt() => attachments.pickReceipt();
  int mileageFor(List<Vehicle> vehicles, String id) =>
      vehicles.firstWhere((vehicle) => vehicle.id == id).mileage;
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
