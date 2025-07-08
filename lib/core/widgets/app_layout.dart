import 'package:flutter/material.dart';
import '../../config/router/app_router.dart';
import 'app_bottom_navigation.dart';

// General layout that contains bottom navigator and content area
class AppLayout extends StatelessWidget {
  final Widget child;
  final AppRoute currentRoute;

  const AppLayout({super.key, required this.child, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _getIndexFromRoute(currentRoute),
      ),
    );
  }

  int _getIndexFromRoute(AppRoute route) {
    switch (route) {
      case AppRoute.main:
        return 0;
      case AppRoute.subscribe:
        return 1;
      case AppRoute.history:
        return 2;
    }
  }
}
