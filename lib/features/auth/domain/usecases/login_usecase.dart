import '../entities/user.dart';
import '../entities/auth_credentials.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User?> execute(AuthCredentials credentials) {
    return repository.login(credentials);
  }
}
