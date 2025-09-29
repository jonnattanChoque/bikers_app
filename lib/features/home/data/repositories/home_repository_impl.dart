import 'package:bikers_app/core/services/local_user_service.dart';
import 'package:bikers_app/core/services/biometric_service.dart';
import 'package:bikers_app/features/home/domain/repositories/home_repository.dart';

class BiometricRepositoryImpl implements HomeRepository {
  final LocalUserService _localUserService;
  final BiometricService _biometricService;

  BiometricRepositoryImpl({
    required LocalUserService localUserService,
    required BiometricService biometricService,
  })  : _localUserService = localUserService,
        _biometricService = biometricService;

  @override
  Future<bool> isBiometricAvailable() {
    return _biometricService.isBiometricAvailable();
  }

  @override
  Future<bool> isBiometricEnabled() {
    return _localUserService.isBiometricEnabled();
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) {
    return _localUserService.saveBiometricEnabled(enabled);
  }
}
