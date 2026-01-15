import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';

abstract class PostCommentsRepositoryContract {
  Stream<Result<List<PostComment>>> watchPostComments();
  Future<void> refreshPostComments();
  void dispose();
}
