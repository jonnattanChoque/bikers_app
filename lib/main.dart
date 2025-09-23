
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'app.dart';

// Core
import 'core/core.dart';

// Features
import 'features/auth/auth.dart';
import 'features/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  
  final firebaseService = FirebaseAuthService();
  final localUserService = LocalUserService();
  final biometricService = BiometricService();
  
  // Auth
  final authRepository = AuthRepositoryImpl(
    localService: localUserService,
    biometricService: biometricService, 
    firebaseAuthService: firebaseService,
  );

  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final logoutUseCase = LogoutUseCase(authRepository);
  final socialUserCase = SocialLoginUseCase(authRepository);

   // Splash
  final splashRepository = SplashRepositoryImpl(authRepository);
  
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
          create: (context) => SplashViewModel(
            checkLocalUserUseCase: CheckLocalUserUseCase(splashRepository, context.read<AuthViewModel>()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}
