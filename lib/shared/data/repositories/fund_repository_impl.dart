import '../../domain/repositories/fund_repository.dart';
import '../datasources/fund_remote_datasource.dart';
import '../../domain/entities/fund.dart';

class FundRepositoryImpl implements FundRepository {
  final FundRemoteDataSource remoteDataSource;

  FundRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Fund>> getFunds() async {
    try {
      return await remoteDataSource.getFunds();
    } catch (e) {
      throw Exception('Failed to load funds: $e');
    }
  }
}
