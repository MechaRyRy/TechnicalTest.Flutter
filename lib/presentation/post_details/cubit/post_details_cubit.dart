import 'dart:async';

import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostDetailsCubit extends SafeEmissionCubit<PostDetailsState> {
  final PostDetailsRepositoryContract _postDetailsRepositoryContract;
  StreamSubscription<Result<PostDetails>>? _postDetailsSubscription;

  PostDetailsCubit({
    required PostDetailsRepositoryContract postDetailsRepositoryContract,
  }) : _postDetailsRepositoryContract = postDetailsRepositoryContract,
       super(PostDetailsLoading()) {
    _postDetailsSubscription ??= _postDetailsRepositoryContract
        .watchPostDetails() //
        .listen((postDetails) {
          switch (postDetails) {
            case Success<PostDetails>():
              maybeEmit(
                PostDetailsLoaded(
                  postDetails: postDetails.value,
                  action: postDetails.value.isOffline
                      ? RemoveBookmark(postId: postDetails.value.id)
                      : AddBookmark(postId: postDetails.value.id),
                ),
              );
            case Failure<PostDetails>():
            case Loading<PostDetails>():
              maybeEmit(PostDetailsLoading());
          }
        });
  }

  Future<void> loadDetails() =>
      _postDetailsRepositoryContract.refreshPostDetails();

  @override
  Future<void> close() {
    _postDetailsSubscription?.cancel();
    _postDetailsSubscription = null;
    return super.close();
  }

  void performAction(PostDetailsAction action) {
    switch (action) {
      case AddBookmark():
        _postDetailsRepositoryContract.addBookmark();
      case RemoveBookmark():
        _postDetailsRepositoryContract.removeBookmark();
    }
  }
}
