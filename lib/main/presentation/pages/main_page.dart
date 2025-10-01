import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/ui/widgets/custom_bottom_sheet.dart';
import 'package:bikers_app/features/navigation/presentation/pages/navigation_page.dart';
import 'package:bikers_app/features/profile/presentation/pages/profile_page.dart';
import 'package:bikers_app/features/setting/presentation/pages/setting_page.dart';
import 'package:bikers_app/main/domain/viewmodels/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/collapsible_bottom_nav.dart';

class MainPage extends StatefulWidget {

  final VoidCallback? onLanguageChanged;
  const MainPage({super.key, this.onLanguageChanged});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    // HomePage(),
    NavigationPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  void _onNavItemTap(int index) {
    if (index == 2) {
      showCustomBottomSheet(context, SettingsPage(onLanguageChanged: widget.onLanguageChanged), SettingsStrings.title);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: _pages[_currentIndex],
                ),
                CollapsibleBottomNav(
                  hasActiveRoute: viewModel.hasActiveRoute,
                  isCollapsed: viewModel.isCollapsed,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _onNavItemTap(index);
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
