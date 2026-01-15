import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/domain/entities/post_comment.dart';

sealed class PostCommentsState extends Equatable {
  const PostCommentsState();
}

class PostCommentsLoading extends PostCommentsState {
  const PostCommentsLoading();

  @override
  List<Object?> get props => [];
}

class PostCommentsLoaded extends PostCommentsState {
  final List<PostComment> postComments;

  const PostCommentsLoaded({required this.postComments});

  @override
  List<Object?> get props => [postComments];
}
