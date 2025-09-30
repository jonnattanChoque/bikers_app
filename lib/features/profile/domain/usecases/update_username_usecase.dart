import 'package:bikers_app/features/profile/domain/repository/profile_repository.dart';

class UpdateUsernameUsecase {
  final ProfileRepository repository;

  const UpdateUsernameUsecase(this.repository);

  Future<void> call(username) async {
    return await repository.updateUsername(username);
  }
}