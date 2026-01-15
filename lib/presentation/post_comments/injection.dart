import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_cubit.dart';
import 'package:get_it/get_it.dart';

const _commentsPageScopeKey = 'PostCommentsPageInjection';

Future<void> createPostCommentsPageScopedInjection(GetIt getIt) async {
  getIt.pushNewScope(
    scopeName: _commentsPageScopeKey,
    init: (getIt) {
      getIt.registerFactory(() => PostCommentsCubit());
    },
  );
}

Future<void> disposePostsListPageInjection(GetIt getIt) async {
  if (getIt.hasScope(_commentsPageScopeKey)) {
    await getIt.dropScope(_commentsPageScopeKey);
  }
}
