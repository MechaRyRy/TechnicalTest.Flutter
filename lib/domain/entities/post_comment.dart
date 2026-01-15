import 'package:equatable/equatable.dart';

class PostComment extends Equatable {
  final int postId;
  final int commentId;
  final String name;
  final String email;
  final String body;

  const PostComment({
    required this.postId,
    required this.commentId,
    required this.name,
    required this.email,
    required this.body,
  });

  @override
  List<Object?> get props => [postId, commentId, name, email, body];

  PostComment copyWith({
    int? postId,
    int? commentId,
    String? name,
    String? email,
    String? body,
  }) {
    return PostComment(
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      name: name ?? this.name,
      email: email ?? this.email,
      body: body ?? this.body,
    );
  }
}
