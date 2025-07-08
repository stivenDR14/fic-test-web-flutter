import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../shared/domain/repositories/fund_repository.dart';
import '../domain/entities/funds_state.dart';

final fundProvider = StateNotifierProvider<FundNotifier, FundsState>((ref) {
  return FundNotifier(fundRepository: GetIt.instance<FundRepository>());
});

class FundNotifier extends StateNotifier<FundsState> {
  FundNotifier({required this.fundRepository}) : super(const FundsState());

  final FundRepository fundRepository;

  // Load all funds from the server
  Future<void> loadFunds() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, isError: false);

    try {
      final funds = await fundRepository.getFunds();
      state = state.copyWith(funds: funds, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      );
    }
  }
}
