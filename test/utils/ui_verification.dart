import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

/// Base class for UI element verification
/// Use this to create checks for elements in your UI tests
sealed class Check {
  /// The key of the element to verify
  final Key key;

  /// Constructor for Check
  const Check({required this.key});
}

/// Check that verifies an element is present and optionally checks its position
class Present extends Check {
  /// Key of element that this element should be below
  final Key? isBelow;

  /// Key of element that this element should be above
  final Key? isAbove;

  /// Key of element that this element should be to the right of
  final Key? isRightOf;

  /// Key of element that this element should be to the left of
  final Key? isLeftOf;

  /// Constructor for Present check
  const Present({
    required super.key,
    this.isBelow,
    this.isAbove,
    this.isRightOf,
    this.isLeftOf,
  });
}

/// Check that verifies an element is absent (not present) on the page
class Absent extends Check {
  /// Constructor for Absent check
  const Absent({required super.key});
}

/// Verifies UI elements based on the provided list of Check models
/// For each element:
/// 1. Checks if it is present or absent based on the type of check
/// 2. If present, verifies its position relative to other elements if specified
void verifyUiElements(WidgetTester tester, List<Check> elements) {
  for (final element in elements) {
    // Pattern match on the type of check
    switch (element) {
      case Absent():
        expect(
          find.byKey(element.key),
          findsNothing,
          reason:
              'Expected widget with key: ${element.key} to NOT be present on the page',
        );

      case Present():
        expect(
          find.byKey(element.key),
          findsOneWidget,
          reason: 'Expected to find widget with key: ${element.key}',
        );

        // Check position relative to another element if specified
        if (element.isAbove != null) {
          final elementLocation = tester.getTopLeft(find.byKey(element.key)).dy;
          final aboveLocation = tester
              .getTopLeft(find.byKey(element.isAbove!))
              .dy;
          expect(
            elementLocation < aboveLocation,
            isTrue,
            reason: 'Expected ${element.key} to be above ${element.isAbove}',
          );
        }

        if (element.isBelow != null) {
          final elementLocation = tester.getTopLeft(find.byKey(element.key)).dy;
          final belowLocation = tester
              .getTopLeft(find.byKey(element.isBelow!))
              .dy;
          expect(
            elementLocation > belowLocation,
            isTrue,
            reason: 'Expected ${element.key} to be below ${element.isBelow}',
          );
        }

        if (element.isRightOf != null) {
          final elementLocation = tester.getTopLeft(find.byKey(element.key)).dx;
          final rightOfLocation = tester
              .getTopLeft(find.byKey(element.isRightOf!))
              .dx;
          expect(
            elementLocation > rightOfLocation,
            isTrue,
            reason:
                'Expected ${element.key} to be to the right of ${element.isRightOf}',
          );
        }

        if (element.isLeftOf != null) {
          final elementLocation = tester.getTopLeft(find.byKey(element.key)).dx;
          final leftOfLocation = tester
              .getTopLeft(find.byKey(element.isLeftOf!))
              .dx;
          expect(
            elementLocation < leftOfLocation,
            isTrue,
            reason:
                'Expected ${element.key} to be to the left of ${element.isLeftOf}',
          );
        }
    }
  }
}
