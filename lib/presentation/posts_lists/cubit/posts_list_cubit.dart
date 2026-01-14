import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostsListCubit extends SafeEmissionCubit<PostsListState> {
  final JsonPlaceholderApi _jsonPlaceholderApi;

  PostsListCubit({required JsonPlaceholderApi jsonPlaceholderApi})
    : _jsonPlaceholderApi = jsonPlaceholderApi,
      super(PostsListLoading());

  Future<void> fetchPosts() async =>
      _jsonPlaceholderApi.getPosts().then((posts) {
        switch (posts) {
          case Success<List<PostSummary>>():
            maybeEmit(PostsListLoaded(posts: posts.value));
          case Failure<List<PostSummary>>():
          case Loading<List<PostSummary>>():
            maybeEmit(PostsListLoading());
        }
      });
}
