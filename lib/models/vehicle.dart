import 'package:flutter/material.dart';

/// Vehicle identity, recorded mileage, image, and next-service targets.
class Vehicle {
  /// Creates a vehicle, defaulting its ID to the registration when omitted.
  new(
    this.name,
    this.year,
    this.registration,
    this.mileage,
    this.color, {
    String? id,
    this.nextServiceMileage,
    this.nextServiceDate,
    this.nextServiceLabel = 'Next service',
    this.photoPath,
  }) : id = id ?? registration;

  /// Restores a vehicle and optional reminder fields from stored JSON.
  factory fromJson(Map<String, dynamic> json) => Vehicle(
    json['name'] as String,
    json['year'] as String,
    json['registration'] as String,
    json['mileage'] as int,
    Color(json['color'] as int),
    id: json['id'] as String?,
    nextServiceMileage: json['nextServiceMileage'] as int?,
    nextServiceDate: json['nextServiceDate'] == null
        ? null
        : DateTime.parse(json['nextServiceDate'] as String),
    nextServiceLabel: json['nextServiceLabel'] as String? ?? 'Next service',
    photoPath: json['photoPath'] as String?,
  );

  /// Vehicle model displayed throughout the garage.
  String name;

  /// Vehicle year as entered by the user.
  String year;

  /// Registration displayed in vehicle lists.
  String registration;

  /// Latest recorded odometer reading, in kilometres.
  int mileage;

  /// Fallback accent used when displaying the vehicle.
  final Color color;

  /// Stable relationship key assigned when the vehicle is created.
  final String id;

  /// Optional manually entered next-service odometer target.
  int? nextServiceMileage;

  /// Optional date on which the next service is due.
  DateTime? nextServiceDate;

  /// Description of the next planned service.
  String nextServiceLabel;

  /// Local vehicle image path, or null when no image is selected.
  String? photoPath;

  /// Serializes vehicle and reminder fields for local persistence.
  Map<String, dynamic> toJson() => {
    'name': name,
    'year': year,
    'registration': registration,
    'mileage': mileage,
    'color': color.toARGB32(),
    'id': id,
    'nextServiceMileage': nextServiceMileage,
    'nextServiceDate': nextServiceDate?.toIso8601String(),
    'nextServiceLabel': nextServiceLabel,
    'photoPath': photoPath,
  };
}
