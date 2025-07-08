import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/transaction.dart';
import '../data/services/transaction_service.dart';

// Transaction provider for state management
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
      return TransactionNotifier();
    });

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final TransactionService _transactionService = TransactionService();

  TransactionNotifier() : super([]) {
    loadTransactions();
  }

  // Load transactions from localStorage
  Future<void> loadTransactions() async {
    try {
      final transactions = await _transactionService.getTransactions();
      state = transactions;
    } catch (e) {
      state = [];
    }
  }

  // Add new transaction
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _transactionService.saveTransaction(transaction);
      state = [transaction, ...state];
    } catch (e) {
      throw Exception('Error al guardar transacción: $e');
    }
  }

  // Get transactions by type
  List<Transaction> getTransactionsByType(TransactionType type) {
    return state.where((t) => t.type == type).toList();
  }

  // Get transactions by fund
  List<Transaction> getTransactionsByFund(String fundId) {
    return state.where((t) => t.fundId == fundId).toList();
  }
}
