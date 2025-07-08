import 'package:dio/dio.dart';
import '../../domain/entities/fund.dart';

abstract class FundRemoteDataSource {
  Future<List<Fund>> getFunds();
}

class FundRemoteDataSourceImpl implements FundRemoteDataSource {
  final Dio dio;

  FundRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Fund>> getFunds() async {
    try {
      // Use the configured Dio instance with baseUrl already set
      final response = await dio.get('/funds');

      if (response.statusCode == 200) {
        final List<dynamic> fundsJson = response.data;
        return fundsJson.map((json) => Fund.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load funds: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
