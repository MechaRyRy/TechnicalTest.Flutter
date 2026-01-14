import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/post_details/widgets/post_details_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/ui_verification.dart';

void main() {
  testWidgets('Verify element position', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostDetailsItem(
            id: 1,
            title: 'Some Post Title',
            body: 'Some Post Body',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Some Post Title'), findsOneWidget);
    expect(find.text('Some Post Body'), findsOneWidget);

    verifyUiElements(tester, [
      const Present(key: Key('post_details_title:1')),
      const Present(
        key: Key('post_details_body:1'),
        isBelow: Key('post_details_title:1'),
      ),
    ]);
  });
}
