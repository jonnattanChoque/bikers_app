// ignore_for_file: deprecated_member_use

import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/main/domain/viewmodels/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollapsibleBottomNav extends StatelessWidget {
  final bool hasActiveRoute;
  final bool isCollapsed;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onToggle;

  const CollapsibleBottomNav({
    required this.hasActiveRoute,
    required this.isCollapsed,
    required this.currentIndex,
    required this.onTap,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final toggleProvider = Provider.of<MainViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // BottomNavigation completo
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: 0,
          left: (!toggleProvider.hasActiveRoute || !toggleProvider.isCollapsed) ? 0 : screenWidth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: screenWidth,
            height: 60,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.map), label: MainStrings.navigationTitle),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: MainStrings.profileTitle),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: MainStrings.settingsTitle),
              ],
            ),
          ),
        ),

        // Botón de flecha para expandir
        if (toggleProvider.hasActiveRoute)
        Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: toggleProvider.isCollapsed ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.rectangle,
                ),
                child: Icon(Icons.arrow_circle_left_outlined, color: Colors.black.withOpacity(0.5), size: 30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
