import 'package:flutter_tech_task/data/repositories/post_summary_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';
import 'package:flutter_tech_task/domain/usecases/watch_post_summaries_use_case.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:get_it/get_it.dart';

const _allScopeKey = 'AllPostListInjection';
const _bookmarkedScopeKey = 'BookmarkedPostListInjection';

Future<void> createAllTabScopedInjection(GetIt getIt) async {
  getIt.pushNewScope(scopeName: _allScopeKey);

  getIt.registerLazySingleton<PostSummaryRepositoryContract>(
    () => PostSummaryRepository(
      jsonPlaceholderApi: getIt(),
      jsonPlaceholderStore: getIt(),
    ),
    dispose: (repo) => repo.dispose(),
  );

  getIt.registerFactory<WatchPostSummariesUseCase>(
    () => WatchLivePostSummariesUseCase(postSummaryRepositoryContract: getIt()),
  );

  getIt.registerFactory<PostsListCubit>(
    () => PostsListCubit(watchPostSummariesUseCase: getIt()),
  );
}

Future<void> disposeAllTabInjection(GetIt getIt) async {
  await getIt.dropScope(_allScopeKey);
}

Future<void> createBookmarkedTabScopedInjection(GetIt getIt) async {
  getIt.pushNewScope(scopeName: _bookmarkedScopeKey);

  getIt.registerLazySingleton<PostSummaryRepositoryContract>(
    () => PostSummaryRepository(
      jsonPlaceholderApi: getIt(),
      jsonPlaceholderStore: getIt(),
    ),
    dispose: (repo) => repo.dispose(),
  );

  getIt.registerFactory<WatchPostSummariesUseCase>(
    () => WatchOfflinePostSummariesUseCase(
      postSummaryRepositoryContract: getIt(),
    ),
  );

  getIt.registerFactory<PostsListCubit>(
    () => PostsListCubit(watchPostSummariesUseCase: getIt()),
  );
}

Future<void> disposeBookmarkedTabInjection(GetIt getIt) async {
  await getIt.dropScope(_bookmarkedScopeKey);
}
