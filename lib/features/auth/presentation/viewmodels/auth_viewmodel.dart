import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:bikers_app/core/ui/viewmodels/view_message.dart';
import 'package:bikers_app/features/auth/domain/usecases/recovery_usecase.dart';
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
  final RecoveryUseCase recoveryUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleLoginUseCase,
    required this.appleLoginUseCase,
    required this.logoutUseCase,
    required this.recoveryUseCase
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  ViewMessage? _message;
  ViewMessage? get message => _message;

  bool obscurePassword = false;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(User? value) {
    _user = value;
    notifyListeners();
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
    _setLoading(true);
    try {
      final loggedUser = await loginUseCase.execute(
        AuthCredentials(email: email, password: password),
      );
      setUser(loggedUser);
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
    _setLoading(true);
    try {
      final registerUser = await registerUseCase.execute(
        AuthCredentials(email: email, password: password), username
      );
      setUser(registerUser);
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
      setUser(loggedUser);
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

  // Login con Apple
  Future<void> loginWithApple() async {
    _setLoading(true);
    try {
      final loggedUser = await appleLoginUseCase.execute(SocialPlatform.apple);
      setUser(loggedUser);
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
  Future<void> forgetPassword(String email) async {
    _setLoading(true);
    try {
      await recoveryUseCase.execute(email);
      showMessage(ViewMessage(
        text: RecoveryStrings.successEmail,
        type: MessageType.success,
        icon: Icons.check_circle,
        flowType: MessageFlowType.forget
      ));
      notifyListeners();
    } catch (e) {
      showMessage(ViewMessage(
        text: 'Error: ${e.toString()}',
        type: MessageType.error,
        icon: Icons.error,
        flowType: MessageFlowType.forget
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
