import 'dart:async';

class NavigationGuard {
  /// Callback that determines if navigation is allowed.
  /// Returns `true` or `null` to allow navigation, `false` to block it.
  FutureOr<bool?> Function()? checkIsAllowed;
}
