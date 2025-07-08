import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/entities/fund.dart';
import '../../../../shared/domain/entities/transaction.dart';
import '../../../../shared/providers/balance_provider.dart';
import '../../../../shared/providers/transaction_provider.dart';
import '../../../../shared/providers/selected_fund_provider.dart';
import '../../../../config/router/app_router.dart';
import '../../../../shared/data/services/transaction_service.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/utils/helpers.dart';

// Enhanced fund cards with investment status and cancellation functionality
class FundsCards extends ConsumerWidget {
  final List<Fund> funds;

  const FundsCards({super.key, required this.funds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: funds.length,
      itemBuilder: (context, index) {
        final fund = funds[index];
        return _buildFundCard(context, ref, fund);
      },
    );
  }

  Widget _buildFundCard(BuildContext context, WidgetRef ref, Fund fund) {
    final balance = ref.watch(balanceProvider);
    final isInvested = balance.isInvestedIn(fund.id.toString());
    final investedAmount = balance.getInvestmentAmount(fund.id.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(context, fund),
              const SizedBox(height: 16),
              _buildFundDetails(context, fund),
              if (isInvested) ...[
                const SizedBox(height: 16),
                _buildInvestmentInfo(context, ref, investedAmount),
              ],
              const SizedBox(height: 20),
              _buildActionButtons(context, ref, fund, isInvested),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, Fund fund) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            fund.categoria,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Icon(Icons.account_balance, color: AppColors.primary, size: 24),
      ],
    );
  }

  Widget _buildFundDetails(BuildContext context, Fund fund) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppHelpers.formatFundName(fund.nombre),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Monto Mínimo',
          'COP \$${fund.montoMinimo.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          Icons.payments,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentInfo(
    BuildContext context,
    WidgetRef ref,
    double amount,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inversión Activa',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'COP \$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    Fund fund,
    bool isInvested,
  ) {
    return Row(
      children: [
        if (isInvested) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showCancelDialog(context, ref, fund),
              icon: const Icon(Icons.remove_circle_outline),
              label: const Text('Cancelar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(selectedFundProvider.notifier).state = fund;
              AppRouter.navigateToSubscribe();
            },
            icon: const Icon(Icons.add_circle),
            label: Text(isInvested ? 'Agregar más' : 'Suscribirse'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToSubscribe(BuildContext context) {
    // Navigate to subscribe page (handled by router)
    Navigator.pushNamed(context, '/subscribe');
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, Fund fund) {
    final balance = ref.read(balanceProvider);
    final investedAmount = balance.getInvestmentAmount(fund.id.toString());

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancelar Inversión'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¿Estás seguro de que deseas cancelar tu inversión en:'),
                const SizedBox(height: 8),
                Text(
                  AppHelpers.formatFundName(fund.nombre),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monto a recuperar:',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'COP \$${investedAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _cancelInvestment(context, ref, fund);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );
  }

  Future<void> _cancelInvestment(
    BuildContext context,
    WidgetRef ref,
    Fund fund,
  ) async {
    try {
      final balance = ref.read(balanceProvider);
      final investedAmount = balance.getInvestmentAmount(fund.id.toString());

      // Create cancellation transaction
      final transaction = Transaction(
        id: TransactionService().generateTransactionId(),
        fundId: fund.id.toString(),
        fundName: fund.nombre,
        type: TransactionType.cancellation,
        amount: investedAmount,
        notificationMethod:
            NotificationMethod.email, // Default for cancellations
        createdAt: DateTime.now(),
      );

      // Update balance and save transaction
      await ref
          .read(balanceProvider.notifier)
          .cancelFundInvestment(fund.id.toString());
      await ref.read(transactionProvider.notifier).addTransaction(transaction);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Inversión cancelada exitosamente. Monto recuperado: COP \$${investedAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cancelar inversión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
