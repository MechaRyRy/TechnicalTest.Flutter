import 'package:flutter_tech_task/domain/entities/post_comment.dart';
import 'package:flutter_tech_task/presentation/post_comments/cubit/post_comments_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostCommentsCubit extends SafeEmissionCubit<PostCommentsState> {
  PostCommentsCubit() : super(PostCommentsLoading()) {
    maybeEmit(
      PostCommentsLoaded(
        postComments: [
          PostComment(
            commentId: 1,
            postId: 1,
            name: 'User1',
            email: 'mecharyry@gmail.com',
            body: 'This is a comment.',
          ),
          PostComment(
            commentId: 2,
            postId: 1,
            name: 'User2',
            email: 'majagodl@gmail.com',
            body: 'This is another comment.',
          ),
        ],
      ),
    );
  }
}
