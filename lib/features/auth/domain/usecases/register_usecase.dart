import 'package:bikers_app/core/error/exceptions.dart';
import 'package:bikers_app/core/utils/validators.dart';

import '../entities/user.dart';
import '../entities/auth_credentials.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  String? _error;

  bool _validateFormRegister({required String username, required String email, required String password}) {
    _error = Validators.validateUsername(username) ??  Validators.validateEmail(email) ?? Validators.validatePassword(password);
    return _error == null;
  }

  Future<User?> execute(AuthCredentials credentials, String name) {
    if (!_validateFormRegister(username: name, email: credentials.email, password: credentials.password)) {
       throw InvalidCredentialsException(_error ?? "");
    }
    return repository.register(credentials, name);
  }
}
