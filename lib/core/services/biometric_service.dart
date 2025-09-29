import 'package:local_auth/local_auth.dart';

class BiometricService {

  static final LocalAuthentication _biometric = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheck = await _biometric.canCheckBiometrics;
      final bool isSupported = await _biometric.isDeviceSupported();
      return canCheck && isSupported;
    } catch (e) {
      return false;
    }
  }

  // Biometric Authentication
  Future<bool> authenticate() async {
    try {
      return await _biometric.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}