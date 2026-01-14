import 'dart:convert';

import 'package:flutter_tech_task/presentation/post_details/post_details_state.dart';
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
          try {
            final body = json.decode(response.body);
            if (body is Map<String, dynamic>) {
              maybeEmit(
                PostDetailsLoaded(
                  id: _id,
                  title: body['title'],
                  body: body['body'],
                ),
              );
              return;
            }
          } on TypeError catch (_) {
            // do nothing, this will be moved to the data layer later.
          }
        });
  }
}
