import 'package:bikers_app/core/error/exceptions.dart';
import 'package:bikers_app/core/utils/validators.dart';
import '../repositories/auth_repository.dart';

class RecoveryUseCase {
  final AuthRepository repository;

  RecoveryUseCase(this.repository);
  String? _error;

  bool _validateFormRecovery({required String email}) {
    _error = Validators.validateEmail(email);
    return _error == null;
  }

  Future<void> execute(String email) {
    if (!_validateFormRecovery(email: email)) {
       throw InvalidCredentialsException(_error ?? "");
    }
    return repository.recoveryPassword(email);
  }
}
