import 'package:bikers_app/features/auth/domain/entities/user.dart';

abstract class SplashRepository {
  Future<User?> getLocalUser();
}
