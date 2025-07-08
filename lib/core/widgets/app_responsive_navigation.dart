import 'package:flutter/material.dart';
import '../../config/router/app_router.dart';
import '../../config/theme/app_colors.dart';

// Responsive navigation that adapts to screen size
class AppResponsiveNavigation extends StatelessWidget {
  final AppRoute currentRoute;

  const AppResponsiveNavigation({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: Use bottom navigation (width < 768px)
        if (constraints.maxWidth < 768) {
          return _buildBottomNavigation();
        }
        // Desktop/Tablet: Use header navigation (width >= 768px)
        else {
          return _buildHeaderNavigation(context);
        }
      },
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _getIndexFromRoute(currentRoute),
        onTap: _onNavigationTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.tabUnselected,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Nuevo fondo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderNavigation(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // App logo/title
          Text(
            'Gestor BTG',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          // Navigation items
          Row(
            children: [
              _buildHeaderNavItem(
                context,
                'Home',
                Icons.home,
                AppRoute.main,
                currentRoute == AppRoute.main,
              ),
              const SizedBox(width: 32),
              _buildHeaderNavItem(
                context,
                'Subscribe',
                Icons.add_circle_outline,
                AppRoute.subscribe,
                currentRoute == AppRoute.subscribe,
              ),
              const SizedBox(width: 32),
              _buildHeaderNavItem(
                context,
                'History',
                Icons.history,
                AppRoute.history,
                currentRoute == AppRoute.history,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderNavItem(
    BuildContext context,
    String label,
    IconData icon,
    AppRoute route,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => _navigateToRoute(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration:
            isSelected
                ? BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                )
                : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.tabUnselected,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.tabUnselected,
              ),
            ),
          ],
        ),
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

  void _onNavigationTap(int index) {
    switch (index) {
      case 0:
        _navigateToRoute(AppRoute.main);
        break;
      case 1:
        _navigateToRoute(AppRoute.subscribe);
        break;
      case 2:
        _navigateToRoute(AppRoute.history);
        break;
    }
  }

  void _navigateToRoute(AppRoute route) {
    if (route == currentRoute) return;

    switch (route) {
      case AppRoute.main:
        AppRouter.navigateToMain();
        break;
      case AppRoute.subscribe:
        AppRouter.navigateToSubscribe();
        break;
      case AppRoute.history:
        AppRouter.navigateToHistory();
        break;
    }
  }
}
