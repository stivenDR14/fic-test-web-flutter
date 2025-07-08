import '../../domain/entities/fund.dart';

abstract class FundRepository {
  Future<List<Fund>> getFunds();
}
