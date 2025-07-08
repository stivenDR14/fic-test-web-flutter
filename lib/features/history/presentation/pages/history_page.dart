import 'package:flutter/material.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../config/router/app_router.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.history,
      child: const Center(
        child: Text('History Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
