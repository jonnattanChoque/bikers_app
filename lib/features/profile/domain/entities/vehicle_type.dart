enum VehicleType {
  car(1),
  bike(2);

  final int value;
  const VehicleType(this.value);

  // Convert from int to enum
  static VehicleType fromValue(int value) {
    return VehicleType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VehicleType.bike, // default fallback
    );
  }
}