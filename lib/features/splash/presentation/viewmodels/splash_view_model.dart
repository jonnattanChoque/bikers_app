import 'package:bikers_app/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:bikers_app/features/splash/domain/usecases/check_local_user_usecase.dart';

enum SplashState { loading, authenticated, unauthenticated }

class SplashViewModel extends ChangeNotifier {
  final CheckLocalUserUseCase checkLocalUserUseCase;

  SplashState _state = SplashState.loading;
  SplashState get state => _state;

  SplashViewModel({required this.checkLocalUserUseCase});

  Future<void> init() async {
    final User? user = await checkLocalUserUseCase();
    if (user != null) {
      _state = SplashState.authenticated;
    } else {
      _state = SplashState.unauthenticated;
    }
    notifyListeners();
  }
}
