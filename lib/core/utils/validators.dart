import 'package:bikers_app/core/i18n/strings.dart';

class Validators {
  static String? validateEmail(String email) {
    if (email.isEmpty) return LoginStrings.errorEmptyEmail;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) return LoginStrings.errorInvalidEmail;
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return LoginStrings.errorEmptyPassword;
    if (password.length < 6) return LoginStrings.errorShortPassword;
    return null;
  }

  static String? validateUsername(String username) {
    if (username.isEmpty) return RegisterStrings.errorInvalidUsername;
    if (username.length < 3) return RegisterStrings.errorShortUsername;
    return null;
  }
}
