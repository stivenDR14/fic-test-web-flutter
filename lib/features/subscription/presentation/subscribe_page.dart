import 'package:flutter/material.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../config/router/app_router.dart';

class SubscribePage extends StatelessWidget {
  const SubscribePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.subscribe,
      child: const Center(
        child: Text('Subscribe Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
