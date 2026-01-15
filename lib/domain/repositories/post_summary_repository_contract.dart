import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';

abstract class PostSummaryRepositoryContract {
  Stream<Result<List<PostSummary>>> watchPostSummaries();
  Future<void> refreshPostSummaries();
}
