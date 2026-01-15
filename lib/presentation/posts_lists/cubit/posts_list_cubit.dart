import 'dart:async';

import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/usecases/watch_post_summaries_use_case.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostsListCubit extends SafeEmissionCubit<PostsListState> {
  final WatchPostSummariesUseCase _watchPostSummariesUseCase;

  StreamSubscription<Result<List<PostSummary>>>? _postsSubscription;

  PostsListCubit({required WatchPostSummariesUseCase watchPostSummariesUseCase})
    : _watchPostSummariesUseCase = watchPostSummariesUseCase,
      super(PostsListLoading()) {
    _postsSubscription ??= _watchPostSummariesUseCase.watch().listen((
      postsResult,
    ) {
      switch (postsResult) {
        case Success<List<PostSummary>>():
          maybeEmit(PostsListLoaded(posts: postsResult.value));
        case Failure<List<PostSummary>>():
        case Loading<List<PostSummary>>():
          maybeEmit(PostsListLoading());
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
