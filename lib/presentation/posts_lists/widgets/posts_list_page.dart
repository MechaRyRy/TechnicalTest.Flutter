import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/post_item.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';

class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  @override
  void initState() {
    super.initState();
    createScopedPostListInjection(getIt);
  }

  @override
  void dispose() {
    disposePostDetailsInjection(getIt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsListCubit>(
      create: (context) => getIt<PostsListCubit>()..loadPosts(),
      child: _PostsListPageContent(),
    );
  }
}

class _PostsListPageContent extends StatelessWidget {
  const _PostsListPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key('posts_app_bar'),
        title: const Text("List of posts"),
      ),
      body: BlocBuilder<PostsListCubit, PostsListState>(
        builder: (context, state) => switch (state) {
          PostsListLoading() => Container(),
          PostsListLoaded() => ListView(
            key: const Key('posts_list'),
            children: state.posts
                .map(
                  (post) => PostItem(
                    id: post.id,
                    title: post.title,
                    body: post.body,
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed('details/', arguments: {'id': post.id}),
                  ),
                )
                .toList(),
          ),
        },
      ),
    );
  }
}
