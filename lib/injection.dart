import 'package:flutter_tech_task/app_navigator.dart';
import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/data/data_sources/json_placeholder_store.dart';
import 'package:flutter_tech_task/data/data_sources/object_box.dart/object_box_persistence.dart';
import 'package:flutter_tech_task/data/repositories/post_summary_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final getIt = GetIt.instance;

const _applicationScopeKey = 'ApplicationLevelInjection';

Future<void> createApplicationLevelInjection(GetIt getIt) async {
  ObjectBoxPersistence objectBox = await ObjectBoxPersistence.create();

  getIt.pushNewScope(
    scopeName: _applicationScopeKey,
    init: (getIt) {
      getIt.registerSingleton(objectBox, dispose: (objBox) => objBox.close());
      getIt.registerSingleton(AppNavigator());
      getIt.registerLazySingleton<PostSummaryRepositoryContract>(
        () => PostSummaryRepository(
          jsonPlaceholderApi: getIt(),
          jsonPlaceholderStore: getIt(),
        ),
        dispose: (repo) => repo.dispose(),
      );
      getIt.registerSingleton(Client());
      getIt.registerSingleton<JsonPlaceholderApi>(
        HttpBasedJsonPlaceholderApi(httpClient: getIt()),
      );
      getIt.registerSingleton<JsonPlaceholderStore>(
        InMemoryJsonPlaceholderStore(),
      );
    },
  );
}

Future<void> disposeApplicationLevelInjection(GetIt getIt) async {
  if (getIt.hasScope(_applicationScopeKey)) {
    await getIt.dropScope(_applicationScopeKey);
  }
}
