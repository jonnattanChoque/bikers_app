
import 'package:bikers_app/features/auth/domain/usecases/recovery_usecase.dart';
import 'package:bikers_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:bikers_app/features/home/domain/usecases/get_biometric_availability_usecase.dart';
import 'package:bikers_app/features/home/domain/usecases/get_biometric_preference_usecase.dart';
import 'package:bikers_app/features/home/domain/usecases/set_biometric_preference_usecase.dart';
import 'package:bikers_app/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:bikers_app/features/splash/domain/usecases/authenticate_with_biometric_usecase.dart';
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
  final recoveryUseCase = RecoveryUseCase(authRepository);

  //Home
  final homeRepository = BiometricRepositoryImpl(
    localUserService: localUserService, 
    biometricService: biometricService
  );

  final getAvailabilityUseCae = GetBiometricAvailabilityUseCase(homeRepository);
  final getPreferenceUseCae = GetBiometricPreferenceUseCase(homeRepository);
  final setPreferenceUseCae = SetBiometricPreferenceUseCase(homeRepository);

   // Splash
  final splashRepository = SplashRepositoryImpl(
    authRepository: authRepository,
    biometricService: biometricService
  );

  final authenticateWithBiometricUseCase = AuthenticateWithBiometricUseCase(splashRepository);
  
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
            recoveryUseCase: recoveryUseCase
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(
            checkLocalUserUseCase: CheckLocalUserUseCase(splashRepository, context.read<AuthViewModel>()), 
            getBiometricAvailabilityUseCase: getAvailabilityUseCae, 
            getBiometricPreferenceUseCase: getPreferenceUseCae, 
            authenticateWithBiometricUseCase: authenticateWithBiometricUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(
            getAvailabilityUseCae: getAvailabilityUseCae, 
            getPreferenceUseCae: getPreferenceUseCae, 
            setPreferenceUseCae: setPreferenceUseCae
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
