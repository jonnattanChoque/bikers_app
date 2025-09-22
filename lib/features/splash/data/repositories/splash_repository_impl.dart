import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:bikers_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:bikers_app/features/auth/domain/repositories/auth_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final AuthRepository authRepository;

  SplashRepositoryImpl(this.authRepository);

  @override
  Future<User?> getLocalUser() async {
    return await authRepository.getLocalUser();
  }
}
