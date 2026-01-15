import 'dart:async';

import 'package:flutter_tech_task/data/data_sources/object_box.dart/object_box_persistence.dart';
import 'package:flutter_tech_task/domain/entities/post_details.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:rxdart/rxdart.dart';

abstract class JsonPlaceholderStore {
  Stream<List<PostSummary>> watchOfflinePosts();
  Future<void> savePostForOffline(PostDetails postDetails);
  Future<void> removePostFromOffline(int postId);
  Future<bool> isPostOffline(int postId);
}

class ObjectBoxJsonPlaceholderStore implements JsonPlaceholderStore {
  final ObjectBoxPersistence _objectBox;

  ObjectBoxJsonPlaceholderStore({required ObjectBoxPersistence objectBox})
    : _objectBox = objectBox;

  @override
  Stream<List<PostSummary>> watchOfflinePosts() {
    return _objectBox
        .persistentSummariesBox()
        .query()
        .watch(triggerImmediately: true)
        .map((query) {
          final summaries = query.find();
          return summaries
              .map(
                (e) => PostSummary(id: e.postId, title: e.title, body: e.body),
              )
              .toList();
        });
  }

  @override
  Future<void> savePostForOffline(PostDetails postDetails) async {
    final summary = PersistentPostSummary(
      postId: postDetails.id,
      title: postDetails.title,
      body: postDetails.body,
    );
    _objectBox.persistentSummariesBox().put(summary);
  }

  @override
  Future<void> removePostFromOffline(int postId) async {
    _objectBox.persistentSummariesBox().remove(postId);
  }

  @override
  Future<bool> isPostOffline(int postId) async {
    final summary = _objectBox.persistentSummariesBox().get(postId);
    return summary != null;
  }
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
