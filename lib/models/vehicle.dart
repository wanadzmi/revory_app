import 'package:flutter/material.dart';

class Vehicle {
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

  String name;
  String year;
  String registration;
  int mileage;
  final Color color;
  final String id;
  int? nextServiceMileage;
  DateTime? nextServiceDate;
  String nextServiceLabel;
  String? photoPath;

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
