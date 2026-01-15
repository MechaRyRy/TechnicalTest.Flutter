import 'package:flutter_tech_task/domain/repositories/post_details_repository_contract.dart';

class AddPostUseCase {
  final PostDetailsRepositoryContract _postDetailsRepositoryContract;

  AddPostUseCase({
    required PostDetailsRepositoryContract postDetailsRepositoryContract,
  }) : _postDetailsRepositoryContract = postDetailsRepositoryContract;

  Future<void> addPost() =>
      _postDetailsRepositoryContract.addBookmark();
}
