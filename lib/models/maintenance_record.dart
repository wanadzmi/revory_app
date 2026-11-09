class MaintenanceRecord {
  MaintenanceRecord(
    this.title,
    this.workshop,
    this.date,
    this.mileage,
    this.cost,
    this.receiptName, [
    this.vehicleId = '',
  ]);
  final String title;
  final String workshop;
  final DateTime date;
  final int mileage;
  final double cost;
  final String? receiptName;
  String vehicleId;
  bool get hasReceipt => receiptName != null;

  Map<String, dynamic> toJson() => {
    'title': title,
    'workshop': workshop,
    'date': date.toIso8601String(),
    'mileage': mileage,
    'cost': cost,
    'receiptName': receiptName,
    'vehicleId': vehicleId,
  };
  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) =>
      MaintenanceRecord(
        json['title'] as String,
        json['workshop'] as String,
        DateTime.parse(json['date'] as String),
        json['mileage'] as int,
        (json['cost'] as num).toDouble(),
        json['receiptName'] as String?,
        json['vehicleId'] as String? ?? '',
      );
}
