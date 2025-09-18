import 'package:bikers_app/core/i18n/strings.dart';
import 'package:flutter/material.dart';

enum SocialButtonType { login, google, apple, register, recovery }

class SocialButton extends StatelessWidget {
  final SocialButtonType type;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.type,
    required this.onPressed,
  });

  String get _label {
    switch (type) {
      case SocialButtonType.register:
        return RegisterStrings.button;
      case SocialButtonType.login:
        return LoginStrings.loginEmailButton;
      case SocialButtonType.google:
        return LoginStrings.loginWithGoogle;
      case SocialButtonType.apple:
        return LoginStrings.loginWithApple;
      case SocialButtonType.recovery:
        return RecoveryStrings.button;
    }
  }

  Widget get _icon {
    switch (type) {
      case SocialButtonType.register:
        return const Icon(Icons.app_registration, size: 24);
      case SocialButtonType.login:
        return const Icon(Icons.login, size: 24);
      case SocialButtonType.google:
        return Image.asset("assets/icons/google_logo.png", width: 24, height: 24);
      case SocialButtonType.apple:
        return Image.asset("assets/icons/apple_logo.png", width: 24, height: 24);
      case SocialButtonType.recovery:
        return const Icon(Icons.lock_open, size: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: theme.colorScheme.primary.withAlpha(70)),
          elevation: 0,
        ),
        icon: _icon,
        label: Text(_label),
        onPressed: onPressed,
      ),
    );
  }
}
