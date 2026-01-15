import 'dart:async';

import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_comments_repository_contract.dart';
import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostCommentsCubit extends SafeEmissionCubit<PostCommentsState> {
  final PostCommentsRepositoryContract _postCommentsRepository;

  StreamSubscription<Result<List<PostComment>>>? _postCommentsSubscription;

  PostCommentsCubit({
    required PostCommentsRepositoryContract postCommentsRepository,
  }) : _postCommentsRepository = postCommentsRepository,
       super(PostCommentsLoading()) {
    _postCommentsSubscription ??= _postCommentsRepository
        .watchPostComments()
        .listen((result) {
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
    await _postCommentsRepository.refreshPostComments();
  }
}
