import 'package:equatable/equatable.dart';

class PostDetails extends Equatable {
  final int id;
  final String title;
  final String body;
  final bool isBookmarked;

  const PostDetails({
    required this.id,
    required this.title,
    required this.body,
    required this.isBookmarked,
  });

  @override
  List<Object?> get props => [id, title, body, isBookmarked];
}
