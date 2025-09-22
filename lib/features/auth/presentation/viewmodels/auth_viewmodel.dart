import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:bikers_app/core/ui/viewmodels/view_message.dart';
import 'package:bikers_app/core/utils/validators.dart';
import 'package:bikers_app/features/auth/domain/usecases/social_login_usercase.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/entities/user.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SocialLoginUseCase googleLoginUseCase;
  final SocialLoginUseCase appleLoginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleLoginUseCase,
    required this.appleLoginUseCase,
    required this.logoutUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  ViewMessage? _message;
  ViewMessage? get message => _message;

  bool obscurePassword = false;
  String? _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _validateFormLogin({required String email, required String password}) {
    _error = Validators.validateEmail(email) ?? Validators.validatePassword(password);
    showMessage(ViewMessage(
        text: _error ?? "",
        type: MessageType.error,
        icon: Icons.error,
        flowType: MessageFlowType.login
      ));
    notifyListeners();
    return _error == null;
  }

  bool _validateFormRegister({required String email, required String password, String? username}) {
    _error = Validators.validateUsername(username ?? "") ?? Validators.validateEmail(email) ?? Validators.validatePassword(password);
    showMessage(ViewMessage(
        text: _error ?? "",
        type: MessageType.error,
        icon: Icons.error,
        flowType: MessageFlowType.register
      ));
    notifyListeners();
    return _error == null;
  }

  void showMessage(ViewMessage message) {
    _message = message;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
  }

  Future<void> togglePassword() async {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // Login con email
  Future<void> login(String email, String password) async {
    if (!_validateFormLogin(email: email, password: password)) return;
    _setLoading(true);
    try {
      final loggedUser = await loginUseCase.execute(
        AuthCredentials(email: email, password: password),
      );
      _user = loggedUser;
      showMessage(ViewMessage(
        text: LoginStrings.loginSuccess,
        type: MessageType.success,
        icon: Icons.check_circle,
        flowType: MessageFlowType.login
      ));
      notifyListeners();
    } catch (e) {
      showMessage(ViewMessage(
        text: 'Error: ${e.toString()}',
        type: MessageType.error,
        icon: Icons.error,
        flowType: MessageFlowType.login
      ));
    } finally {
      _setLoading(false);
    }
  }

  // Registro con email
  Future<void> register(String email, String password, String username) async {
    if (!_validateFormRegister(email: email, password: password, username: username)) return;
    _setLoading(true);
    try {
      final registerUser = await registerUseCase.execute(
        AuthCredentials(email: email, password: password), username
      );
      _user = registerUser;
      showMessage(ViewMessage(
        text: RegisterStrings.successEmail,
        type: MessageType.success,
        icon: Icons.check_circle,
        flowType: MessageFlowType.register
      ));
      notifyListeners();
    } catch (e) {
      showMessage(ViewMessage(
        text: 'Error: ${e.toString()}',
        type: MessageType.error,
        icon: Icons.error,
        flowType: MessageFlowType.register
      ));
    } finally {
      _setLoading(false);
    }
  }

  // Login con Google
  Future<void> loginWithGoogle() async {
    _setLoading(true);
    try {
      final loggedUser = await googleLoginUseCase.execute(SocialPlatform.google);
      _user = loggedUser;
      showMessage(ViewMessage(
        text: LoginStrings.loginSuccess,
        type: MessageType.success,
        icon: Icons.check_circle,
        flowType: MessageFlowType.login
      ));
      notifyListeners();
    } catch (e) {
      showMessage(ViewMessage(
        text: 'Error: ${e.toString()}',
        type: MessageType.error,
        icon: Icons.error,
      ));
    } finally {
      _setLoading(false);
    }
  }

  // Login con Apple
  Future<void> loginWithApple() async {
    _setLoading(true);
    try {
      final loggedUser = await appleLoginUseCase.execute(SocialPlatform.apple);
      _user = loggedUser;
      showMessage(ViewMessage(
        text: LoginStrings.loginSuccess,
        type: MessageType.success,
        icon: Icons.check_circle,
        flowType: MessageFlowType.login
      ));
      notifyListeners();
    } catch (e) {
      showMessage(ViewMessage(
        text: 'Error: ${e.toString()}',
        type: MessageType.error,
        icon: Icons.error,
      ));
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await logoutUseCase.execute();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
