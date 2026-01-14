import 'dart:convert';

import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:http/http.dart' as http;

abstract class JsonPlaceholderApi {
  Future<Result<List<PostSummary>>> getPosts();
  Future<Result<PostDetails>> getPostDetails(int postId);
}

class HttpBasedJsonPlaceholderApi implements JsonPlaceholderApi {
  final http.Client _httpClient;

  HttpBasedJsonPlaceholderApi({required http.Client httpClient})
    : _httpClient = httpClient;

  @override
  Future<Result<List<PostSummary>>> getPosts() => _httpClient
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

        return Result.success(posts);
      })
      .onError<Exception>(
        (e, _) => Result<List<PostSummary>>.failureFromException(error: e),
      )
      .onError<Error>(
        (e, _) => Result<List<PostSummary>>.failureFromError(error: e),
      );

  @override
  Future<Result<PostDetails>> getPostDetails(int postId) => _httpClient
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'))
      .then((response) {
        final body = json.decode(response.body);
        if (body is Map<String, dynamic>) {
          return Result.success(
            PostDetails(id: postId, title: body['title'], body: body['body']),
          );
        }
        return Result<PostDetails>.failureFromException(
          error: Exception('Invalid response format'),
        );
      })
      .onError<Exception>(
        (e, _) => Result<PostDetails>.failureFromException(error: e),
      )
      .onError<Error>((e, _) => Result<PostDetails>.failureFromError(error: e));
}
