import 'dart:async';

import 'package:flutter_tech_task/app_navigator.dart';
import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostDetailsCubit extends SafeEmissionCubit<PostDetailsState> {
  final AppNavigator _appNavigator;
  final PostDetailsRepositoryContract _postDetailsRepositoryContract;

  StreamSubscription<Result<PostDetails>>? _postDetailsSubscription;

  PostDetailsCubit({
    required AppNavigator appNavigator,
    required PostDetailsRepositoryContract postDetailsRepositoryContract,
  }) : _appNavigator = appNavigator,
       _postDetailsRepositoryContract = postDetailsRepositoryContract,
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

  void performAction(BookmarkAction action) {
    switch (action) {
      case AddBookmark():
        _postDetailsRepositoryContract.addBookmark();
      case RemoveBookmark():
        _postDetailsRepositoryContract.removeBookmark();
    }
  }

  void navigateToComments(int postId) =>
      _appNavigator.pushNamed('comments/', arguments: {'id': postId});

  @override
  Future<void> close() {
    _postDetailsSubscription?.cancel();
    _postDetailsSubscription = null;
    return super.close();
  }
}
