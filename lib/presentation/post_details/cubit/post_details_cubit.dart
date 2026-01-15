import 'dart:async';

import 'package:flutter_tech_task/app_navigator.dart';
import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/usecases/add_post_use_case.dart';
import 'package:flutter_tech_task/domain/usecases/remove_post_use_case.dart';
import 'package:flutter_tech_task/domain/usecases/watch_post_details_use_case.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostDetailsCubit extends SafeEmissionCubit<PostDetailsState> {
  final AppNavigator _appNavigator;
  final AddPostUseCase _addPostUseCase;
  final RemovePostUseCase _removePostUseCase;
  final WatchPostDetailsUseCase _watchPostDetailsUseCase;

  StreamSubscription<Result<PostDetails>>? _postDetailsSubscription;

  PostDetailsCubit({
    required AppNavigator appNavigator,
    required AddPostUseCase addPostUseCase,
    required RemovePostUseCase removePostUseCase,
    required WatchPostDetailsUseCase watchPostDetailsUseCase,
  }) : _appNavigator = appNavigator,
       _addPostUseCase = addPostUseCase,
       _removePostUseCase = removePostUseCase,
       _watchPostDetailsUseCase = watchPostDetailsUseCase,
       super(PostDetailsLoading()) {
    _postDetailsSubscription ??= _watchPostDetailsUseCase
        .watch() //
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

  Future<void> loadDetails() => _watchPostDetailsUseCase.refresh();

  void performAction(BookmarkAction action) {
    switch (action) {
      case AddBookmark():
        _addPostUseCase.addPost();
      case RemoveBookmark():
        _removePostUseCase.removePost();
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
