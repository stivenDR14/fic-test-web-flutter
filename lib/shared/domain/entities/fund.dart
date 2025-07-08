import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund.freezed.dart';
part 'fund.g.dart';

@freezed
abstract class Fund with _$Fund {
  const factory Fund({
    required int id,
    required String nombre,
    @JsonKey(name: 'monto_minimo') required String montoMinimo,
    required String categoria,
  }) = _Fund;

  factory Fund.fromJson(Map<String, dynamic> json) => _$FundFromJson(json);
}
