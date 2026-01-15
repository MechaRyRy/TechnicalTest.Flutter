import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/posts_lists/cubit/bookmark_tab_header_cubit.dart';

class BookmarkedTabHeader extends StatelessWidget {
  const BookmarkedTabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: getIt<BookmarkTabHeaderCubit>(),
      builder: (context, state) {
        return Tab(
          key: const Key('posts_tab_bookmarked'),
          child: Badge(label: Text(key: Key('offline_posts_indicator'), '$state'), child: Text('Offline')),
        );
      },
    );
  }
}
