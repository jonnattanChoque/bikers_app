import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:bikers_app/core/ui/viewmodels/view_message.dart';
import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:bikers_app/features/profile/domain/entities/vehicle_model.dart';
import 'package:bikers_app/features/profile/domain/usecases/add_bike_usecase.dart';
import 'package:bikers_app/features/profile/domain/usecases/get_bike_usecase.dart';
import 'package:bikers_app/features/profile/domain/usecases/update_username_usecase.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final AddBikeUsecase _addBike;
  final GetBikesUsecase _getBikes;
  final UpdateUsernameUsecase _updateUsername;

  User? user;
  List<VehicleModel> _bikes = [];
  bool _isLoading = false;

  ProfileViewModel({
    required AddBikeUsecase addBike,
    required GetBikesUsecase getBikes,
    required UpdateUsernameUsecase updateUsername,
    required this.user,
  })  : _addBike = addBike,
        _getBikes = getBikes,
        _updateUsername = updateUsername {
    _loadUserData();
    _loadBikes();
  }

  String? nickname;
  List<VehicleModel> get bikes => _bikes;
  bool get isLoading => _isLoading;
  ViewMessage? _message;
  ViewMessage? get message => _message;

  Future<void> _loadUserData() async {
    nickname = user?.name;
    notifyListeners();
  }

  Future<void> _loadBikes() async {
    _setLoading(true);
    try {
      _bikes = await _getBikes();
    } catch (e) {
      // TODO: add error
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addBike(VehicleModel bike) async {
    _setLoading(true);
    try {
      await _addBike(bike);
      _bikes = await _getBikes();
    } catch (e) {
      // TODO: add error
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUsername(String username) async {
    _setLoading(true);
    try {
      await _updateUsername(username);
      showMessage(ViewMessage(
        text: ProfileStrings.updateUsername,
        type: MessageType.success,
        icon: Icons.check_circle,
        flowType: MessageFlowType.profile
      ));
    } catch (e) {
      showMessage(ViewMessage(
        text: 'Error: ${e.toString()}',
        type: MessageType.error,
        icon: Icons.error,
        flowType: MessageFlowType.profile
      ));
    } finally {
      _setLoading(false);
    }
  }

  void showMessage(ViewMessage message) {
    _message = message;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
