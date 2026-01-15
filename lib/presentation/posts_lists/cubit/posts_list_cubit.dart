import 'dart:async';

import 'package:flutter_tech_task/app_navigator.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/usecases/watch_post_summaries_use_case.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostsListCubit extends SafeEmissionCubit<PostsListState> {
  final AppNavigator _appNavigator;
  final WatchPostSummariesUseCase _watchPostSummariesUseCase;

  StreamSubscription<Result<List<PostSummary>>>? _postsSubscription;

  PostsListCubit({
    required AppNavigator appNavigator,
    required WatchPostSummariesUseCase watchPostSummariesUseCase,
  }) : _appNavigator = appNavigator,
       _watchPostSummariesUseCase = watchPostSummariesUseCase,
       super(PostsListLoading()) {
    _postsSubscription ??= _watchPostSummariesUseCase.watch().listen((
      postsResult,
    ) {
      switch (postsResult) {
        case Success<List<PostSummary>>():
          maybeEmit(PostsListLoaded(posts: postsResult.value));
        case Failure<List<PostSummary>>():
          _appNavigator.pushScaffoldMessenger(ScaffoldMessengerRoute.error);
        case Loading<List<PostSummary>>(value: final value):
          if (value != null) {
            maybeEmit(PostsListLoaded(posts: value));
          } else {
            maybeEmit(PostsListLoading());
          }
      }
    });
  }

  void loadPosts() => _watchPostSummariesUseCase.refresh();

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    _postsSubscription = null;
    return super.close();
  }
}
