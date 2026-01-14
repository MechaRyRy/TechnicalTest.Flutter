import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/post_details/post_details_item.dart';
import 'package:http/http.dart';

class PostDetailsPage extends StatefulWidget {
  final Client _httpClient;

  const PostDetailsPage({super.key, required Client httpClient})
    : _httpClient = httpClient;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
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
