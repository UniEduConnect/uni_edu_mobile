import 'package:flutter/material.dart';

import 'auth_controller.dart';

/// Provides the app-wide [AuthController] to the widget tree and rebuilds
/// dependents when auth state changes.
///
/// Wrap the app once with [AuthScope] (see `UniEduApp`), then read the
/// controller from any descendant:
///
/// ```dart
/// final auth = AuthScope.of(context);          // listens for changes
/// final auth = AuthScope.of(context, listen: false); // one-off action
/// ```
class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Looks up the nearest [AuthController]. Pass `listen: false` when you only
  /// need to call a method and don't want to rebuild on changes.
  static AuthController of(BuildContext context, {bool listen = true}) {
    final controller = maybeOf(context, listen: listen);
    assert(controller != null, 'AuthScope.of() called with no AuthScope in the tree');
    return controller!;
  }

  /// Like [of] but returns null when there is no [AuthScope] in the tree
  /// (e.g. in widget tests that pump a screen in isolation).
  static AuthController? maybeOf(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<AuthScope>()
        : context.getInheritedWidgetOfExactType<AuthScope>();
    return scope?.notifier;
  }
}
