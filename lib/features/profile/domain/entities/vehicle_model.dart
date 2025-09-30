import 'package:bikers_app/features/profile/domain/entities/vehicle_type.dart';

class VehicleModel {
  final String id;
  final VehicleType type;
  final String name;      // Marca (Honda, Yamaha…)
  final String model;     // Modelo (CBR 500…)
  final String plate;     // Placa
  final int cc;           // Cilindraje
  final int year;         // Año de la moto
  final String color;     // Color
  final bool isPrimary;   // Indicador si es la moto principal

  const VehicleModel({
    required this.id,
    required this.type,
    required this.name,
    required this.model,
    required this.plate,
    required this.cc,
    required this.year,
    required this.color,
    required this.isPrimary
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json, String id) {
    return VehicleModel(
      id: id,
      type: VehicleType.fromValue((json['type'] as num?)?.toInt() ?? 0),
      name: json['name'] as String? ?? '',
      model: json['model'] as String? ?? '',
      plate: json['plate'] as String? ?? '',
      cc: (json['cc'] as num?)?.toInt() ?? 0,
      year: (json['year'] as num?)?.toInt() ?? 0,
      color: json['color'] as String? ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false
    );
  }

  /// Convert instance to JSON by Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.value,
      'model': model,
      'plate': plate,
      'cc': cc,
      'year': year,
      'color': color,
      'isPrimary': isPrimary,
    };
  }

  VehicleModel copyWith({
    String? id,
    VehicleType? type,
    String? name,
    String? model,
    String? plate,
    int? cc,
    int? year,
    String? color,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt
  }) {
    return VehicleModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      cc: cc ?? this.cc,
      year: year ?? this.year,
      color: color ?? this.color,
      isPrimary: isPrimary ?? this.isPrimary
    );
  }
}
