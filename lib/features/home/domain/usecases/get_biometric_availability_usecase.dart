import 'package:bikers_app/features/home/domain/repositories/home_repository.dart';

class GetBiometricAvailabilityUseCase {
  final HomeRepository repository;
  GetBiometricAvailabilityUseCase(this.repository);

  Future<bool> execute() {
    return repository.isBiometricAvailable();
  }
}
