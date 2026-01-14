import 'package:flutter_tech_task/data/data_sources/json_placeholder_api.dart';
import 'package:flutter_tech_task/presentation/post_details/cubit/post_details_state.dart';
import 'package:flutter_tech_task/utils/safe_emission_cubit.dart';

class PostDetailsCubit extends SafeEmissionCubit<PostDetailsState> {
  final int _id;
  final JsonPlaceholderApi _jsonPlaceholderApi;

  PostDetailsCubit({
    required int id,
    required JsonPlaceholderApi jsonPlaceholderApi,
  }) : _id = id,
       _jsonPlaceholderApi = jsonPlaceholderApi,
       super(PostDetailsLoading());

  Future<void> fetchPost() async =>
      _jsonPlaceholderApi.getPostDetails(_id).then((postDetails) {
        if (postDetails != null) {
          maybeEmit(PostDetailsLoaded(postDetails: postDetails));
        }
      });
}
