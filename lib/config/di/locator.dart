import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../core/resources/json_reader.dart';
import '../../shared/data/datasources/fund_remote_datasource.dart';
import '../../shared/data/repositories/fund_repository_impl.dart';
import '../../shared/domain/repositories/fund_repository.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  // Configure Dio with base URL from config
  final dio = Dio(
    BaseOptions(
      baseUrl: JsonReader.getNameConfig('base_url'),
      responseType: ResponseType.json,
      contentType: 'application/json',
    ),
  );

  locator.registerSingleton<Dio>(dio);

  // Initialize fund-related dependencies
  _setupFundDependencies();
}

void _setupFundDependencies() {
  // Data Sources - use the already configured Dio instance
  locator.registerLazySingleton<FundRemoteDataSource>(
    () => FundRemoteDataSourceImpl(dio: locator<Dio>()),
  );

  // Repository
  locator.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(remoteDataSource: locator<FundRemoteDataSource>()),
  );
}
