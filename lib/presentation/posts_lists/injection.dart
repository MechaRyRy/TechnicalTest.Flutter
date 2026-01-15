import 'package:flutter_tech_task/data/repositories/post_summary_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';
import 'package:flutter_tech_task/domain/usecases/number_of_offline_posts_use_case.dart';
import 'package:flutter_tech_task/domain/usecases/watch_post_summaries_use_case.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/bookmark_tab_header_cubit.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:get_it/get_it.dart';

const _postsPageScopeKey = 'PostsListPageInjection';
const _allScopeKey = 'AllPostListInjection';
const _bookmarkedScopeKey = 'BookmarkedPostListInjection';

Future<void> createPostsListPageScopedInjection(GetIt getIt) async {
  getIt.pushNewScope(
    scopeName: _postsPageScopeKey,
    init: (getIt) {
      getIt.registerLazySingleton<PostSummaryRepositoryContract>(
        () => PostSummaryRepository(
          jsonPlaceholderApi: getIt(),
          jsonPlaceholderStore: getIt(),
        ),
        dispose: (repo) => repo.dispose(),
      );

      getIt.registerFactory<NumberOfOfflinePostsUseCase>(
        () => NumberOfOfflinePostsUseCase(repository: getIt()),
      );

      getIt.registerFactory<BookmarkTabHeaderCubit>(
        () => BookmarkTabHeaderCubit(numberOfOfflinePostsUseCase: getIt()),
      );
    },
  );
}

Future<void> disposePostsListPageInjection(GetIt getIt) async {
  if (getIt.hasScope(_postsPageScopeKey)) {
    await getIt.dropScope(_postsPageScopeKey);
  }
}

Future<void> createAllTabScopedInjection(GetIt getIt) async {
  getIt.pushNewScope(
    scopeName: _allScopeKey,
    init: (getIt) {
      getIt.registerFactory<WatchPostSummariesUseCase>(
        () => WatchLivePostSummariesUseCase(
          postSummaryRepositoryContract: getIt(),
        ),
      );

      getIt.registerFactory<PostsListCubit>(
        () => PostsListCubit(watchPostSummariesUseCase: getIt()),
      );
    },
  );
}

Future<void> disposeAllTabInjection(GetIt getIt) async {
  if (getIt.hasScope(_allScopeKey)) {
    await getIt.dropScope(_allScopeKey);
  }
}

Future<void> createBookmarkedTabScopedInjection(GetIt getIt) async {
  getIt.pushNewScope(
    scopeName: _bookmarkedScopeKey,
    init: (getIt) {
      getIt.registerFactory<WatchPostSummariesUseCase>(
        () => WatchOfflinePostSummariesUseCase(
          postSummaryRepositoryContract: getIt(),
        ),
      );

      getIt.registerFactory<PostsListCubit>(
        () => PostsListCubit(watchPostSummariesUseCase: getIt()),
      );
    },
  );
}

Future<void> disposeBookmarkedTabInjection(GetIt getIt) async {
  if (getIt.hasScope(_bookmarkedScopeKey)) {
    await getIt.dropScope(_bookmarkedScopeKey);
  }
}
