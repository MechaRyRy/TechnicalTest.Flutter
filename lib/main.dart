import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/post_details/post_details_item.dart';
import 'package:flutter_tech_task/presentation/posts_lists/post_item.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp(httpClient: Client()));
}

class MyApp extends StatelessWidget {
  final Client _httpClient;

  const MyApp({super.key, required Client httpClient})
    : _httpClient = httpClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: 'list/',
      routes: {
        "list/": (context) => ListPage(httpClient: _httpClient),
        "details/": (context) => DetailsPage(httpClient: _httpClient),
      },
    );
  }
}

class ListPage extends StatefulWidget {
  final Client _httpClient;

  const ListPage({super.key, required Client httpClient})
    : _httpClient = httpClient;

  @override
  State<ListPage> createState() => _ListPageState();
}

class DetailsPage extends StatefulWidget {
  final Client _httpClient;

  const DetailsPage({super.key, required Client httpClient})
    : _httpClient = httpClient;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  dynamic post;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final id = args?['id'] ?? 'unknown';

    return FutureBuilder<dynamic>(
      future: widget._httpClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
      ),
      builder: (post, response) {
        if (response.hasData) {
          dynamic data = json.decode(response.data!.body);
          return Scaffold(
            appBar: AppBar(
              key: Key('details_app_bar'),
              title: const Text('Post details'),
            ),
            body: PostDetailsItem(
              id: id,
              title: data['title'],
              body: data['body'],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _ListPageState extends State<ListPage> {
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
