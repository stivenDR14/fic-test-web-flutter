import 'package:flutter/material.dart';
import '../../config/router/app_router.dart';
import 'app_responsive_navigation.dart';

// General layout that adapts navigation based on screen size
class AppLayout extends StatelessWidget {
  final Widget child;
  final AppRoute currentRoute;

  const AppLayout({super.key, required this.child, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile layout: bottom navigation
        if (constraints.maxWidth < 768) {
          return _buildMobileLayout();
        }
        // Desktop/Tablet layout: header navigation
        else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: AppResponsiveNavigation(currentRoute: currentRoute),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Column(
        children: [
          // Header navigation
          AppResponsiveNavigation(currentRoute: currentRoute),
          // Content area
          Expanded(
            child: SafeArea(
              top: false, // Header already provides top spacing
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
