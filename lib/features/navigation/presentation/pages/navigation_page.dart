import 'package:bikers_app/main/domain/viewmodels/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPage();
}

class _NavigationPage extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    // NO volvemos a crear MainViewModel aquí
    final viewModel = Provider.of<MainViewModel>(context); 

    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            if (!viewModel.hasActiveRoute) {
              viewModel.startRoute();
            } else {
              viewModel.endRoute();
            }
          },
          child: Icon(viewModel.hasActiveRoute ? Icons.close : Icons.add_location),
        ),
      ),
    );
  }
}
