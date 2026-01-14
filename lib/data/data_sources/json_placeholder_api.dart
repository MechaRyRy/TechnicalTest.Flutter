import 'dart:convert';

import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:http/http.dart' as http;

abstract class JsonPlaceholderApi {
  Future<List<PostSummary>> getPosts();
  Future<PostDetails?> getPostDetails(int postId);
}

class HttpBasedJsonPlaceholderApi implements JsonPlaceholderApi {
  final http.Client _httpClient;

  HttpBasedJsonPlaceholderApi({required http.Client httpClient})
    : _httpClient = httpClient;

  @override
  Future<List<PostSummary>> getPosts() => _httpClient
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/'))
      .then((response) {
        List<dynamic> responseList =
            json.decode(response.body) as List<dynamic>;
        final posts = responseList
            .map(
              (post) => PostSummary(
                id: post['id'],
                title: post['title'],
                body: post['body'],
              ),
            )
            .toList();

        return posts;
      })
      .catchError((_) => <PostSummary>[]);

  @override
  Future<PostDetails?> getPostDetails(int postId) => _httpClient
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'))
      .then((response) {
        final body = json.decode(response.body);
        if (body is Map<String, dynamic>) {
          return PostDetails(
            id: postId,
            title: body['title'],
            body: body['body'],
          );
        }
        return null;
      })
      .catchError((_) => null);
}
