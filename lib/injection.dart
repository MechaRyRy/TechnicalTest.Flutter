import 'package:flutter_tech_task/presentation/post_details/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/injection.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerSingleton(Client());
  await createPostsListDependencies(getIt);
  await createPostDetailsDependencies(getIt);
}
