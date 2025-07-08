import '../../domain/entities/transaction.dart';
import '../../../core/utils/web_storage.dart';

// Service to manage transactions in localStorage (web-compatible)
class TransactionService {
  static const String _storageKey = 'fund_transactions';

  // Get all transactions from localStorage
  Future<List<Transaction>> getTransactions() async {
    try {
      final jsonList = WebStorage.getItem<List<dynamic>>(
        _storageKey,
        (json) => json as List<dynamic>,
      );
      if (jsonList == null) return [];
      return jsonList.map((json) => Transaction.fromJson(json)).toList()..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      ); // Most recent first
    } catch (e) {
      return [];
    }
  }

  // Save transaction to localStorage
  Future<void> saveTransaction(Transaction transaction) async {
    try {
      final transactions = await getTransactions();
      transactions.insert(0, transaction); // Add to beginning
      final jsonList = transactions.map((t) => t.toJson()).toList();
      WebStorage.setItem(_storageKey, jsonList);
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  // Clear all transactions
  /* Future<void> clearTransactions() async {
    WebStorage.removeItem(_storageKey);
  } */

  // Generate unique transaction ID
  String generateTransactionId() {
    return 'txn_${DateTime.now().millisecondsSinceEpoch}';
  }
}
