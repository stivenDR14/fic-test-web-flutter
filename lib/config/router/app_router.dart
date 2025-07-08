import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/main_page.dart';
import '../../features/subscription/presentation/subscribe_page.dart';
import '../../features/history/presentation/pages/history_page.dart';

// Simple router configuration
enum AppRoute { main, subscribe, history }

class AppRouter extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  static final AppRouter _instance = AppRouter._internal();
  factory AppRouter() => _instance;
  AppRouter._internal();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRoute _currentRoute = AppRoute.main;

  @override
  AppRoute get currentConfiguration => _currentRoute;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [_buildPage(_currentRoute)],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        _currentRoute = AppRoute.main;
        notifyListeners();
        return true;
      },
    );
  }

  Page _buildPage(AppRoute route) {
    Widget page;
    String name;

    switch (route) {
      case AppRoute.main:
        page = const MainPage();
        name = '/';
        break;
      case AppRoute.subscribe:
        page = const SubscribePage();
        name = '/subscribe';
        break;
      case AppRoute.history:
        page = const HistoryPage();
        name = '/history';
        break;
    }

    return MaterialPage(key: ValueKey(name), name: name, child: page);
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _currentRoute = configuration;
    notifyListeners();
  }

  // Simple navigation methods
  static void navigateToMain() => _instance._navigate(AppRoute.main);
  static void navigateToSubscribe() => _instance._navigate(AppRoute.subscribe);
  static void navigateToHistory() => _instance._navigate(AppRoute.history);

  void _navigate(AppRoute route) {
    _currentRoute = route;
    notifyListeners();
  }
}

// Simple route information parser
class SimpleRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final path = routeInformation.uri.path;
    switch (path) {
      case '/subscribe':
        return AppRoute.subscribe;
      case '/history':
        return AppRoute.history;
      default:
        return AppRoute.main;
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    switch (configuration) {
      case AppRoute.main:
        return RouteInformation(uri: Uri.parse('/'));
      case AppRoute.subscribe:
        return RouteInformation(uri: Uri.parse('/subscribe'));
      case AppRoute.history:
        return RouteInformation(uri: Uri.parse('/history'));
    }
  }
}
