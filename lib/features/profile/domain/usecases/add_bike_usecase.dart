import 'package:bikers_app/features/profile/domain/repository/profile_repository.dart';
import '../entities/vehicle_model.dart';

class AddBikeUsecase {
  final ProfileRepository repository;

  const AddBikeUsecase(this.repository);

  Future<void> call(VehicleModel bike) async {
    await repository.addBike(bike);
  }
}
