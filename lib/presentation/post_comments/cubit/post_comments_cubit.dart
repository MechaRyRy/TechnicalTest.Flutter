import 'dart:async';

import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/usecases/watch_comments_use_case.dart';
import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostCommentsCubit extends SafeEmissionCubit<PostCommentsState> {
  final WatchCommentsUseCase _watchCommentsUseCase;

  StreamSubscription<Result<List<PostComment>>>? _postCommentsSubscription;

  PostCommentsCubit({required WatchCommentsUseCase watchCommentsUseCase})
    : _watchCommentsUseCase = watchCommentsUseCase,
      super(PostCommentsLoading()) {
    _postCommentsSubscription ??= _watchCommentsUseCase.watch().listen((
      result,
    ) {
      switch (result) {
        case Success<List<PostComment>>():
          maybeEmit(PostCommentsLoaded(postComments: result.value));
        case Loading<List<PostComment>>():
        case Failure<List<PostComment>>():
          maybeEmit(PostCommentsLoading());
      }
    });
  }

  Future<void> refreshPostComments() async {
    await _watchCommentsUseCase.refresh();
  }
}
