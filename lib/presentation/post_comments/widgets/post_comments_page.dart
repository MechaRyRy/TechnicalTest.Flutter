import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/l10n/app_localizations.dart';
import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_cubit.dart';
import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_state.dart';
import 'package:flutter_tech_task/presentation/post_comments/injection.dart';

class PostCommentsPage extends StatefulWidget {
  final int _id;

  const PostCommentsPage({super.key, required int id}) : _id = id;

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  @override
  void initState() {
    super.initState();
    createPostCommentsPageScopedInjection(getIt, widget._id);
  }

  @override
  void dispose() {
    disposePostCommentsPageScopedInjection(getIt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      key: Key('comments_app_bar'),
      title: Text(
        key: Key('comments_app_bar_title'),
        AppLocalizations.of(context)!.comments_page_title,
      ),
    ),
    body: BlocBuilder<PostCommentsCubit, PostCommentsState>(
      bloc: getIt<PostCommentsCubit>()..refreshPostComments(),
      builder: (context, state) {
        switch (state) {
          case PostCommentsLoading():
            return const Center(
              key: Key('comments_loading_indicator'),
              child: CircularProgressIndicator(),
            );
          case PostCommentsLoaded(:final postComments):
            return ListView.builder(
              key: Key('comments_list_view'),
              itemCount: postComments.length,
              itemBuilder: (context, index) {
                final comment = postComments[index];
                return ListTile(
                  key: Key('comment_tile_${comment.commentId}'),
                  title: Text(comment.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.email),
                      const SizedBox(height: 4),
                      Text(comment.body),
                    ],
                  ),
                );
              },
            );
        }
      },
    ),
  );
}
