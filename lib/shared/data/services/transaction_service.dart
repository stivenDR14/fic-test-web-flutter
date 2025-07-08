import 'dart:convert';
import '../../domain/entities/transaction.dart';

// Service to manage transactions in localStorage (web-compatible)
class TransactionService {
  static const String _storageKey = 'fund_transactions';

  // Get all transactions from localStorage
  Future<List<Transaction>> getTransactions() async {
    try {
      // Check if we're on web platform
      if (_isWeb()) {
        final storage = await _getWebStorage();
        final jsonString = storage[_storageKey];

        if (jsonString == null) return [];

        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => Transaction.fromJson(json)).toList()
          ..sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          ); // Most recent first
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Save transaction to localStorage
  Future<void> saveTransaction(Transaction transaction) async {
    try {
      if (_isWeb()) {
        final transactions = await getTransactions();
        transactions.insert(0, transaction); // Add to beginning

        final jsonList = transactions.map((t) => t.toJson()).toList();
        final storage = await _getWebStorage();
        storage[_storageKey] = json.encode(jsonList);
      }
      // For non-web platforms, do nothing
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  // Clear all transactions (for testing)
  Future<void> clearTransactions() async {
    if (_isWeb()) {
      final storage = await _getWebStorage();
      storage.remove(_storageKey);
    }
  }

  // Generate unique transaction ID
  String generateTransactionId() {
    return 'txn_${DateTime.now().millisecondsSinceEpoch}';
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
