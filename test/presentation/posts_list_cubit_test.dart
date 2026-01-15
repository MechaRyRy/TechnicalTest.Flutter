import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_tech_task/app_navigator.dart';
import 'package:flutter_tech_task/domain/entities/post_summary.dart';
import 'package:flutter_tech_task/domain/entities/result.dart';
import 'package:flutter_tech_task/domain/usecases/watch_post_summaries_use_case.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_cubit.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/posts_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'posts_list_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppNavigator>(),
  MockSpec<WatchPostSummariesUseCase>(),
])
void main() {
  late MockAppNavigator mockAppNavigator;
  late MockWatchPostSummariesUseCase mockWatchPostSummariesUseCase;

  StreamController<Result<List<PostSummary>>> summariesController =
      StreamController.broadcast();

  setUp(() {
    mockAppNavigator = MockAppNavigator();
    mockWatchPostSummariesUseCase = MockWatchPostSummariesUseCase();

    when(
      mockWatchPostSummariesUseCase.watch(),
    ).thenAnswer((_) => summariesController.stream);
  });

  blocTest<PostsListCubit, PostsListState>(
    'emits loading',
    setUp: () =>
        when(mockWatchPostSummariesUseCase.refresh()).thenAnswer((_) async {
          summariesController.add(Result.loading());
        }),
    build: () => PostsListCubit(
      appNavigator: mockAppNavigator,
      watchPostSummariesUseCase: mockWatchPostSummariesUseCase,
    ),
    act: (cubit) => cubit.loadPosts(),
    expect: () => [PostsListLoading()],
  );

  blocTest<PostsListCubit, PostsListState>(
    'Pushes scaffold message when failing',
    setUp: () =>
        when(mockWatchPostSummariesUseCase.refresh()).thenAnswer((_) async {
          summariesController.add(
            Result.failureFromException(error: Exception('any')),
          );
        }),
    build: () => PostsListCubit(
      appNavigator: mockAppNavigator,
      watchPostSummariesUseCase: mockWatchPostSummariesUseCase,
    ),
    act: (cubit) => cubit.loadPosts(),
    verify: (_) => verify(
      mockAppNavigator.pushScaffoldMessenger(ScaffoldMessengerRoute.error),
    ),
  );

  blocTest<PostsListCubit, PostsListState>(
    'emits Loaded',
    setUp: () =>
        when(mockWatchPostSummariesUseCase.refresh()).thenAnswer((_) async {
          summariesController.add(
            Result.success([PostSummary(id: 1, title: 'title', body: 'body')]),
          );
        }),
    build: () => PostsListCubit(
      appNavigator: mockAppNavigator,
      watchPostSummariesUseCase: mockWatchPostSummariesUseCase,
    ),
    act: (cubit) => cubit.loadPosts(),
    expect: () => [
      PostsListLoaded(
        posts: [PostSummary(id: 1, title: 'title', body: 'body')],
      ),
    ],
  );
}
