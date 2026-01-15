import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';

class RemovePostUseCase {
  final PostDetailsRepositoryContract _postDetailsRepositoryContract;

  RemovePostUseCase({
    required PostDetailsRepositoryContract postDetailsRepositoryContract,
  }) : _postDetailsRepositoryContract = postDetailsRepositoryContract;

  Future<void> removePost() =>
      _postDetailsRepositoryContract.removeBookmark();
}
