// User balance entity
class UserBalance {
  final double availableBalance;
  final Map<String, double> fundInvestments; // fundId -> amount invested

  const UserBalance({
    required this.availableBalance,
    required this.fundInvestments,
  });

  // Convert to JSON for localStorage
  Map<String, dynamic> toJson() {
    return {
      'availableBalance': availableBalance,
      'fundInvestments': fundInvestments,
    };
  }

  // Create from JSON from localStorage
  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      availableBalance: json['availableBalance'].toDouble(),
      fundInvestments: Map<String, double>.from(
        json['fundInvestments']?.map((k, v) => MapEntry(k, v.toDouble())) ?? {},
      ),
    );
  }

  // Create initial balance
  factory UserBalance.initial() {
    return const UserBalance(
      availableBalance: 500000.0, // COP $500,000 initial balance
      fundInvestments: {},
    );
  }

  // Calculate total invested amount
  double get totalInvested {
    return fundInvestments.values.fold(0.0, (sum, amount) => sum + amount);
  }

  // Get investment amount for specific fund
  double getInvestmentAmount(String fundId) {
    return fundInvestments[fundId] ?? 0.0;
  }

  // Check if user is invested in a fund
  bool isInvestedIn(String fundId) {
    return fundInvestments.containsKey(fundId) &&
        (fundInvestments[fundId] ?? 0.0) > 0;
  }
}
