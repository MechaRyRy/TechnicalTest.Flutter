import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/posts_lists/post_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/ui_verification.dart';

void main() {
  testWidgets('Verify element position', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostItem(
            id: 1,
            title: 'Some Post Title',
            body: 'Some Post Body',
            onTap: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Some Post Title'), findsOneWidget);
    expect(find.text('Some Post Body'), findsOneWidget);

    verifyUiElements(tester, [
      const Present(key: Key('post_item_title:1')),
      const Present(
        key: Key('post_item_body:1'),
        isBelow: Key('post_item_title:1'),
      ),
    ]);
  });

  testWidgets('Verify tap callback', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostItem(
            id: 1,
            title: 'Some Post Title',
            body: 'Some Post Body',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tapped, isFalse);

    await tester.tap(find.byType(PostItem));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
