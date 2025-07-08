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
  group('AppLayout', () {
    testWidgets(
      'renders mobile layout with bottom navigation on small screens',
      (WidgetTester tester) async {
        // Set small screen size to trigger mobile layout
        await tester.binding.setSurfaceSize(const Size(400, 800));

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

        // Verify content is present
        expect(find.text('Test Content'), findsOneWidget);

        // Verify bottom navigation is present on mobile
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify navigation items are present
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Subscribe'), findsOneWidget);
        expect(find.text('History'), findsOneWidget);

        // Reset surface size for other tests
        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets(
      'renders desktop layout with header navigation on large screens',
      (WidgetTester tester) async {
        // Set large screen size to trigger desktop layout
        await tester.binding.setSurfaceSize(const Size(1024, 768));

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

        // Verify content is present
        expect(find.text('Test Content'), findsOneWidget);

        // Verify app title is present in header
        expect(find.text('Gestor BTG'), findsOneWidget);

        // Verify navigation items are present in header
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Subscribe'), findsOneWidget);
        expect(find.text('History'), findsOneWidget);

        // Verify bottom navigation is NOT present on desktop
        expect(find.byType(BottomNavigationBar), findsNothing);

        // Reset surface size for other tests
        await tester.binding.setSurfaceSize(null);
      },
    );
  });
}
