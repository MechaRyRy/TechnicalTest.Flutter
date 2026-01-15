import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/data/data_sources/json_placeholder_store.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

Future<void> createDataDependencies(GetIt getIt) async {
  getIt.registerSingleton(Client());
  getIt.registerSingleton<JsonPlaceholderApi>(
    HttpBasedJsonPlaceholderApi(httpClient: getIt()),
  );
  getIt.registerSingleton<JsonPlaceholderStore>(InMemoryJsonPlaceholderStore());
}
