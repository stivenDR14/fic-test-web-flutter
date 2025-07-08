import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/di/locator.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/resources/json_reader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JsonReader.initialize();
  await initializeDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fund Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      routerDelegate: AppRouter(),
      routeInformationParser: SimpleRouteInformationParser(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.5),
          ),
          child: child!,
        );
      },
    );
  }
}
