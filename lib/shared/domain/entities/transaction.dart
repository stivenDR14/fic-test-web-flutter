// Transaction entity for fund subscriptions and cancellations
class Transaction {
  final String id;
  final String fundId;
  final String fundName;
  final TransactionType type;
  final double amount;
  final NotificationMethod notificationMethod;
  final DateTime createdAt;

  const Transaction({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.type,
    required this.amount,
    required this.notificationMethod,
    required this.createdAt,
  });

  // Convert to JSON for localStorage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundId': fundId,
      'fundName': fundName,
      'type': type.name,
      'amount': amount,
      'notificationMethod': notificationMethod.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON from localStorage
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      fundId: json['fundId'],
      fundName: json['fundName'],
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amount: json['amount'].toDouble(),
      notificationMethod: NotificationMethod.values.firstWhere(
        (e) => e.name == json['notificationMethod'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// Transaction types
enum TransactionType { subscription, cancellation }

// Notification methods
enum NotificationMethod { email, sms }
