import 'dart:async';

import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostsListCubit extends SafeEmissionCubit<PostsListState> {
  final PostSummaryRepositoryContract _postSummaryRepositoryContract;

  StreamSubscription<Result<List<PostSummary>>>? _postsSubscription;

  PostsListCubit({
    required PostSummaryRepositoryContract postSummaryRepositoryContract,
  }) : _postSummaryRepositoryContract = postSummaryRepositoryContract,
       super(PostsListLoading());

  void observe() {
    _postsSubscription ??= _postSummaryRepositoryContract
        .watchPostSummaries()
        .listen((postsResult) {
          switch (postsResult) {
            case Success<List<PostSummary>>():
              maybeEmit(PostsListLoaded(posts: postsResult.value));
            case Failure<List<PostSummary>>():
            case Loading<List<PostSummary>>():
              maybeEmit(PostsListLoading());
          }
        });
    _postSummaryRepositoryContract.refreshPostSummaries();
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    _postsSubscription = null;
    return super.close();
  }
}
