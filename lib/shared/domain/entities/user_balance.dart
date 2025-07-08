import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_balance.freezed.dart';
part 'user_balance.g.dart';

@freezed
abstract class UserBalance with _$UserBalance {
  const factory UserBalance({
    required double availableBalance,
    @Default({}) Map<String, double> fundInvestments,
  }) = _UserBalance;

  const UserBalance._();

  factory UserBalance.fromJson(Map<String, dynamic> json) =>
      _$UserBalanceFromJson(json);

  // Create initial balance
  factory UserBalance.initial() => const UserBalance(
    availableBalance: 500000.0, // COP $500,000 initial balance
  );

  // Calculate total invested amount
  double get totalInvested =>
      fundInvestments.values.fold(0.0, (sum, amount) => sum + amount);

  // Get investment amount for specific fund
  double getInvestmentAmount(String fundId) => fundInvestments[fundId] ?? 0.0;

  // Check if user is invested in a fund
  bool isInvestedIn(String fundId) =>
      fundInvestments.containsKey(fundId) && getInvestmentAmount(fundId) > 0;
}
