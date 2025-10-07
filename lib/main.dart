
import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/provider/language_provider.dart';
import 'package:bikers_app/core/services/firebase_user_service.dart';
import 'package:bikers_app/features/auth/domain/usecases/recovery_usecase.dart';
import 'package:bikers_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:bikers_app/features/home/domain/usecases/get_biometric_availability_usecase.dart';
import 'package:bikers_app/features/home/domain/usecases/get_biometric_preference_usecase.dart';
import 'package:bikers_app/features/home/domain/usecases/set_biometric_preference_usecase.dart';
import 'package:bikers_app/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:bikers_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:bikers_app/features/profile/domain/usecases/add_bike_usecase.dart';
import 'package:bikers_app/features/profile/domain/usecases/get_bike_usecase.dart';
import 'package:bikers_app/features/profile/domain/usecases/update_username_usecase.dart';
import 'package:bikers_app/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:bikers_app/features/splash/domain/usecases/authenticate_with_biometric_usecase.dart';
import 'package:bikers_app/main/domain/viewmodels/main_viewmodel.dart';
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
  final firebaseUserService = FirebaseUserService();
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
    biometricService: biometricService, 
    firebaseService: firebaseService
  );

  final authenticateWithBiometricUseCase = AuthenticateWithBiometricUseCase(splashRepository);

  // Profile
  final profileRepository = ProfileRepositoryImpl(
    firebaseUserService: firebaseUserService, 
    localUserservice: localUserService
  );
  final updateUsername = UpdateUsernameUsecase(profileRepository);
  final addBikeUseCase = AddBikeUsecase(profileRepository);
  final getBikesUseCase = GetBikesUsecase(profileRepository);

  final languageProvider = LanguageProvider();
  Global.setLanguageVM(languageProvider);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:(context) => MainViewModel(),
        ),
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
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
        ChangeNotifierProxyProvider<AuthViewModel, ProfileViewModel>(
          create: (_) => ProfileViewModel(
            updateUsername: updateUsername,
            addBike: addBikeUseCase, 
            getBikes: getBikesUseCase,
            user: null
          ),
          update: (context, authVM, _) {
            return ProfileViewModel(
              updateUsername: updateUsername,
              addBike: addBikeUseCase, 
              getBikes: getBikesUseCase,
              user: authVM.user
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}
