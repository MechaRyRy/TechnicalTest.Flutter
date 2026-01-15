import 'package:flutter_tech_task/data/repositories/post_comments_repository.dart';
import 'package:flutter_tech_task/domain/repositories/post_comments_repository_contract.dart';
import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_cubit.dart';
import 'package:get_it/get_it.dart';

const _commentsPageScopeKey = 'PostCommentsPageInjection';

Future<void> createPostCommentsPageScopedInjection(
  GetIt getIt,
  int postId,
) async {
  getIt.pushNewScope(
    scopeName: _commentsPageScopeKey,
    init: (getIt) {
      getIt.registerSingleton<PostCommentsRepositoryContract>(
        PostCommentsRepository(postId: postId, jsonPlaceholderApi: getIt()),
      );
      getIt.registerFactory(
        () => PostCommentsCubit(postCommentsRepository: getIt()),
      );
    },
  );
}

Future<void> disposePostsListPageInjection(GetIt getIt) async {
  if (getIt.hasScope(_commentsPageScopeKey)) {
    await getIt.dropScope(_commentsPageScopeKey);
  }
}
