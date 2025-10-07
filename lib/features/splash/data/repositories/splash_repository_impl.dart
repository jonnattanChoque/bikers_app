import 'package:bikers_app/core/core.dart';
import 'package:bikers_app/core/services/biometric_service.dart';
import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:bikers_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:bikers_app/features/auth/domain/repositories/auth_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final AuthRepository _authRepository;
  final BiometricService _biometricService;
  final FirebaseAuthService _firebaseService;

  SplashRepositoryImpl({
    required AuthRepository authRepository,
    required BiometricService biometricService,
    required FirebaseAuthService firebaseService,
  })  : 
      _authRepository = authRepository,
      _biometricService = biometricService, 
      _firebaseService = firebaseService;

  @override
  Future<User?> execute() async {
    final user = await _authRepository.getLocalUser();
    final isValid = await _firebaseService.validateUserSession(user?.id ?? "");
    return isValid ? user : null;
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
