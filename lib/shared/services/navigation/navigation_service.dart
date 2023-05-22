import 'package:flutter/material.dart';

abstract class NavigationService {
  GlobalKey<NavigatorState> get navigatorKey;
  Future<dynamic> pushNamed(String routeName, {Object? args});
  Future<dynamic> pushReplacementNamed(String routeName, {Object? args});
  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? args,
  });
  void pop([dynamic result]);
  Future<dynamic> push(Route<dynamic> route);
}

class NavigationServiceImpl implements NavigationService {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<dynamic> pushNamed(String routeName, {Object? args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  @override
  Future<dynamic> pushReplacementNamed(String routeName, {Object? args}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: args,
    );
  }

  @override
  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? args,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: args,
    );
  }

  @override
  void pop([dynamic result]) {
    return navigatorKey.currentState!.pop(result);
  }

  @override
  Future<dynamic> push(Route<dynamic> route) {
    return navigatorKey.currentState!.push(route);
  }
}
