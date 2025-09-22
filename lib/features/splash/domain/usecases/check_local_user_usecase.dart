import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:bikers_app/features/splash/domain/repositories/splash_repository.dart';

class CheckLocalUserUseCase {
  final SplashRepository repository;

  CheckLocalUserUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getLocalUser();
  }
}
