import 'package:bikers_app/app.dart';
import 'package:bikers_app/app_routes.dart';
import 'package:bikers_app/features/splash/presentation/viewmodels/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    final splashVM = context.read<SplashViewModel>();
    splashVM.init();
    
    return Consumer<SplashViewModel>(
      builder: (context, auth, _) {
        if (auth.state != SplashState.loading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (auth.state == SplashState.authenticated) {
              AppSession.isBiometricValidated = true; 
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            }
          });
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FlutterLogo(size: 96),
                const SizedBox(height: 20),
                if (auth.state == SplashState.loading)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
