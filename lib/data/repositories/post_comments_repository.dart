import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_comments_repository_contract.dart';
import 'package:rxdart/rxdart.dart';

class PostCommentsRepository extends PostCommentsRepositoryContract {
  final int _postId;
  final JsonPlaceholderApi _jsonPlaceholderApi;

  final BehaviorSubject<Result<List<PostComment>>> _subject = BehaviorSubject();

  PostCommentsRepository({
    required int postId,
    required JsonPlaceholderApi jsonPlaceholderApi,
  }) : _postId = postId,
       _jsonPlaceholderApi = jsonPlaceholderApi;

  @override
  Stream<Result<List<PostComment>>> watchPostComments() => _subject.stream;

  @override
  Future<void> refreshPostComments() async {
    final List<PostComment>? lastValue = _subject.valueOrNull?.value;
    _subject.add(Result.loading(value: lastValue));

    _jsonPlaceholderApi
        .getPostComments(_postId)
        .then((posts) => _subject.add(Result.success(posts)))
        .onError<Exception>((e, _) {
          _subject.add(
            Result<List<PostComment>>.failureFromException(
              error: e,
              value: lastValue,
            ),
          );
        })
        .onError<Error>((e, _) {
          _subject.add(
            Result<List<PostComment>>.failureFromError(
              error: e,
              value: lastValue,
            ),
          );
        });
  }

  @override
  void dispose() {
    _subject.close();
  }
}
