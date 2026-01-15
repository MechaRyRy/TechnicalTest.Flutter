import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_cubit.dart';
import 'package:flutter_tech_task/presentation/post_details/injection.dart';
import 'package:flutter_tech_task/presentation/post_details/widgets/post_details_item.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_state.dart';

class PostDetailsPage extends StatefulWidget {
  final int _id;

  const PostDetailsPage({super.key, required int id}) : _id = id;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  void initState() {
    super.initState();
    createScopedPostDetailsInjection(getIt, widget._id);
  }

  @override
  void dispose() {
    disposePostDetailsInjection(getIt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<PostDetailsCubit>(
    create: (context) =>
        getIt<PostDetailsCubit>(param1: widget._id)..loadDetails(),
    child: _PostDetailsPageContent(),
  );
}

class _PostDetailsPageContent extends StatelessWidget {
  const _PostDetailsPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsCubit, PostDetailsState>(
      builder: (cubit, state) => Scaffold(
        appBar: AppBar(
          key: Key('details_app_bar'),
          title: const Text(key: Key('details_app_bar_title'), 'Post details'),
          actions: switch (state) {
            PostDetailsLoading() => [],
            PostDetailsLoaded(
              postDetails: final postDetails,
              action: final action,
            ) =>
              [
                _BookmarkIcon(action: action),
                _CommentsIcon(postId: postDetails.id),
              ],
          },
        ),
        body: switch (state) {
          PostDetailsLoading() => Container(),
          PostDetailsLoaded(postDetails: final postDetails) => PostDetailsItem(
            id: postDetails.id,
            title: postDetails.title,
            body: postDetails.body,
          ),
        },
      ),
    );
  }
}

class _BookmarkIcon extends StatelessWidget {
  final BookmarkAction action;

  const _BookmarkIcon({required this.action});

  @override
  Widget build(BuildContext context) => IconButton(
    key: Key('details_bookmark_button'),
    icon: switch (action) {
      AddBookmark() => const Icon(Icons.bookmark_add_outlined),
      RemoveBookmark() => const Icon(Icons.bookmark),
    },
    onPressed: () => context.read<PostDetailsCubit>().performAction(action),
  );
}

class _CommentsIcon extends StatelessWidget {
  final int postId;

  const _CommentsIcon({required this.postId});

  @override
  Widget build(BuildContext context) => IconButton(
    key: Key('details_comments_icon'),
    icon: const Icon(Icons.comment),
    onPressed: () =>
        Navigator.of(context).pushNamed('comments/', arguments: {'id': postId}),
  );
}
