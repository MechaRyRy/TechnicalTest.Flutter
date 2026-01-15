import 'package:flutter/material.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/all_tab.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/bookmarked_tab.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/bookmarked_tab_header.dart';

class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  @override
  void initState() {
    super.initState();
    createPostsListPageScopedInjection(getIt);
  }

  @override
  void dispose() {
    disposePostsListPageInjection(getIt);
    super.dispose();
  }

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
              BookmarkedTabHeader(),
            ],
          ),
        ),
        body: TabBarView(children: [AllPostsTab(), BookmarkedPostsTab()]),
      ),
    );
  }
}
