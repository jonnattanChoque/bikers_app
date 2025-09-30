import 'package:bikers_app/features/profile/domain/entities/vehicle_model.dart';

abstract class ProfileRepository {
  Future<void> addBike(VehicleModel bike);
  Future<List<VehicleModel>> getBikes();
  Future<void> updateUsername(String username);
}
