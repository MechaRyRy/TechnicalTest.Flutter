import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:get_it/get_it.dart';

Future<void> createPostsListDependencies(GetIt getIt) async {
  getIt.registerFactory(() => PostsListCubit(httpClient: getIt()));
}
