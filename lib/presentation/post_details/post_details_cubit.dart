import 'dart:convert';

import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';
import 'package:http/http.dart';

class PostDetailsCubit extends SafeEmissionCubit<PostDetailsState> {
  final int _id;
  final Client _httpClient;

  PostDetailsCubit({required int id, required Client httpClient})
    : _id = id,
      _httpClient = httpClient,
      super(PostDetailsLoading());

  Future<void> fetchPost() async {
    _httpClient
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$_id'))
        .then((response) {
          maybeEmit(PostDetailsLoaded(post: json.decode(response.body)));
        });
  }
}

sealed class PostDetailsState {
  const PostDetailsState();
}

class PostDetailsLoading extends PostDetailsState {
  const PostDetailsLoading();
}

class PostDetailsLoaded extends PostDetailsState {
  final Map<String, dynamic> post;

  const PostDetailsLoaded({required this.post});
}
