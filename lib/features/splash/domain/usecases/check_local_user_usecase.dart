import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:bikers_app/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:bikers_app/features/splash/domain/repositories/splash_repository.dart';

class CheckLocalUserUseCase {
  final SplashRepository repository;
  final AuthViewModel authViewModel;

  CheckLocalUserUseCase(this.repository, this.authViewModel);

  Future<User?> call() async {
    try {
      final user = await repository.execute();
      authViewModel.setUser(user);
      return user;
    } catch (e) {
      authViewModel.setUser(null);
      return null;
    }
  }
}
