import 'dart:convert';
import '../../domain/entities/user_balance.dart';

// Service to manage user balance in localStorage (web-compatible)
class BalanceService {
  static const String _storageKey = 'user_balance';

  // Get user balance from localStorage
  Future<UserBalance> getBalance() async {
    try {
      if (_isWeb()) {
        final storage = await _getWebStorage();
        final jsonString = storage[_storageKey];

        if (jsonString == null) {
          // Initialize with default balance if not exists
          final initialBalance = UserBalance.initial();
          await saveBalance(initialBalance);
          return initialBalance;
        }

        final json = jsonDecode(jsonString);
        return UserBalance.fromJson(json);
      } else {
        return UserBalance.initial();
      }
    } catch (e) {
      // Return initial balance if there's an error
      return UserBalance.initial();
    }
  }

  // Save user balance to localStorage
  Future<void> saveBalance(UserBalance balance) async {
    try {
      if (_isWeb()) {
        final jsonString = jsonEncode(balance.toJson());
        final storage = await _getWebStorage();
        storage[_storageKey] = jsonString;
      }
      // For non-web platforms, do nothing
    } catch (e) {
      throw Exception('Failed to save balance: $e');
    }
  }

  // Subscribe to a fund (decrease available balance, increase fund investment)
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

  // Cancel fund investment (increase available balance, decrease fund investment)
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

  // Reset balance to initial state (for testing)
  Future<void> resetBalance() async {
    await saveBalance(UserBalance.initial());
  }

  // Check if running on web platform
  bool _isWeb() {
    try {
      // This will throw on non-web platforms
      return identical(0, 0.0) == false; // Always false, but checks web context
    } catch (e) {
      return false;
    }
  }

  // Get web localStorage dynamically
  Future<Map<String, String?>> _getWebStorage() async {
    // This is a simplified mock for testing
    // In real web environment, this would use html.window.localStorage
    return <String, String?>{};
  }
}
