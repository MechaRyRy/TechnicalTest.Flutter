import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tech_task/main.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:integration_test/integration_test.dart';

import '../test/utils/ui_verification.dart';
import '../test/utils/fixtures.dart';

Client theHttpClient = Client();

const appBarKey = Key('app_bar');
const postsListKey = Key('posts_list');
const postItem1Key = Key('post_item:1');
const postItem2Key = Key('post_item:2');
const postItem3Key = Key('post_item:3');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    theHttpClient = MockClient((request) async {
      if (request.url ==
          Uri.parse('https://jsonplaceholder.typicode.com/posts/')) {
        return Response(Fixtures.listPage, 200);
      }
      return Response('', 404);
    });
  });

  testWidgets('Verify list page widget ordering', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(httpClient: theHttpClient));

    await tester.pumpAndSettle();

    verifyUiElements(tester, [
      const Present(key: appBarKey),
      const Present(key: postsListKey, isBelow: appBarKey),
      const Present(key: postItem1Key),
      const Present(key: postItem2Key, isBelow: postItem1Key),
      const Present(key: postItem3Key, isBelow: postItem2Key),
    ]);
  });
}
