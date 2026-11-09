/// A vehicle service entry with mileage, cost, and an optional receipt.
class MaintenanceRecord {
  /// Creates a maintenance record; an empty vehicle ID denotes legacy data.
  new(
    this.title,
    this.workshop,
    this.date,
    this.mileage,
    this.cost,
    this.receiptName, [
    this.vehicleId = '',
  ]);

  /// Restores a record from its persisted JSON representation.
  factory fromJson(Map<String, dynamic> json) => MaintenanceRecord(
    json['title'] as String,
    json['workshop'] as String,
    DateTime.parse(json['date'] as String),
    json['mileage'] as int,
    (json['cost'] as num).toDouble(),
    json['receiptName'] as String?,
    json['vehicleId'] as String? ?? '',
  );

  /// Service or replacement-part description.
  final String title;

  /// Workshop name or the display fallback when none was entered.
  final String workshop;

  /// Date on which the service was recorded.
  final DateTime date;

  /// Odometer reading at the time of service, in kilometres.
  final int mileage;

  /// Total maintenance cost in the app's displayed currency.
  final double cost;

  /// Selected receipt filename, or null when none is attached.
  final String? receiptName;

  /// ID of the serviced vehicle; empty for legacy unassigned records.
  String vehicleId;

  /// Whether the record has an associated receipt filename.
  bool get hasReceipt => receiptName != null;

  /// Serializes the record using the existing local-storage schema.
  Map<String, dynamic> toJson() => {
    'title': title,
    'workshop': workshop,
    'date': date.toIso8601String(),
    'mileage': mileage,
    'cost': cost,
    'receiptName': receiptName,
    'vehicleId': vehicleId,
  };
}
