import '../entities/user.dart';
import '../entities/auth_credentials.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User?> execute(AuthCredentials credentials, String name) {
    return repository.register(credentials, name);
  }
}
