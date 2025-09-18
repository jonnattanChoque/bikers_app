import '../entities/user.dart';
import '../repositories/auth_repository.dart';

enum SocialPlatform { google, apple }

class SocialLoginUseCase {
  final AuthRepository repository;

  SocialLoginUseCase(this.repository);

  Future<User?> execute(SocialPlatform platform) async {
    switch (platform) {
      case SocialPlatform.google:
        return await repository.signInWithGoogle();
      case SocialPlatform.apple:
        return await repository.sigInWithApple();
    }
  }
}
