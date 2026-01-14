import 'dart:convert';

import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';
import 'package:http/http.dart';

class PostsListCubit extends SafeEmissionCubit<List<dynamic>> {
  final Client _httpClient;

  PostsListCubit({required Client httpClient})
    : _httpClient = httpClient,
      super([]);

  Future<void> fetchPosts() async {
    _httpClient
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/'))
        .then((response) {
          maybeEmit(json.decode(response.body));
        });
  }
}
