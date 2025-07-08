import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/balance_header.dart';
import '../../../../shared/domain/entities/transaction.dart';

import '../../../../shared/providers/transaction_provider.dart';
import '../../../../shared/providers/balance_provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/utils/helpers.dart';

// History page showing all user transactions
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  TransactionType? _filterType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionProvider.notifier).loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final balance = ref.watch(balanceProvider);

    final filteredTransactions =
        _filterType == null
            ? transactions
            : transactions.where((t) => t.type == _filterType).toList();

    return AppLayout(
      currentRoute: AppRoute.history,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BalanceHeader(
                title: 'Historial de Transacciones',
                balance: balance,
              ),
              _buildFilterChips(),
              Expanded(
                child:
                    filteredTransactions.isEmpty
                        ? _buildEmptyState()
                        : _buildTransactionsList(filteredTransactions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Todas', null),
            const SizedBox(width: 12),
            _buildFilterChip('Suscripciones', TransactionType.subscription),
            const SizedBox(width: 12),
            _buildFilterChip('Cancelaciones', TransactionType.cancellation),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, TransactionType? type) {
    final isSelected = _filterType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterType = selected ? type : null;
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay transacciones',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus transacciones aparecerán aquí',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<Transaction> transactions) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isSubscription = transaction.type == TransactionType.subscription;
    final icon = isSubscription ? Icons.add_circle : Icons.remove_circle;
    final color = isSubscription ? Colors.green : Colors.red;
    final amountPrefix = isSubscription ? '+' : '-';

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate horizontal padding for desktop
        final horizontalPadding =
            constraints.maxWidth >= 768 ? constraints.maxWidth * 0.1 : 0.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppHelpers.formatFundName(transaction.fundName),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        constraints.maxWidth >= 768
                            ? Row(
                              children: [
                                Text(
                                  isSubscription
                                      ? 'Suscripción'
                                      : 'Cancelación',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  ' • ${transaction.notificationMethod.name.toUpperCase()}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                            : Column(
                              children: [
                                Text(
                                  isSubscription
                                      ? 'Suscripción'
                                      : 'Cancelación',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  ' • ${transaction.notificationMethod.name.toUpperCase()}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        const SizedBox(height: 4),
                        Text(
                          AppHelpers.formatDate(transaction.createdAt),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$amountPrefix COP \$${transaction.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
