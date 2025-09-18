import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:bikers_app/core/models/user_hive_model.dart';
import 'package:bikers_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  /// Crear UserModel desde un User de Firebase
  factory UserModel.fromFirebase(fb.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'No Name',
      email: firebaseUser.email ?? '',
    );
  }

  /// Convertir a UserHiveModel para persistencia local
  UserHiveModel toHiveModel() {
    return UserHiveModel(
      id: id,
      name: name,
      email: email,
    );
  }
}
