import 'package:flutter/material.dart';
import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/features/home/presentation/widgets/side_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(HomeStrings.title),
      ),
      drawer: const SideMenu(),
      body: const Center(child: Text('Contenido del Home')),
    );
  }
}