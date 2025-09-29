import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:bikers_app/features/home/home.dart';
import 'package:bikers_app/features/splash/domain/usecases/authenticate_with_biometric_usecase.dart';
import 'package:bikers_app/features/splash/domain/usecases/check_local_user_usecase.dart';
import 'package:flutter/material.dart';

enum SplashState { loading, authenticated, unauthenticated }

class SplashViewModel extends ChangeNotifier {
  final CheckLocalUserUseCase checkLocalUserUseCase;
  final GetBiometricAvailabilityUseCase getBiometricAvailabilityUseCase;
  final GetBiometricPreferenceUseCase getBiometricPreferenceUseCase;
  final AuthenticateWithBiometricUseCase authenticateWithBiometricUseCase;

  SplashState _state = SplashState.loading;
  SplashState get state => _state;

  SplashViewModel({
    required this.checkLocalUserUseCase,
    required this.getBiometricAvailabilityUseCase,
    required this.getBiometricPreferenceUseCase,
    required this.authenticateWithBiometricUseCase
  });

  Future<void> init() async {
    final User? user = await checkLocalUserUseCase();
    if (user != null) {
      _state = SplashState.authenticated;
    } else {
      _state = SplashState.unauthenticated;
    }

    final hasHardware = await getBiometricAvailabilityUseCase.execute();
    final prefEnabled = await getBiometricPreferenceUseCase.execute();

    if (hasHardware && prefEnabled) {
      final success = await authenticateWithBiometricUseCase.execute();
      if (!success && user != null) {
        _state = SplashState.unauthenticated;
      }
    }

    notifyListeners();
  }
}
