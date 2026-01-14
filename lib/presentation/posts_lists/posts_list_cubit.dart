import 'dart:convert';

import 'package:flutter_tech_task/presentation/posts_lists/posts_list_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';
import 'package:http/http.dart';

class PostsListCubit extends SafeEmissionCubit<PostsListState> {
  final Client _httpClient;

  PostsListCubit({required Client httpClient})
    : _httpClient = httpClient,
      super(PostsListLoading());

  Future<void> fetchPosts() async {
    _httpClient
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/'))
        .then((response) {
          try {
            List<dynamic> responseList =
                json.decode(response.body) as List<dynamic>;
            final posts = responseList
                .map(
                  (post) => Post(
                    id: post['id'],
                    title: post['title'],
                    body: post['body'],
                  ),
                )
                .toList();

            maybeEmit(PostsListLoaded(posts: posts));
          } on TypeError catch (_) {
            // do nothing, this will be moved to the data layer later.
          }
        });
  }
}
