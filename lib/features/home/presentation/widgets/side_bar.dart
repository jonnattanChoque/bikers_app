import 'package:bikers_app/app_routes.dart';
import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/provider/theme_provider.dart';
import 'package:bikers_app/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final theme = context.watch<ThemeProvider>();
    final String username = auth.user?.name ?? 'User';

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${HomeStrings.title} $username',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Cambiar tema
          SwitchListTile(
            value: ThemeMode.dark == theme.themeMode,
            onChanged: (_) => theme.toggleTheme(),
            title: Text(HomeStrings.sideToggleTheme),
            secondary: ThemeMode.dark == theme.themeMode
                ? const Icon(Icons.nights_stay, color: Colors.grey)
                : const Icon(Icons.wb_sunny, color: Colors.amber),
          ),

          const Spacer(),

          // Logout
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(HomeStrings.sideLogout),
            onTap: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
              }
            },
          ),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }
}
