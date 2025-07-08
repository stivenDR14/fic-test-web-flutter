import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/balance_header.dart';
import '../widgets/funds_cards.dart';
import '../../providers/fund_provider.dart';
import '../../../../shared/providers/balance_provider.dart';

// Funds page that displays all available funds
class FundsPage extends ConsumerStatefulWidget {
  const FundsPage({super.key});

  @override
  ConsumerState<FundsPage> createState() => _FundsPageState();
}

class _FundsPageState extends ConsumerState<FundsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fundProvider.notifier).loadFunds();
      ref.read(balanceProvider.notifier).loadBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundsState = ref.watch(fundProvider);
    final balance = ref.watch(balanceProvider);

    return AppLayout(
      currentRoute: AppRoute.main,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BalanceHeader(title: 'Fondos Disponibles', balance: balance),
              Expanded(child: _buildContent(fundsState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(fundsState) {
    if (fundsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fundsState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar fondos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fundsState.errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(fundProvider.notifier).loadFunds();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (fundsState.funds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay fondos disponibles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return FundsCards(funds: fundsState.funds);
  }
}
