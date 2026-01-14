import 'package:flutter/material.dart';
import 'package:flutter_tech_task/injection.dart';
import 'package:flutter_tech_task/presentation/post_details/widgets/post_details_item.dart';
import 'package:flutter_tech_task/presentation/post_details/widgets/post_details_page.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/post_item.dart';
import 'package:flutter_tech_task/presentation/posts_lists/widgets/posts_list_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tech_task/main.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:integration_test/integration_test.dart';

import '../test/utils/ui_verification.dart';
import '../test/utils/fixtures.dart';

Client httpClient = Client();

const postsAppBarKey = Key('posts_app_bar');
const postsListKey = Key('posts_list');
const postItem1Key = Key('post_item:1');
const postItem2Key = Key('post_item:2');
const postItem3Key = Key('post_item:3');

const detailsAppBarKey = Key('details_app_bar');
const postDetailsTitle1Key = Key('post_details_title:1');
const postDetailsBody1Key = Key('post_details_body:1');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    setupInjection();
    getIt.allowReassignment = true;
    getIt.registerSingleton<Client>(
      MockClient((request) async {
        switch (request.url.path) {
          case '/posts/1':
            return Response(Fixtures.detailsPage1, 200);
          case '/posts/2':
            return Response(Fixtures.detailsPage2, 200);
          case '/posts/3':
            return Response(Fixtures.detailsPage3, 200);
          case '/posts/':
            return Response(Fixtures.listPage, 200);
        }
        return Response('', 404);
      }),
    );
  });

  group('Posts Page', () {
    testWidgets('Verify page is empty when data is not present', (
      WidgetTester tester,
    ) async {
      getIt.registerSingleton<Client>(
        MockClient((request) async => Response('{}', 404)),
      );
      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle();

      expect(find.byType(PostsListPage), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(PostItem), findsNothing);
    });

    testWidgets('Verify list page widget ordering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle();

      expect(find.byType(PostsListPage), findsOneWidget);
      verifyUiElements(tester, [
        const Present(key: postsAppBarKey),
        const Present(key: postsListKey, isBelow: postsAppBarKey),
        const Present(key: postItem1Key),
        const Present(key: postItem2Key, isBelow: postItem1Key),
        const Present(key: postItem3Key, isBelow: postItem2Key),
      ]);
    });

    testWidgets('Navigates to details page when tapping an item', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle();

      expect(find.byType(PostsListPage), findsOneWidget);
      expect(find.byKey(postItem1Key), findsOneWidget);
      await tester.tap(find.byKey(postItem1Key));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailsPage), findsOneWidget);
    });
  });

  group('Post Details Page', () {
    testWidgets('Verify page is empty when data is not present', (
      WidgetTester tester,
    ) async {
      getIt.registerSingleton<Client>(
        MockClient((request) async {
          switch (request.url.path) {
            case '/posts/':
              return Response(Fixtures.listPage, 200);
          }
          return Response('{}', 404);
        }),
      );

      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle();

      expect(find.byKey(postItem1Key), findsOneWidget);
      await tester.tap(find.byKey(postItem1Key));
      await tester.pumpAndSettle();

      // Since the mock client does not return data for post id 1, the details page should be empty
      expect(find.byType(PostDetailsPage), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(PostDetailsItem), findsNothing);
    });

    testWidgets('Verify details page widget ordering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle();

      expect(find.byKey(postItem1Key), findsOneWidget);
      await tester.tap(find.byKey(postItem1Key));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailsPage), findsOneWidget);
      verifyUiElements(tester, [
        const Present(key: detailsAppBarKey),
        const Present(key: postDetailsTitle1Key, isBelow: detailsAppBarKey),
        const Present(key: postDetailsBody1Key, isBelow: postDetailsTitle1Key),
      ]);
    });
  });
}
