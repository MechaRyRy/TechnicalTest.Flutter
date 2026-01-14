import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/posts_lists/post_item.dart';
import 'package:http/http.dart';

class PostsListPage extends StatefulWidget {
  final Client _httpClient;

  const PostsListPage({super.key, required Client httpClient})
    : _httpClient = httpClient;

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    widget._httpClient
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/'))
        .then((response) {
          setState(() {
            posts = json.decode(response.body);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key('posts_app_bar'),
        title: const Text("List of posts"),
      ),
      body: ListView(
        key: const Key('posts_list'),
        children: posts
            .map(
              (post) => PostItem(
                id: post['id'],
                title: post['title'],
                body: post['body'],
                onTap: () => Navigator.of(
                  context,
                ).pushNamed('details/', arguments: {'id': post['id']}),
              ),
            )
            .toList(),
      ),
    );
  }
}
