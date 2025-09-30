import 'package:bikers_app/features/profile/domain/repository/profile_repository.dart';
import '../entities/vehicle_model.dart';

class GetBikesUsecase {
  final ProfileRepository repository;

  const GetBikesUsecase(this.repository);

  Future<List<VehicleModel>> call() async {
    return await repository.getBikes();
  }
}
