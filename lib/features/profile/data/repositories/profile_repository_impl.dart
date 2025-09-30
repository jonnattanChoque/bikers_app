import 'package:bikers_app/core/core.dart';
import 'package:bikers_app/core/services/firebase_user_service.dart';
import 'package:bikers_app/features/auth/data/models/user_model.dart';
import 'package:bikers_app/features/profile/domain/entities/vehicle_model.dart';
import 'package:bikers_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final LocalUserService localService;
  final FirebaseUserService _firebaseUserService;

  ProfileRepositoryImpl({
    required LocalUserService localUserservice,
    required FirebaseUserService firebaseUserService
  })  : localService = localUserservice,
      _firebaseUserService = firebaseUserService;

  @override
  Future<void> addBike(VehicleModel bike) async {
    await _firebaseUserService.addBike(bike.toJson());
  }

  @override
  Future<List<VehicleModel>> getBikes() async {
    final bikesData = await _firebaseUserService.getBikes();
    return bikesData.map((data) {
      return VehicleModel.fromJson(data, data['id'] as String);
    }).toList();
  }
  
  @override
  Future<void> updateUsername(String username) async { 
    await _firebaseUserService.updateUsername(username);
    final userModel = await _firebaseUserService.getUser();
    if (userModel == null) throw Exception('login-failed');

    final userHive = UserHiveModel(
      id: userModel.uid,
      name: username,
      email: userModel.email ?? "",
    );
    await localService.saveUser(userHive);
  }
}
