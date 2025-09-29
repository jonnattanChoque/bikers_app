import 'package:bikers_app/features/auth/domain/entities/user.dart';
import '../entities/auth_credentials.dart';

abstract class AuthRepository {
  Future<User?> getLocalUser();
  Future<User?> login(AuthCredentials credentials);
  Future<User?> register(AuthCredentials credentials, String name);
  Future<User?> signInWithGoogle();
  Future<User?> sigInWithApple();
  Future<void> recoveryPassword(String email);
  Future<void> logout();
}