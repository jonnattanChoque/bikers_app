import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:bikers_app/core/services/firebase_auth_service.dart';
import 'package:bikers_app/features/auth/domain/entities/user.dart';
import '../entities/auth_credentials.dart';

abstract class AuthRepository {
  Future<User?> login(AuthCredentials credentials);
  Future<User?> register(AuthCredentials credentials, String name);
  Future<User?> signInWithGoogle();
  Future<User?> sigInWithApple();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService service;

  AuthRepositoryImpl({required this.service});

  @override
  Future<User> login(AuthCredentials credentials) async {
    final fb.User? fbUser = await service.loginWithEmail(
      credentials.email,
      credentials.password,
    );

    if (fbUser == null) {
      throw Exception('No se pudo iniciar sesión');
    }

    // Mapeo a tu entidad de dominio
    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      name: fbUser.displayName ?? '',
    );
  }

  @override
  Future<User> signInWithGoogle() async {
    print("tres");
    final fb.User? fbUser = await service.signInWithGoogle();

    if (fbUser == null) {
      throw Exception('No se pudo iniciar sesión con Google');
    }

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      name: fbUser.displayName ?? '',
    );
  }

  @override
  Future<User> sigInWithApple() async {
    final fb.User? fbUser = await service.signInWithApple();

    if (fbUser == null) {
      throw Exception('No se pudo iniciar sesión con Apple');
    }

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      name: fbUser.displayName ?? '',
    );
  }

  @override
  Future<User> register(AuthCredentials credentials, username) async {
    final fb.User? fbUser = await service.registerWithEmail(
      credentials.email,
      credentials.password,
      username
    );

    if (fbUser == null) {
      throw Exception('No se pudo registrar el usuario');
    }

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      name: fbUser.displayName ?? '',
    );
  }

  @override
  Future<void> logout() async {
    await service.signOut();
  }
}
