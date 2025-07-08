import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/domain/entities/fund.dart';

part 'funds_state.freezed.dart';

@freezed
abstract class FundsState with _$FundsState {
  const factory FundsState({
    @Default([]) List<Fund> funds,
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    String? errorMessage,
  }) = _FundsState;
}
