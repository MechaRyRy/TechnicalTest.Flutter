import 'dart:async';

import 'package:flutter_tech_task/app_navigator.dart';
import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/usecases/watch_comments_use_case.dart';
import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostCommentsCubit extends SafeEmissionCubit<PostCommentsState> {
  final AppNavigator _appNavigator;
  final WatchCommentsUseCase _watchCommentsUseCase;

  StreamSubscription<Result<List<PostComment>>>? _postCommentsSubscription;

  PostCommentsCubit({
    required AppNavigator appNavigator,
    required WatchCommentsUseCase watchCommentsUseCase,
  }) : _appNavigator = appNavigator,
       _watchCommentsUseCase = watchCommentsUseCase,
       super(PostCommentsLoading()) {
    _postCommentsSubscription ??= _watchCommentsUseCase.watch().listen((
      result,
    ) {
      switch (result) {
        case Success<List<PostComment>>():
          maybeEmit(PostCommentsLoaded(postComments: result.value));
        case Failure<List<PostComment>>():
          _appNavigator.pushScaffoldMessenger(ScaffoldMessengerRoute.error);
        case Loading<List<PostComment>>(value: final value):
          if (value != null) {
            maybeEmit(PostCommentsLoaded(postComments: value));
          } else {
            maybeEmit(PostCommentsLoading());
          }
      }
    });
  }

  Future<void> refreshPostComments() async {
    await _watchCommentsUseCase.refresh();
  }
}
