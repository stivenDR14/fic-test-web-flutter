import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/user_balance.dart';
import '../data/services/balance_service.dart';

// Balance provider for state management
final balanceProvider = StateNotifierProvider<BalanceNotifier, UserBalance>((
  ref,
) {
  return BalanceNotifier();
});

class BalanceNotifier extends StateNotifier<UserBalance> {
  final BalanceService _balanceService = BalanceService();

  BalanceNotifier() : super(UserBalance.initial()) {
    loadBalance();
  }

  // Load balance from localStorage
  Future<void> loadBalance() async {
    try {
      final balance = await _balanceService.getBalance();
      state = balance;
    } catch (e) {
      state = UserBalance.initial();
    }
  }

  // Subscribe to fund
  Future<void> subscribeToFund(String fundId, double amount) async {
    try {
      final newBalance = await _balanceService.subscribeToFund(fundId, amount);
      state = newBalance;
    } catch (e) {
      rethrow;
    }
  }

  // Cancel fund investment
  Future<void> cancelFundInvestment(String fundId) async {
    try {
      final newBalance = await _balanceService.cancelFundInvestment(fundId);
      state = newBalance;
    } catch (e) {
      rethrow;
    }
  }

  // Check if user can invest amount
  bool canInvest(double amount) {
    return state.availableBalance >= amount;
  }

  // Get formatted available balance
  String get formattedAvailableBalance {
    return 'COP \$${state.availableBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  // Get formatted investment for fund
  String getFormattedInvestment(String fundId) {
    final amount = state.getInvestmentAmount(fundId);
    if (amount <= 0) return '';
    return 'COP \$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
