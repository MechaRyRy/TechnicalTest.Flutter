import 'package:flutter/material.dart';

class PostCommentsPage extends StatelessWidget {
  final int _id;

  const PostCommentsPage({super.key, required int id}) : _id = id;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      key: Key('comments_app_bar'),
      title: const Text(key: Key('comments_app_bar_title'), 'Post Comments'),
    ),
    body: Text('Loaded comments for post ID: $_id'),
  );
}
