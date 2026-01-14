import 'dart:convert';

import 'package:flutter/material.dart';
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

    return FutureBuilder<dynamic>(
      future: widget._httpClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/${args?['id']}'),
      ),
      builder: (post, response) {
        if (response.hasData) {
          dynamic data = json.decode(response.data!.body);
          return Scaffold(
            appBar: AppBar(title: const Text('Post details')),
            body: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(height: 10),
                  Text(data['body'], style: const TextStyle(fontSize: 16)),
                ],
              ),
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
        key: const Key('app_bar'),
        title: const Text("List of posts"),
      ),
      body: ListView(
        key: const Key('posts_list'),
        children: posts.map((post) {
          return InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed('details/', arguments: {'id': post['id']});
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key: Key("post_item:${post['id']}"),
                    post['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(post['body']),
                  Container(height: 10),
                  const Divider(thickness: 1, color: Colors.grey),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
