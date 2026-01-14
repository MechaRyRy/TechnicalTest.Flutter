import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/presentation/post_details/post_details_cubit.dart';
import 'package:flutter_tech_task/presentation/post_details/post_details_item.dart';
import 'package:flutter_tech_task/presentation/post_details/post_details_state.dart';
import 'package:http/http.dart';

class PostDetailsPage extends StatefulWidget {
  final int _id;
  final Client _httpClient;

  const PostDetailsPage({
    super.key,
    required int id,
    required Client httpClient,
  }) : _id = id,
       _httpClient = httpClient;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  PostDetailsCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PostDetailsCubit(id: widget._id, httpClient: widget._httpClient);
  }

  @override
  void dispose() {
    _cubit?.close();
    _cubit = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PostDetailsCubit, PostDetailsState>(
        bloc: _cubit?..fetchPost(),
        builder: (cubit, state) => Scaffold(
          appBar: AppBar(
            key: Key('details_app_bar'),
            title: const Text('Post details'),
          ),
          body: switch (state) {
            PostDetailsLoading() => Container(),
            PostDetailsLoaded() => PostDetailsItem(
              id: state.id,
              title: state.title,
              body: state.body,
            ),
          },
        ),
      );
}
