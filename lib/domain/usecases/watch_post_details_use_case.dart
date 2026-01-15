import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';

class WatchPostDetailsUseCase {
  final PostDetailsRepositoryContract _postDetailsRepositoryContract;

  WatchPostDetailsUseCase({
    required PostDetailsRepositoryContract postDetailsRepositoryContract,
  }) : _postDetailsRepositoryContract = postDetailsRepositoryContract;

  Stream<Result<PostDetails>> watch() =>
      _postDetailsRepositoryContract.watchPostDetails();

  Future<void> refresh() => _postDetailsRepositoryContract.refreshPostDetails();
}
