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
          title: const Text('Post details'),
          actions: switch (state) {
            PostDetailsLoading() => [],
            PostDetailsLoaded(action: final action) => [
              BookmarkIcon(action: action),
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

class BookmarkIcon extends StatelessWidget {
  final PostDetailsAction action;

  const BookmarkIcon({super.key, required this.action});

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
