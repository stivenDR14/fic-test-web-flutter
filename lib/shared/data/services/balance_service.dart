import 'dart:convert';
import '../../domain/entities/user_balance.dart';
import '../../../core/utils/web_storage.dart';

// Service to manage user balance in localStorage (web-compatible)
class BalanceService {
  static const String _storageKey = 'user_balance';

  // Get user balance from localStorage
  Future<UserBalance> getBalance() async {
    try {
      final jsonMap = WebStorage.getItem<Map<String, dynamic>>(
        _storageKey,
        (json) => json as Map<String, dynamic>,
      );
      if (jsonMap == null) {
        // Initialize with default balance if not exists
        final initialBalance = UserBalance.initial();
        await saveBalance(initialBalance);
        return initialBalance;
      }
      return UserBalance.fromJson(jsonMap);
    } catch (e) {
      // Return initial balance if there's an error
      return UserBalance.initial();
    }
  }

  // Save user balance to localStorage
  Future<void> saveBalance(UserBalance balance) async {
    try {
      WebStorage.setItem(_storageKey, balance.toJson());
    } catch (e) {
      throw Exception('Failed to save balance: $e');
    }
  }

  // Subscribe to a fund
  Future<UserBalance> subscribeToFund(String fundId, double amount) async {
    final currentBalance = await getBalance();

    if (currentBalance.availableBalance < amount) {
      throw Exception('Saldo insuficiente');
    }

    final newFundInvestments = Map<String, double>.from(
      currentBalance.fundInvestments,
    );
    newFundInvestments[fundId] = (newFundInvestments[fundId] ?? 0.0) + amount;

    final newBalance = UserBalance(
      availableBalance: currentBalance.availableBalance - amount,
      fundInvestments: newFundInvestments,
    );

    await saveBalance(newBalance);
    return newBalance;
  }

  // Cancel fund investment
  Future<UserBalance> cancelFundInvestment(String fundId) async {
    final currentBalance = await getBalance();
    final investedAmount = currentBalance.getInvestmentAmount(fundId);

    if (investedAmount <= 0) {
      throw Exception('No tienes inversión en este fondo');
    }

    final newFundInvestments = Map<String, double>.from(
      currentBalance.fundInvestments,
    );
    newFundInvestments.remove(fundId);

    final newBalance = UserBalance(
      availableBalance: currentBalance.availableBalance + investedAmount,
      fundInvestments: newFundInvestments,
    );

    await saveBalance(newBalance);
    return newBalance;
  }
}
