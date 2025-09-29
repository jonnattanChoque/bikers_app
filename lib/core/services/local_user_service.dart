import 'package:hive/hive.dart';
import '../models/user_hive_model.dart';

class LocalUserService {
  static const String _boxName = 'userBox';
  static const String _userKey = 'currentUser';
  static const String _biometricKey = 'biometric_enabled';

  /// Guarda el usuario en Hive
  Future<void> saveUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    await box.put(_userKey, user);
  }

  /// Obtiene el usuario guardado, si existe
  Future<UserHiveModel?> getUser() async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    return box.get(_userKey);
  }

  /// Elimina el usuario guardado (logout)
  Future<void> clearUser() async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    await box.delete(_userKey);
  }

  /// Verifica si hay un usuario guardado (sesión activa)
  Future<bool> hasUser() async {
    final box = await Hive.openBox<UserHiveModel>(_boxName);
    return box.containsKey(_userKey);
  }

  Future<void> saveBiometricEnabled(bool enabled) async {
    final box = await Hive.openBox('settings');
    await box.put(_biometricKey, enabled);
  }

  Future<bool> isBiometricEnabled() async {
    final box = await Hive.openBox('settings');
    return box.get(_biometricKey, defaultValue: false);
  }
}
