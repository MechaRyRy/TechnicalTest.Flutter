import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/data/data_sources/json_placeholder_store.dart';
import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';
import 'package:rxdart/rxdart.dart';

class PostDetailsRepository extends PostDetailsRepositoryContract {
  final int _postId;
  final JsonPlaceholderApi _jsonPlaceholderApi;
  final JsonPlaceholderStore _jsonPlaceholderStore;
  final BehaviorSubject<Result<PostDetails>> _networkState = BehaviorSubject();

  PostDetailsRepository({
    required int postId,
    required JsonPlaceholderApi jsonPlaceholderApi,
    required JsonPlaceholderStore jsonPlaceholderStore,
  }) : _postId = postId,
       _jsonPlaceholderApi = jsonPlaceholderApi,
       _jsonPlaceholderStore = jsonPlaceholderStore;

  @override
  Stream<Result<PostDetails>> watchPostDetails() {
    return Rx.combineLatest2<
          Result<PostDetails>,
          List<PostSummary>,
          Result<PostDetails>
        >(_networkState.stream, _jsonPlaceholderStore.watchOfflinePosts(), (
          networkResult,
          offlinePosts,
        ) {
          final bool currentlyOffline = offlinePosts.any(
            (post) => post.id == _postId,
          );

          return networkResult.map(
            (details) => details.copyWith(isOffline: currentlyOffline),
          );
        })
        .distinct();
  }

  @override
  Future<void> refreshPostDetails() async {
    final PostDetails? lastValue = _networkState.valueOrNull?.value;
    _networkState.add(Result.loading(value: lastValue));

    _jsonPlaceholderApi
        .getPostDetails(_postId)
        .then((postDetails) => _networkState.add(Result.success(postDetails)))
        .onError<Exception>((e, _) {
          _networkState.add(
            Result<PostDetails>.failureFromException(
              error: e,
              value: lastValue,
            ),
          );
        })
        .onError<Error>((e, _) {
          _networkState.add(
            Result<PostDetails>.failureFromError(error: e, value: lastValue),
          );
        });
  }

  @override
  void dispose() => _networkState.close();
}
