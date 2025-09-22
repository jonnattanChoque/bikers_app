
import 'package:bikers_app/core/provider/theme_provider.dart';
import 'package:bikers_app/features/auth/domain/usecases/social_login_usercase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bikers_app/core/services/firebase_auth_service.dart';
import 'app.dart';
import 'core/models/user_hive_model.dart';
import 'core/services/local_user_service.dart';
import 'features/auth/data/services/firebase_auth_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  
  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  
  final firebaseService = FirebaseAuthService();
  final localUserService = LocalUserService();
  final biometricService = BiometricService();
  
  final authRepository = AuthRepositoryImpl(
    localService: localUserService,
    biometricService: biometricService, 
    firebaseAuthService: firebaseService,
  );

  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final logoutUseCase = LogoutUseCase(authRepository);
  final socialUserCase = SocialLoginUseCase(authRepository);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase, 
            googleLoginUseCase: socialUserCase, 
            appleLoginUseCase: socialUserCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(), // ✅ agregamos ThemeProvider
        )
      ],
      child: const MyApp(), // App.dart maneja el tema Dark/Light
    ),
  );
}
