import 'package:bikers_app/core/models/user_hive_model.dart';
import 'package:bikers_app/core/services/firebase_auth_service.dart';
import 'package:bikers_app/core/services/local_user_service.dart';
import 'package:bikers_app/core/services/biometric_service.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalUserService localService;
  final BiometricService biometricService;
  final FirebaseAuthService firebaseAuthService;

  AuthRepositoryImpl({
    required this.localService,
    required this.biometricService, 
    required this.firebaseAuthService,
  });

  @override
  Future<User?> getLocalUser() async {
    var userLocal = await localService.getUser();
    return userLocal?.toEntity();
  }

  @override
  Future<User> login(AuthCredentials credentials) async {
    try {
      final firebaseUser = await firebaseAuthService.loginWithEmail(
        credentials.email,
        credentials.password,
      );

      if (firebaseUser == null) throw Exception('login-failed');
      final userModel = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'No Name',
        email: firebaseUser.email ?? '',
      );
      final userHive = UserHiveModel(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
      );
      await localService.saveUser(userHive);
      return userModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User> register(AuthCredentials credentials, String name) async {
    try {
      final firebaseUser = await firebaseAuthService.registerWithEmail(
        name,
        credentials.email,
        credentials.password,
      );

      if (firebaseUser == null) throw Exception('register-failed');
      
      final userModel = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? name,
        email: firebaseUser.email ?? credentials.email,
      );
      final userHive = UserHiveModel(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
      );
      await localService.saveUser(userHive);

      return userModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> recoveryPassword(String email) async {
    try {
      await firebaseAuthService.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuthService.signOut();
      await localService.clearUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithGoogle();
      if (firebaseUser == null) throw Exception('login-google-failed');

      final userModel = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'No Name',
        email: firebaseUser.email ?? '',
      );

      await localService.saveUser(
        UserHiveModel(
          id: userModel.id,
          name: userModel.name,
          email: userModel.email,
        ),
      );

      return userModel;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<User> sigInWithApple() async {
    try {
      final firebaseUser = await firebaseAuthService.signInWithApple();
      if (firebaseUser == null) throw Exception('login-apple-failed');

      final userModel = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'No Name',
        email: firebaseUser.email ?? '',
      );

      await localService.saveUser(
        UserHiveModel(
          id: userModel.id,
          name: userModel.name,
          email: userModel.email,
        ),
      );

      return userModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
