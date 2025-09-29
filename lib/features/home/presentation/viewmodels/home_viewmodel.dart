import 'package:flutter/material.dart';
import 'package:bikers_app/features/home/domain/usecases/get_biometric_availability_usecase.dart';
import 'package:bikers_app/features/home/domain/usecases/get_biometric_preference_usecase.dart';
import 'package:bikers_app/features/home/domain/usecases/set_biometric_preference_usecase.dart';

class HomeViewModel extends ChangeNotifier {
  final GetBiometricAvailabilityUseCase _getAvailability;
  final GetBiometricPreferenceUseCase _getPreference;
  final SetBiometricPreferenceUseCase _setPreference;

  bool _hasBiometricHardware = false;
  bool _biometricEnabled = false;
  bool _loadingBiometric = false;

  HomeViewModel({
    required GetBiometricAvailabilityUseCase getAvailabilityUseCae,
    required GetBiometricPreferenceUseCase getPreferenceUseCae,
    required SetBiometricPreferenceUseCase setPreferenceUseCae,
  })  : _getAvailability = getAvailabilityUseCae,
        _getPreference = getPreferenceUseCae,
        _setPreference = setPreferenceUseCae {
    _initBiometric();
  }

  bool get hasBiometricHardware => _hasBiometricHardware;
  bool get biometricEnabled => _biometricEnabled;
  bool get loadingBiometric => _loadingBiometric;

  Future<void> _initBiometric() async {
    _loadingBiometric = true;
    notifyListeners();

    try {
      final bool available = await _getAvailability.execute();
      final bool enabled = await _getPreference.execute();

      _hasBiometricHardware = available;
      _biometricEnabled = available && enabled;
    } catch (_) {
      _hasBiometricHardware = false;
      _biometricEnabled = false;
    } finally {
      _loadingBiometric = false;
      notifyListeners();
    }
  }

  Future<void> toggleBiometric(bool value) async {
    if (!_hasBiometricHardware) return;

    _loadingBiometric = true;
    notifyListeners();

    try {
      await _setPreference.execute(value);
      _biometricEnabled = value;
    } catch (_) {
    } finally {
      _loadingBiometric = false;
      notifyListeners();
    }
  }

  Future<void> reloadBiometricState() => _initBiometric();
}
