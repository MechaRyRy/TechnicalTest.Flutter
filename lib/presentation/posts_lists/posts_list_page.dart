import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/presentation/posts_lists/post_item.dart';
import 'package:flutter_tech_task/presentation/posts_lists/posts_list_cubit.dart';
import 'package:http/http.dart';

class PostsListPage extends StatefulWidget {
  final Client _httpClient;

  const PostsListPage({super.key, required Client httpClient})
    : _httpClient = httpClient;

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  PostsListCubit? cubit;

  @override
  void initState() {
    super.initState();
    cubit = PostsListCubit(httpClient: widget._httpClient);
  }

  @override
  void dispose() {
    cubit?.close();
    cubit = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key('posts_app_bar'),
        title: const Text("List of posts"),
      ),
      body: BlocBuilder<PostsListCubit, List<dynamic>>(
        bloc: cubit?..fetchPosts(),
        builder: (context, state) => ListView(
          key: const Key('posts_list'),
          children: state
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
      ),
    );
  }
}
