import 'package:bikers_app/features/home/domain/repositories/home_repository.dart';

class GetBiometricPreferenceUseCase {
  final HomeRepository repository;
  GetBiometricPreferenceUseCase(this.repository);

  Future<bool> execute() {
    return repository.isBiometricEnabled();
  }
}
