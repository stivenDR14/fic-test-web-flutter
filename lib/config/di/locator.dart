import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../core/resources/json_reader.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: JsonReader.getNameConfig('base_url'),
      responseType: ResponseType.json,
      contentType: 'application/json',
    ),
  );

  locator.registerSingleton<Dio>(dio);
}
