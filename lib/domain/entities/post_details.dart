import 'package:equatable/equatable.dart';

class PostDetails extends Equatable {
  final int id;
  final String title;
  final String body;
  final bool isOffline;

  const PostDetails({
    required this.id,
    required this.title,
    required this.body,
    required this.isOffline,
  });

  @override
  List<Object?> get props => [id, title, body, isOffline];

  PostDetails copyWith({
    int? id,
    String? title,
    String? body,
    bool? isOffline,
  }) {
    return PostDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}
