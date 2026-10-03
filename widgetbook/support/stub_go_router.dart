import 'package:go_router/go_router.dart';

enum NavKind {
  push('push'),
  go('go'),
  replace('replace'),
  pop('pop');

  const NavKind(this.label);

  final String label;
}

/// One navigation request a screen made.
class Navigation {
  const Navigation(this.kind, this.location, [this.extra]);

  final NavKind kind;
  final String location;
  final Object? extra;
}

/// A [GoRouter] that goes nowhere: it reports what the screen asked for and leaves the harness to show a placeholder, so
/// a catalog entry stays isolated from the real route table and its redirects (and never touches the URL Widgetbook uses).
/// Only the calls screens actually make are implemented; anything else fails loudly.
class StubGoRouter implements GoRouter {
  StubGoRouter({required this.onNavigate, required this.canPopNow});

  final void Function(Navigation navigation) onNavigate;
  final bool Function() canPopNow;

  @override
  void go(String location, {Object? extra}) => onNavigate(Navigation(NavKind.go, location, extra));

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    onNavigate(Navigation(NavKind.push, location, extra));
    return Future<T?>.value();
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(String location, {Object? extra}) {
    onNavigate(Navigation(NavKind.replace, location, extra));
    return Future<T?>.value();
  }

  @override
  Future<T?> replace<T>(String location, {Object? extra}) {
    onNavigate(Navigation(NavKind.replace, location, extra));
    return Future<T?>.value();
  }

  @override
  void pop<T extends Object?>([T? result]) => onNavigate(const Navigation(NavKind.pop, ''));

  @override
  bool canPop() => canPopNow();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('The Widgetbook stub router does not implement ${invocation.memberName}.');
}
