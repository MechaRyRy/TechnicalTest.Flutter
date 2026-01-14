import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_cubit.dart';
import 'package:flutter_tech_task/presentation/post_details/widgets/post_details_item.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_state.dart';
import 'package:http/http.dart';

class PostDetailsPage extends StatelessWidget {
  final int _id;
  final Client _httpClient;

  const PostDetailsPage({
    super.key,
    required int id,
    required Client httpClient,
  }) : _id = id,
       _httpClient = httpClient;

  @override
  Widget build(BuildContext context) => BlocProvider<PostDetailsCubit>(
    create: (context) =>
        PostDetailsCubit(id: _id, httpClient: _httpClient)..fetchPost(),
    child: _PostDetailsPageContent(),
  );
}

class _PostDetailsPageContent extends StatelessWidget {
  const _PostDetailsPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsCubit, PostDetailsState>(
      builder: (cubit, state) => Scaffold(
        appBar: AppBar(
          key: Key('details_app_bar'),
          title: const Text('Post details'),
        ),
        body: switch (state) {
          PostDetailsLoading() => Container(),
          PostDetailsLoaded(postDetails: final postDetails) => PostDetailsItem(
            id: postDetails.id,
            title: postDetails.title,
            body: postDetails.body,
          ),
        },
      ),
    );
  }
}
