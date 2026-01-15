import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/domain/entities/post_details.dart';

sealed class PostDetailsState extends Equatable {
  const PostDetailsState();
}

class PostDetailsLoading extends PostDetailsState {
  const PostDetailsLoading();

  @override
  List<Object?> get props => [];
}

class PostDetailsLoaded extends PostDetailsState {
  final PostDetails postDetails;
  final BookmarkAction action;

  const PostDetailsLoaded({required this.postDetails, required this.action});

  @override
  List<Object?> get props => [postDetails, action];
}

sealed class BookmarkAction extends Equatable {
  const BookmarkAction();
}

class AddBookmark extends BookmarkAction {
  final int postId;

  const AddBookmark({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class RemoveBookmark extends BookmarkAction {
  final int postId;

  const RemoveBookmark({required this.postId});

  @override
  List<Object?> get props => [postId];
}
