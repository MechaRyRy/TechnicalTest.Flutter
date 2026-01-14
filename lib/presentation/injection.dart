import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_cubit.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:get_it/get_it.dart';

Future<void> createPresentationDependencies(GetIt getIt) async {
  getIt.registerFactoryParam<PostDetailsCubit, int, void>(
    (id, _) => PostDetailsCubit(id: id, jsonPlaceholderApi: getIt()),
  );
  getIt.registerFactory(() => PostsListCubit(jsonPlaceholderApi: getIt()));
}
