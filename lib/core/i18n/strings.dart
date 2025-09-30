import 'dart:ui' as ui;

class Global {
  static String get currentLanguage {
    try {
      // ignore: deprecated_member_use
      return ui.window.locale.languageCode;
    } catch (_) {
      // fallback
      return 'es';
    }
  }
}

class Strings {

  static const Map<String, Map<String, String>> _values = {
    "en": {
      "login_email": "Email",
      "login_password": "Password",
      "login_email_button": "Login with Email",
      "login_google_button": "Login with Google",
      "login_apple_button": "Login with Apple",
      "login_error_empty_email": "Email cannot be empty",
      "login_error_invalid_email": "Invalid email format",
      "login_error_empty_password": "Password cannot be empty",
      "login_error_password_short": "Password must be at least 6 characters",
      "login_email_not_found": "Invalid credentials",
      "login_email_not_verified": "Please verify your email",
      "login_error_already_email": "Email already in use",
      "cancelled_by_user": "Cancelled",
      "register_link": "Don't have an account? Sign up",
      "recovery_link": "Forgot your password?",
      "login_success": "Login successful",
      "login_biometrics": "Use your fingerprint or FaceID to log in",
      "login_biometrics_button": "Login with Biometrics",
      "BiometricNotAvailable": "You must grant biometric permissions",

      // Register Page
      "register_title": "Register",
      "register_button": "Sign Up",
      "register_username": "Username",
      "register_success_email": "Registration successful. Verify your email before logging in.",
      "register_error_empty_username": "Username cannot be empty",
      "register_error_username_short": "Username must be at least 3 characters",

      // Recovery password
      "login_recovery_title": "Recover Password",
      "login_success_email": "Password reset email sent if exist email. Check your spam folder.",
      "login_recovery_button": "Send email",

      // Home Page
      "home_title": "Home",
      "home_toggle_theme": "Toggle Theme",
      "home_logout": "Logout",
      "home_side_biometric": "Use biometrics",

      // Profile Page
      "profile_bottom_title": "Profile 👤",
      "profile_title": "Perfil",
      "profile_update_username": "Nombre actulalizado",
    },
    "es": {
      // Login Page
      "login_email": "Correo electrónico",
      "login_password": "Contraseña",
      "login_email_button": "Iniciar sesión",
      "login_google_button": "Iniciar con Google",
      "login_apple_button": "Iniciar con Apple",
      "login_error_empty_email": "El correo no puede estar vacío",
      "login_error_invalid_email": "El correo no es válido",
      "login_error_empty_password": "La contraseña no puede estar vacia",
      "login_error_password_short": "La contraseña debe tener al menos 6 caracteres",
      "login_email_not_found": "Credenciales inválidas",
      "login_email_not_verified": "Por favor verifica tu correo",
      "login_error_already_email": "El correo ya está en uso",
      "cancelled_by_user": "Cancelado",
      "register_link": "¿No tienes cuenta? Regístrate",
      "recovery_link": "¿Has olvidado tu contraseña?",
      "login_success": "Inicio de sesión exitoso",
      "login_biometrics": "Usa tu huella o FaceID para iniciar sesión",
      "login_biometrics_button": "Iniciar con biometría",
      "BiometricNotAvailable": "Debes dar permisos de biometría",

      // Register Page
      "register_title": "Registro",
      "register_button": "Registrarse",
      "register_username": "Nombre de usuario",
      "register_success_email": "Registro exitoso. Verifica tu correo antes de iniciar sesión.",
      "register_error_empty_username": "El nombre de usuario no puede estar vacío",
      "register_error_username_short": "El nombre de usuario debe tener al menos 3 caracteres",

      // Recovery password
      "login_recovery_title": "Recuperar contraseña",
      "login_success_email": "Email de recuperación enviado si el correo existe. Revisa tu spam.",
      "login_recovery_button": "Enviar correo",

      // Home Page
      "home_title": "Inicio",
      "home_toggle_theme": "Cambiar tema",
      "home_logout": "Cerrar sesión",
      "home_side_biometric": "Usar biometría",

      // Profile Page
      "profile_bottom_title": "perfil 👤",
      "profile_title": "Profile",
      "profile_update_username": "Username updated",
    }
  };

  static String of(String key) {
    final locale = Global.currentLanguage;
    return _values[locale]?[key] ?? key;
  }
}

class LoginStrings {
  static String get emailRequired => Strings.of("login_email");
  static String get passwordRequired => Strings.of("login_password");
  static String get loginEmailButton => Strings.of("login_email_button");
  static String get loginWithGoogle => Strings.of("login_google_button");
  static String get loginWithApple => Strings.of("login_apple_button");
  static String get errorEmptyEmail => Strings.of("login_error_empty_email");
  static String get errorAlreadyEmail => Strings.of("login_error_already_email");
  static String get errorInvalidEmail => Strings.of("login_error_invalid_email");
  static String get errorEmptyPassword => Strings.of("login_error_empty_password");
  static String get errorShortPassword => Strings.of("login_error_password_short");
  static String get canceledByUser => Strings.of("cancelled_by_user");
  static String get emailNotVerified => Strings.of("login_email_not_verified");
  static String get emailNotFound => Strings.of("login_email_not_found");
  static String get passwordWrong => Strings.of("login_password_wrong");
  static String get registerLink => Strings.of("register_link");
  static String get recoveryLink => Strings.of("recovery_link");
  static String get loginSuccess => Strings.of("login_success");
  static String get biometrics => Strings.of("login_biometrics");
  static String get biometricsButton => Strings.of("login_biometrics_button");
  static String get biometricEmpty => Strings.of("login_biometrics_empty");
}

class RegisterStrings {
  static String get userName => Strings.of("register_username");
  static String get title => Strings.of("register_title");
  static String get button => Strings.of("register_button");
  static String get successEmail => Strings.of("register_success_email");
  static String get errorInvalidUsername => Strings.of("register_error_empty_username");
  static String get errorShortUsername => Strings.of("register_error_username_short");
}

class RecoveryStrings {
  static String get title => Strings.of("login_recovery_title");
  static String get button => Strings.of("login_recovery_button");
  static String get successEmail => Strings.of("login_success_email");
}

class HomeStrings {
  static String get title => Strings.of("home_title");
  static String get sideToggleTheme => Strings.of("home_toggle_theme");
  static String get sideLogout => Strings.of("home_logout");
  static String get sideBiometric => Strings.of("home_side_biometric");
}

class ProfileStrings {
  static String get bottomTitle => Strings.of("profile_bottom_title");
  static String get title => Strings.of("profile_title");
  static String get updateUsername => Strings.of("profile_update_username");
}

