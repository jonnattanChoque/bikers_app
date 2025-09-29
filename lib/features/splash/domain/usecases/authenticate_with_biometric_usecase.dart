import 'package:bikers_app/features/splash/domain/repositories/splash_repository.dart';

class AuthenticateWithBiometricUseCase {
  final SplashRepository repository;
  AuthenticateWithBiometricUseCase(this.repository);

  Future<bool> execute() async {
    return repository.authenticate();
  }
}