import 'package:flutter/material.dart';
import 'package:flutter_tech_task/app_navigator.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/post_comments/widgets/post_comments_page.dart';
import 'package:flutter_tech_task/presentation/post_details/widgets/post_details_page.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/posts_list_page.dart';

Future<void> main() async {
  await createApplicationLevelInjection(getIt);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: 'list/',
      navigatorKey: getIt<AppNavigator>().navigatorKey,
      routes: {
        "list/": (context) => const PostsListPage(),
        "details/": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          int id = args?['id'] ?? -1;
          return PostDetailsPage(id: id);
        },
        "comments/": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          int id = args?['id'] ?? -1;
          return PostCommentsPage(id: id);
        },
      },
    );
  }
}
