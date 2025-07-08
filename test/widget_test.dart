// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fic_test_flutter/core/widgets/app_layout.dart';
import 'package:fic_test_flutter/config/router/app_router.dart';
import 'package:fic_test_flutter/config/theme/app_theme.dart';

void main() {
  testWidgets('AppLayout renders correctly', (WidgetTester tester) async {
    // Build a simple test with AppLayout
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: AppLayout(
            currentRoute: AppRoute.main,
            child: const Center(child: Text('Test Content')),
          ),
        ),
      ),
    );

    // Verify that the layout components are present
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify navigation items are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Subscribe'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });
}
