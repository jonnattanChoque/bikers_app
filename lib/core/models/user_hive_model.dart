import 'package:hive/hive.dart';
import '../../features/auth/domain/entities/user.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // Conversión desde Domain Entity
  factory UserHiveModel.fromEntity(User user) {
    return UserHiveModel(
      id: user.id,
      name: user.name,
      email: user.email,
    );
  }

  // Conversión a Domain Entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
    );
  }
}
