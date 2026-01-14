sealed class PostDetailsState {
  const PostDetailsState();
}

class PostDetailsLoading extends PostDetailsState {
  const PostDetailsLoading();
}

class PostDetailsLoaded extends PostDetailsState {
  final int id;
  final String title;
  final String body;

  const PostDetailsLoaded({
    required this.id,
    required this.title,
    required this.body,
  });
}
