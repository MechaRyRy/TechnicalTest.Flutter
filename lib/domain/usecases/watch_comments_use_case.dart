import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/repositories/post_comments_repository_contract.dart';

class WatchCommentsUseCase {
  final PostCommentsRepositoryContract _postCommentsRepository;

  WatchCommentsUseCase({
    required PostCommentsRepositoryContract postCommentsRepository,
  }) : _postCommentsRepository = postCommentsRepository;

  Stream<Result<List<PostComment>>> watch() =>
      _postCommentsRepository.watchPostComments();

  Future<void> refresh() => _postCommentsRepository.refreshPostComments();
}
