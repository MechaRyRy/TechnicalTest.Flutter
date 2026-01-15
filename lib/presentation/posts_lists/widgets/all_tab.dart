import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';
import 'package:flutter_tech_task/presentation/posts_lists/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/post_item.dart';

class AllPostsTab extends StatefulWidget {
  const AllPostsTab({super.key});

  @override
  State<AllPostsTab> createState() => _AllPostsTabState();
}

class _AllPostsTabState extends State<AllPostsTab> {
  @override
  void initState() {
    createAllTabScopedInjection(getIt);
    super.initState();
  }

  @override
  void dispose() {
    disposeAllTabInjection(getIt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsListCubit>(
      create: (context) => getIt<PostsListCubit>()..loadPosts(),
      child: _AllTabContent(),
    );
  }
}

class _AllTabContent extends StatelessWidget {
  const _AllTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsListCubit, PostsListState>(
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
    );
  }
}
