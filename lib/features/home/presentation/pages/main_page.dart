import 'package:flutter/material.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';

// Main page with responsive design and excellent UX
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: const Center(child: Text('Main Page'))),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }
}
