import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';
import 'package:flutter_tech_task/utils/do_nothing.dart';

abstract class WatchPostSummariesUseCase {
  Stream<Result<List<PostSummary>>> watch();
  Future<void> refresh();
}

class WatchOfflinePostSummariesUseCase implements WatchPostSummariesUseCase {
  final PostSummaryRepositoryContract _postSummaryRepositoryContract;

  WatchOfflinePostSummariesUseCase({
    required PostSummaryRepositoryContract postSummaryRepositoryContract,
  }) : _postSummaryRepositoryContract = postSummaryRepositoryContract;

  @override
  Stream<Result<List<PostSummary>>> watch() =>
      _postSummaryRepositoryContract.watchOfflneSummaries();

  @override
  Future<void> refresh() => doNothing('Offline posts cannot be refreshed.');
}

class WatchLivePostSummariesUseCase implements WatchPostSummariesUseCase {
  final PostSummaryRepositoryContract _postSummaryRepositoryContract;

  WatchLivePostSummariesUseCase({
    required PostSummaryRepositoryContract postSummaryRepositoryContract,
  }) : _postSummaryRepositoryContract = postSummaryRepositoryContract;

  @override
  Stream<Result<List<PostSummary>>> watch() =>
      _postSummaryRepositoryContract.watchPostSummaries();

  @override
  Future<void> refresh() =>
      _postSummaryRepositoryContract.refreshPostSummaries();
}
