import 'package:equatable/equatable.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';

sealed class PostsListState extends Equatable {
  const PostsListState();
}

class PostsListLoading extends PostsListState {
  const PostsListLoading();

  @override
  List<Object?> get props => [];
}

class PostsListLoaded extends PostsListState {
  final List<PostSummary> posts;

  const PostsListLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}
