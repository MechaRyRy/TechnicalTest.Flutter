import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';
import 'package:rxdart/rxdart.dart';

class PostSummaryRepository extends PostSummaryRepositoryContract {
  final JsonPlaceholderApi _jsonPlaceholderApi;
  final BehaviorSubject<Result<List<PostSummary>>> _subject = BehaviorSubject();
  Stream<Result<List<PostSummary>>> watchData() => _subject.stream;

  PostSummaryRepository({required JsonPlaceholderApi jsonPlaceholderApi})
    : _jsonPlaceholderApi = jsonPlaceholderApi;

  @override
  Stream<Result<List<PostSummary>>> watchPostSummaries() => _subject.stream;

  @override
  Future<void> refreshPostSummaries() async {
    final List<PostSummary>? lastValue = _subject.valueOrNull?.value;
    _subject.add(Result.loading(value: lastValue));

    _jsonPlaceholderApi
        .getPosts()
        .then((posts) => _subject.add(Result.success(posts)))
        .onError<Exception>((e, _) {
          _subject.add(
            Result<List<PostSummary>>.failureFromException(
              error: e,
              value: lastValue,
            ),
          );
        })
        .onError<Error>((e, _) {
          _subject.add(
            Result<List<PostSummary>>.failureFromError(
              error: e,
              value: lastValue,
            ),
          );
        });
  }
}
