import 'package:flutter/material.dart';

class AppNavigator {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  Future<void> pushScaffoldMessenger<T extends Object?>(
    ScaffoldMessengerRoute route, {
    Object? arguments,
  }) async {
    ScaffoldMessenger.of(
      navigatorKey.currentContext!,
    ).showSnackBar(_scaffoldMessengerRoutes[route.name]!(arguments));
  }
}

enum ScaffoldMessengerRoute { error }

typedef ScaffoldMessengerRouteBuilder<T> = SnackBar Function(T arguments);

Map<String, ScaffoldMessengerRouteBuilder> _scaffoldMessengerRoutes = {
  "error": (_) => const SnackBar(content: Text('An error occurred.')),
};
