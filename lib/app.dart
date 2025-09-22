import 'package:bikers_app/core/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikers_app/core/provider/theme_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'BikerApp',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.useSystemTheme
              ? ThemeMode.system
              : themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
}

