import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/all_tab.dart';

class PostsListPage extends StatelessWidget {
  const PostsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          key: const Key('posts_app_bar'),
          title: const Text("List of posts"),
          bottom: TabBar(
            key: const Key('posts_tab_bar'),
            tabs: [
              Tab(key: const Key('posts_tab_all'), text: "All"),
              Tab(key: const Key('posts_tab_bookmarked'), text: "Bookmarked"),
            ],
          ),
        ),
        body: TabBarView(children: [AllPostsTab(), Container()]),
      ),
    );
  }
}
