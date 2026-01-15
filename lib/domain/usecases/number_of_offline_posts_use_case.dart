import 'package:flutter_tech_task/domain/repositories/post_summary_repository_contract.dart';

class NumberOfOfflinePostsUseCase {
  final PostSummaryRepositoryContract _repository;

  NumberOfOfflinePostsUseCase({
    required PostSummaryRepositoryContract repository,
  }) : _repository = repository;

  Stream<int> watch() => _repository.watchOfflneSummaries().map(
    (items) => items.value?.length ?? 0,
  );
}
