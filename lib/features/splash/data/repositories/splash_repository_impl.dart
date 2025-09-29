import 'package:bikers_app/core/services/biometric_service.dart';
import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:bikers_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:bikers_app/features/auth/domain/repositories/auth_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final AuthRepository _authRepository;
  final BiometricService _biometricService;

  SplashRepositoryImpl({
    required AuthRepository authRepository,
    required BiometricService biometricService,
  })  : 
      _authRepository = authRepository,
      _biometricService = biometricService;

  @override
  Future<User?> execute() async {
    return await _authRepository.getLocalUser();
  }
  
  @override
  Future<bool> authenticate() async {
    final canCheck = await _biometricService.isBiometricAvailable();

    if (!canCheck) {
      return false;
    }

    final didAuthenticate = await _biometricService.authenticate();
    return didAuthenticate;
  }
}
