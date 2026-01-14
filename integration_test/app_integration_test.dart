import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tech_task/main.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:integration_test/integration_test.dart';

import '../test/utils/ui_verification.dart';
import '../test/utils/fixtures.dart';

Client theHttpClient = Client();

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
    theHttpClient = MockClient((request) async {
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
    });
  });

  testWidgets('Verify list page widget ordering', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(httpClient: theHttpClient));

    await tester.pumpAndSettle();

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
    await tester.pumpWidget(MyApp(httpClient: theHttpClient));

    await tester.pumpAndSettle();

    expect(find.byKey(postItem1Key), findsOneWidget);
    await tester.tap(find.byKey(postItem1Key));
    await tester.pumpAndSettle();

    verifyUiElements(tester, [
      const Present(key: detailsAppBarKey),
      const Present(key: postDetailsTitle1Key, isBelow: detailsAppBarKey),
      const Present(key: postDetailsBody1Key, isBelow: postDetailsTitle1Key),
    ]);
  });
}
