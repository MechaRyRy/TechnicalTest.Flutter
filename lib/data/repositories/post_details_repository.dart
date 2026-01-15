import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';
import 'package:rxdart/rxdart.dart';

class PostDetailsRepository extends PostDetailsRepositoryContract {
  final int _postId;
  final JsonPlaceholderApi _jsonPlaceholderApi;
  final BehaviorSubject<Result<PostDetails>> _subject = BehaviorSubject();
  Stream<Result<PostDetails>> watchData() => _subject.stream;

  PostDetailsRepository({
    required int postId,
    required JsonPlaceholderApi jsonPlaceholderApi,
  }) : _postId = postId,
       _jsonPlaceholderApi = jsonPlaceholderApi;

  @override
  Stream<Result<PostDetails>> watchPostDetails() => _subject.stream;

  @override
  Future<void> refreshPostDetails() async {
    final PostDetails? lastValue = _subject.valueOrNull?.value;
    _subject.add(Result.loading(value: lastValue));

    _jsonPlaceholderApi
        .getPostDetails(_postId)
        .then((postDetails) => _subject.add(Result.success(postDetails)))
        .onError<Exception>((e, _) {
          _subject.add(
            Result<PostDetails>.failureFromException(
              error: e,
              value: lastValue,
            ),
          );
        })
        .onError<Error>((e, _) {
          _subject.add(
            Result<PostDetails>.failureFromError(error: e, value: lastValue),
          );
        });
  }

  @override
  void dispose() => _subject.close();
}
