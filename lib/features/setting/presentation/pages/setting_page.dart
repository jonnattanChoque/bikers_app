import 'package:bikers_app/app_routes.dart';
import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/provider/language_provider.dart';
import 'package:bikers_app/core/provider/theme_provider.dart';
import 'package:bikers_app/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:bikers_app/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback? onLanguageChanged;

  const SettingsPage({super.key, this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final language = context.watch<LanguageProvider>();
    final theme = context.watch<ThemeProvider>();
    final homeVM = context.watch<HomeViewModel>();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          value: ThemeMode.dark == theme.themeMode,
          onChanged: (_) => theme.toggleTheme(),
          title: Text(SettingsStrings.toggleTheme),
          secondary: ThemeMode.dark == theme.themeMode
              ? const Icon(Icons.nights_stay, color: Colors.grey)
              : const Icon(Icons.wb_sunny, color: Colors.amber),
        ),
        if (homeVM.hasBiometricHardware) ...[
          SwitchListTile(
            value: homeVM.biometricEnabled,
            onChanged: (bool value) async => await homeVM.toggleBiometric(value),
            title: Text(SettingsStrings.toggleBiometric),
            secondary: const Icon(Icons.fingerprint, color: Colors.blueGrey),
          ),
        ],
        SwitchListTile(
          title: const Text('English'),
          value: language.isEnglish,
          onChanged: (value) async {
            language.toggleLanguage();
            showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            await Future.delayed(const Duration(seconds: 1));

            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
            onLanguageChanged?.call();
          },
          secondary: const Icon(Icons.language),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text(SettingsStrings.logout),
          onTap: () async {
            await auth.logout();
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
            }
          },
        )
      ],
    );
  }
}
