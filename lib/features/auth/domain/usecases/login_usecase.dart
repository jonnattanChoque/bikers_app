import 'package:bikers_app/core/error/exceptions.dart';
import 'package:bikers_app/core/utils/validators.dart';

import '../entities/user.dart';
import '../entities/auth_credentials.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {

  final AuthRepository repository;
  LoginUseCase(this.repository);
  
  String? _error;

  bool _validateFormLogin({required String email, required String password}) {
    _error = Validators.validateEmail(email) ?? Validators.validatePassword(password);
    return _error == null;
  }

  Future<User?> execute(AuthCredentials credentials) {
    if (!_validateFormLogin(email: credentials.email, password: credentials.password)) {
       throw InvalidCredentialsException(_error ?? "");
    }
    return repository.login(credentials);
  }
}
