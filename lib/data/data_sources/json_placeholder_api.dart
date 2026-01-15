import 'dart:convert';

import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:http/http.dart' as http;

abstract class JsonPlaceholderApi {
  Future<List<PostSummary>> getPosts();
  Future<PostDetails> getPostDetails(int postId);
  Future<List<PostComment>> getPostComments(int postId);
}

class HttpBasedJsonPlaceholderApi implements JsonPlaceholderApi {
  final http.Client _httpClient;

  HttpBasedJsonPlaceholderApi({required http.Client httpClient})
    : _httpClient = httpClient;

  @override
  Future<List<PostSummary>> getPosts() => _httpClient
      .get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      )
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
      });

  @override
  Future<PostDetails> getPostDetails(int postId) => _httpClient
      .get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      )
      .then((response) {
        final body = json.decode(response.body);
        if (body is Map<String, dynamic>) {
          return PostDetails(
            id: postId,
            title: body['title'],
            body: body['body'],
            isOffline: false,
          );
        }
        return throw Exception('Invalid response format');
      });

  @override
  Future<List<PostComment>> getPostComments(int postId) => _httpClient
      .get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/posts/$postId/comments/',
        ),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      )
      .then((response) {
        List<dynamic> responseList =
            json.decode(response.body) as List<dynamic>;
        final posts = responseList
            .map(
              (post) => PostComment(
                commentId: post['id'],
                postId: post['postId'],
                name: post['name'],
                email: post['email'],
                body: post['body'],
              ),
            )
            .toList();

        return posts;
      });
}
