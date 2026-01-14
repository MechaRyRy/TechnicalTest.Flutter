import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/post_details/widgets/post_details_page.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/posts_list_page.dart';
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
        "list/": (context) => PostsListPage(httpClient: _httpClient),
        "details/": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          int id = args?['id'] ?? -1;
          return PostDetailsPage(id: id, httpClient: _httpClient);
        },
      },
    );
  }
}
