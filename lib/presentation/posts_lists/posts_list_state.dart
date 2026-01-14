sealed class PostsListState {
  const PostsListState();
}

class PostsListLoading extends PostsListState {
  const PostsListLoading();
}

class PostsListLoaded extends PostsListState {
  final List<Post> posts;

  const PostsListLoaded({required this.posts});
}

class Post {
  final int id;
  final String title;
  final String body;

  const Post({required this.id, required this.title, required this.body});
}
