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

  const PostDetailsLoaded({required this.postDetails});

  @override
  List<Object?> get props => [postDetails];
}
