import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';
import 'package:flutter_tech_task/presentation/posts_lists/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/post_item.dart';

class BookmarkedPostsTab extends StatefulWidget {
  const BookmarkedPostsTab({super.key});

  @override
  State<BookmarkedPostsTab> createState() => _BookmarkedPostsTabState();
}

class _BookmarkedPostsTabState extends State<BookmarkedPostsTab> {
  @override
  void initState() {
    createBookmarkedTabScopedInjection(getIt);
    super.initState();
  }

  @override
  void dispose() {
    disposeBookmarkedTabInjection(getIt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsListCubit>(
      create: (context) => getIt<PostsListCubit>()..loadPosts(),
      child: _BookmarkedTabContent(),
    );
  }
}

class _BookmarkedTabContent extends StatelessWidget {
  const _BookmarkedTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsListCubit, PostsListState>(
      builder: (context, state) => switch (state) {
        PostsListLoading() => const Center(
          key: Key('bookmarked_posts_loading_indicator'),
          child: CircularProgressIndicator(),
        ),
        PostsListLoaded() => ListView(
          key: const Key('bookmarked_posts_list'),
          children: state.posts
              .map(
                (post) => PostItem(
                  id: post.id,
                  title: post.title,
                  body: post.body,
                  onTap: () =>
                      context.read<PostsListCubit>().navigateToDetails(post.id),
                ),
              )
              .toList(),
        ),
      },
    );
  }
}
