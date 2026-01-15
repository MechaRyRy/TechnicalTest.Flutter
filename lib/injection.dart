import 'package:flutter_tech_task/data/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/injection.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  await createPostListInjection(getIt);
  await createDataDependencies(getIt);
}
