import 'package:bikers_app/features/navigation/presentation/pages/navigation_page.dart';
import 'package:bikers_app/features/profile/presentation/pages/profile_page.dart';
import 'package:bikers_app/features/setting/presentation/pages/setting_page.dart';
import 'package:bikers_app/main/domain/viewmodels/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/collapsible_bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    // HomePage(),
    NavigationPage(),
    SettingsPage(),
    ProfilePage(),
  ];


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                // Mapa de fondo
                Container(
                  color: Colors.grey[200],
                  child: _pages[_currentIndex],
                ),

                // BottomNavigation colapsable
                CollapsibleBottomNav(
                  hasActiveRoute: viewModel.hasActiveRoute,
                  isCollapsed: viewModel.isCollapsed,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  onToggle: viewModel.toggleCollapse,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
