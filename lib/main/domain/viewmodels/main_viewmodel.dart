import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  bool _hasActiveRoute = false;
  bool _isCollapsed = true;

  bool get hasActiveRoute => _hasActiveRoute;
  bool get isCollapsed => _isCollapsed;

  void startRoute() {
    _hasActiveRoute = true;
    _isCollapsed = true; // iniciar colapsada
    notifyListeners();
  }

  void endRoute() {
    _hasActiveRoute = false;
    _isCollapsed = true;
    notifyListeners();
  }

  void toggleCollapse() {
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }
}
