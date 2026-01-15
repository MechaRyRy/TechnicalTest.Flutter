import 'dart:async';

import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:rxdart/rxdart.dart';

abstract class JsonPlaceholderStore {
  Stream<List<PostSummary>> watchOfflinePosts();
  Future<void> savePostForOffline(PostDetails postDetails);
  Future<void> removePostFromOffline(int postId);
  Future<bool> isPostOffline(int postId);
}

class InMemoryJsonPlaceholderStore implements JsonPlaceholderStore {
  final Map<int, PostSummary> _posts = {};

  final BehaviorSubject<List<PostSummary>> _controller =
      BehaviorSubject<List<PostSummary>>.seeded([]);

  InMemoryJsonPlaceholderStore();

  @override
  Stream<List<PostSummary>> watchOfflinePosts() => _controller.stream;

  @override
  Future<void> savePostForOffline(PostDetails postDetails) async {
    _posts[postDetails.id] = PostSummary(
      id: postDetails.id,
      title: postDetails.title,
      body: postDetails.body,
    );
    _notify();
  }

  @override
  Future<void> removePostFromOffline(int postId) async {
    if (_posts.containsKey(postId)) {
      _posts.remove(postId);
      _notify();
    }
  }

  @override
  Future<bool> isPostOffline(int postId) async {
    return _posts.containsKey(postId);
  }

  void _notify() => _controller.add(List.unmodifiable(_posts.values));

  void dispose() {
    _controller.close();
  }
}
