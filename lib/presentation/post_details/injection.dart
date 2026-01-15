import 'package:flutter_tech_task/data/repositories/post_details_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';
import 'package:flutter_tech_task/domain/usecases/add_post_use_case.dart';
import 'package:flutter_tech_task/domain/usecases/remove_post_use_case.dart';
import 'package:flutter_tech_task/domain/usecases/watch_post_details_use_case.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_cubit.dart';
import 'package:get_it/get_it.dart';

const _scopeKey = 'PostDetailsInjection';

Future<void> createScopedPostDetailsInjection(GetIt getIt, int postId) async {
  getIt.pushNewScope(scopeName: _scopeKey);

  getIt.registerLazySingleton<PostDetailsRepositoryContract>(
    () => PostDetailsRepository(
      postId: postId,
      jsonPlaceholderApi: getIt(),
      jsonPlaceholderStore: getIt(),
    ),
    dispose: (repo) => repo.dispose(),
  );

  getIt.registerFactory(
    () => WatchPostDetailsUseCase(postDetailsRepositoryContract: getIt()),
  );

  getIt.registerFactory(
    () => AddPostUseCase(postDetailsRepositoryContract: getIt()),
  );

  getIt.registerFactory(
    () => RemovePostUseCase(postDetailsRepositoryContract: getIt()),
  );

  getIt.registerFactory<PostDetailsCubit>(
    () => PostDetailsCubit(
      appNavigator: getIt(),
      addPostUseCase: getIt(),
      removePostUseCase: getIt(),
      watchPostDetailsUseCase: getIt(),
    ),
  );
}

Future<void> disposePostDetailsInjection(GetIt getIt) async {
  await getIt.dropScope(_scopeKey);
}
