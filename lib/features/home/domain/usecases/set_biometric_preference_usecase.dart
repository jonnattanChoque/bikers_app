import 'package:bikers_app/features/home/domain/repositories/home_repository.dart';

class SetBiometricPreferenceUseCase {
  final HomeRepository repository;
  SetBiometricPreferenceUseCase(this.repository);

  Future<void> execute(bool enabled) {
    return repository.setBiometricEnabled(enabled);
  }
}
