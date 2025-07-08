import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

// Transaction types
enum TransactionType { subscription, cancellation }

// Notification methods
enum NotificationMethod { email, sms }

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String fundId,
    required String fundName,
    required TransactionType type,
    required double amount,
    required NotificationMethod notificationMethod,
    required DateTime createdAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
