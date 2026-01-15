import 'package:flutter_tech_task/data/repositories/post_summary_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:get_it/get_it.dart';

const _scopeKey = 'PostListInjection';

Future<void> createScopedPostListInjection(GetIt getIt) async {
  getIt.pushNewScope(scopeName: _scopeKey);

  getIt.registerLazySingleton<PostSummaryRepositoryContract>(
    () => PostSummaryRepository(jsonPlaceholderApi: getIt()),
    dispose: (repo) => repo.dispose(),
  );

  getIt.registerFactory<PostsListCubit>(
    () => PostsListCubit(postSummaryRepositoryContract: getIt()),
  );
}

Future<void> disposePostDetailsInjection(GetIt getIt) async {
  await getIt.dropScope(_scopeKey);
}
