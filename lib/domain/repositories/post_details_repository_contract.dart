import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';

abstract class PostDetailsRepositoryContract {
  Stream<Result<PostDetails>> watchPostDetails();
  Future<void> refreshPostDetails();
}
